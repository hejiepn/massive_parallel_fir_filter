#!/usr/bin/env python3
"""
(from openocd/contrib/)
OpenOCD RPC example, covered by GNU GPLv3 or later
Copyright (C) 2014 Andreas Ortmann (ortmann@finf.uni-hannover.de)
Example output:
./ocd_rpc_example.py
echo says hi!
target state: halted
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000188 msp: 0x10000fd8
variable @ 0x10000000: 0x01c9c380
variable @ 0x10000000: 0xdeadc0de
memory (before): ['0xdeadc0de', '0x00000011', '0xaaaaaaaa', '0x00000023',
'0x00000042', '0x0000ffff']
memory (after): ['0x00000001', '0x00000000', '0xaaaaaaaa', '0x00000023',
'0x00000042', '0x0000ffff']
"""

import socket
import itertools
import sys
import subprocess
import time
import tty
import termios
import select
from contextlib import contextmanager

class Hostio:
    OBUF_SIZE = 1024
    IBUF_SIZE = 1024

    OBUF      = 0x0003F000
    IBUF      = 0x0003F400
    FLAGS     = 0x0003F800
    RETVAL    = 0x0003F804
    OBUF_WIDX = 0x0003F808
    OBUF_RIDX = 0x0003F80C
    IBUF_WIDX = 0x0003F810
    IBUF_RIDX = 0x0003F814

def strToHex(data):
    return map(strToHex, data) if isinstance(data, list) else int(data, 16)

class OpenOcd:
    COMMAND_TOKEN = '\x1a'
    def __init__(self, verbose=False):
        self.verbose = verbose
        self.tclRpcIp       = "127.0.0.1"
        self.tclRpcPort     = 6666
        self.bufferSize     = 4096

        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def __enter__(self):
        self.connect()
        return self

    def __exit__(self, type, value, traceback):
        self.disconnect()

    def connect(self):
        self.sock.connect((self.tclRpcIp, self.tclRpcPort))

    def disconnect(self):
        try:
            self.send("exit")
        finally:
            self.sock.close()

    def send(self, cmd):
        """Send a command string to TCL RPC. Return the result that was read."""
        data = (cmd + OpenOcd.COMMAND_TOKEN).encode("utf-8")
        if self.verbose:
            print("<- ", data)

        self.sock.send(data)
        return self._recv()

    def _recv(self):
        """Read from the stream until the token (\x1a) was received."""
        data = bytes()
        while True:
            chunk = self.sock.recv(self.bufferSize)
            data += chunk
            if bytes(OpenOcd.COMMAND_TOKEN, encoding="utf-8") in chunk:
                break

        if self.verbose:
            print("-> ", data)

        data = data.decode("utf-8").strip()
        data = data[:-1] # strip trailing \x1a

        return data

    def loadImage(self, filename):
        self.send(f"load_image {filename} 0 elf")
        self.send("reg pc 0x80")
        self.send("riscv set_mem_access sysbus")

    def readword(self, address):
        #raw = self.send("mdw 0x%x" % address).split(": ")
        # ret = None if (len(raw) < 2) else strToHex(raw[1])
        raw = self.send(f"read_memory 0x{address:08x} 32 1")
        ret = int(raw, 0)
        return ret

    def writeword(self, address, value):
        #self.send("mww 0x%x 0x%x" % (address, value))
        self.send(f"write_memory 0x{address:08x} 32 0x{value:08x}")

    def writebyte(self, address, value):
        waddr = address &~3
        baddr = address & 3
        word = self.readword(waddr)
        word &= ~(0xff<<(baddr*8))
        word |= (value<<(baddr*8))
        self.writeword(waddr, word)
        #self.send("mwb 0x%x 0x%x" % (address, value))

    def writeMemory(self, wordLen, address, data):
        data = "{" + ' '.join(['0x%x' % x for x in data]) + "}"
        self.send("write_memory 0x%x %d %s" % (address, wordLen, data))


    def hostio_clear(self):
        self.writeword(Hostio.FLAGS, 0)
        self.writeword(Hostio.RETVAL, 0)
        self.writeword(Hostio.OBUF_WIDX, 0)
        self.writeword(Hostio.OBUF_RIDX, 0)
        self.writeword(Hostio.IBUF_WIDX, 0)
        self.writeword(Hostio.IBUF_RIDX, 0)
        self.obuf_ridx = 0
        self.ibuf_widx = 0

    def hostio_read(self):
        widx = self.readword(Hostio.OBUF_WIDX)

        wordaddr_last = -1
        while widx != self.obuf_ridx:
            wordaddr = Hostio.OBUF + (self.obuf_ridx&~3)
            if wordaddr != wordaddr_last:
                word = self.readword(wordaddr)
                wordaddr_last = wordaddr
            char = chr(word >> ((self.obuf_ridx&3)*8) & 0xff)
            if char == '\n':
                sys.stdout.write('\r\n')
            else:
                sys.stdout.write(char)
            sys.stdout.flush()
            self.obuf_ridx = (self.obuf_ridx + 1) & (Hostio.OBUF_SIZE-1)
        
        self.writeword(Hostio.OBUF_RIDX, self.obuf_ridx)

    def hostio_write(self, data):
        ridx = self.readword(Hostio.IBUF_RIDX)
        ibuf_enqueued = Hostio.IBUF_SIZE
        for char in data:
            while ibuf_enqueued >= Hostio.IBUF_SIZE:
                ibuf_enqueued = (self.ibuf_widx - ridx) & (Hostio.IBUF_SIZE - 1)

            self.writebyte(Hostio.IBUF + self.ibuf_widx, ord(char))
            self.ibuf_widx = (self.ibuf_widx + 1) & (Hostio.IBUF_SIZE-1)
            self.writeword(Hostio.IBUF_WIDX, self.ibuf_widx)



    def run_prog(self, elf_filename):
        self.send("halt")
        self.send("tcl_trace off")
        flags = 0
        self.hostio_clear()        

        print(f"Loading {elf_filename}...")

        self.loadImage(elf_filename)
        self.send("resume")

        print("Starting program.")

        time.sleep(1)

        old_settings = termios.tcgetattr(sys.stdin.fileno())
        try:
            tty.setraw(sys.stdin.fileno())
            while (flags & 1) == 0:
                flags = self.readword(Hostio.FLAGS)

                self.hostio_read()

                rready, _, _ = select.select([sys.stdin], [], [], 0)
                if len(rready) > 0:
                    c = sys.stdin.read(1)
                    #print(repr(c))
                    if c in ('\x03', '\x04'): #Ctrl+C or Ctrl+D
                        break
                    self.hostio_write(c)
        finally:
            termios.tcsetattr(sys.stdin.fileno(), termios.TCSADRAIN, old_settings)

        retval = self.readword(Hostio.RETVAL)
        print("Execution finished. Return value:", retval)

@contextmanager
def start(openocd_cfg):
    #proc = subprocess.Popen(["openocd", "-f", str(openocd_cfg)],
    #    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    proc = subprocess.Popen(["xterm", "-hold", "-e", f"openocd -f {openocd_cfg}"])
    #time.sleep(15)
    time.sleep(1)
    try:
        with OpenOcd() as ocd:
            yield ocd
    finally:
        proc.kill()
        print("Waiting for openocd to finish...")
        proc.wait()
