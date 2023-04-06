.. _`fpga_upload`:

FPGA Upload
===========

Load bitstream
--------------

Make sure the FPGA board power is connected, the POWER switch on the board is turned on and the PROG USB port is connected to the host computer. The red LED below the power connector should be alight.

To flash the bitstream to the FPGA, use the following command::

    flow rvlab_fpga_top.program

Sometimes, this command fails on the first attempt. It should work on the second attempt.

Run software
------------

After bitstream flashing, the FPGA is in reset state by default.

To run the *monitor* program, which provides a simple interface for memory accesses::

    flow sw_monitor.run

To run the *student* program::
    
    flow sw_student.run

The *run* targets also perform a system reset. If the program is stuck, terminate the run command with Ctrl+C and restart it. The physical buttons on the FPGA board **cannot** be used for system reset.

Debug via GDB
-------------

**This step is not mandatory!**

After starting the *student* program with :code:`flow sw_student run`, you can also attach the GNU Debugger (GDB) to your running hardware for in-system debugging including single-stepping and full memory access. To do this, run :code:`riscv-none-embed-gdb build/sw_student/build/sw.elf` and establish the connection to OpenOCD with :code:`target extended-remote :3333` (command can also be abbreviated as :code:`tar ext :3333`).

The program is not stopped by default. Use :code:`step` for single stepping, :code:`break cmd_sw` to set a breakpoint on the *cmd_sw* function, :code:`continue` to resume execution etc.

Further reading:

- `GDB tutorial <https://people.astro.umass.edu/~weinberg/a732/gdbtut.html>`_
- `GDB documentation <https://sourceware.org/gdb/current/onlinedocs/gdb.html/>`_
