    .section .text.boot
    .option push
    .option norvc
    .org 0

    .rept 31
        nop 
    .endr
    jal x0, Global_ISR

    // reset vector
    .org 0x80
    jal x0, _start

    // illegal instruction exception
    .org 0x84
    jal x0, Global_ISR

    // ecall handler
    .org 0x88
    jal x0, Global_ISR

    .option pop

    .global _start
_start:

    li  x1, 0
    //li  x2, 0 // = sp
    li  x3, 0
    li  x4, 0
    li  x5, 0
    li  x6, 0
    li  x7, 0
    li  x8, 0
    li  x9, 0
    li  x10,0
    li  x11,0
    li  x12,0
    li  x13,0
    li  x14,0
    li  x15,0
    li  x16,0
    li  x17,0
    li  x18,0
    li  x19,0
    li  x20,0
    li  x21,0
    li  x22,0
    li  x23,0
    li  x24,0
    li  x25,0
    li  x26,0
    li  x27,0
    li  x28,0
    li  x29,0
    li  x30,0
    li  x31,0

    lui  sp,     %hi(_main_stack_top)
    addi sp, sp, %lo(_main_stack_top)
    
    jal hostio_init

    jal main

    lui  t0,     %hi(hostio + 0x800)
    addi t0, t0, %lo(hostio + 0x800)
    sw a0, 4(t0) # _hostid_start.retval = return value of main
    addi t1, zero, 1
    sw t1, 0(t0) # _hostid_start.flags = 1;

Global_ISR:
end_loop:
    j end_loop

