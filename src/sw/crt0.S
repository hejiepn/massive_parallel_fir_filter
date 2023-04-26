    .section .text.boot
    .option push
    .option norvc
    .org 0
    
    nop
    nop
    nop
    nop #3 irq_software_i
    nop #4
    nop #5
    nop #6
    nop #7 irq_timer_i
    nop #8
    nop #9
    nop #10
    jal x0, irq_entry #11 irq_external_i
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jal x0, irq_exception

    // reset vector
    .org 0x80
    jal x0, _start

    // illegal instruction exception
    .org 0x84
    jal x0, irq_exception

    // ecall handler
    .org 0x88
    jal x0, irq_exception

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
    
    lui  gp,     %hi(_irq_stack_top)
    addi gp, gp, %lo(_irq_stack_top)
	csrrw      zero,mscratch,gp
	li gp,0

    lui  sp,     %hi(_main_stack_top)
    addi sp, sp, %lo(_main_stack_top)
    
    jal hostio_init
    
    
    jal main

    lui  t0,     %hi(hostio + 0x800)
    addi t0, t0, %lo(hostio + 0x800)
    sw a0, 4(t0) # _hostid_start.retval = return value of main
    addi t1, zero, 1
    sw t1, 0(t0) # _hostid_start.flags = 1;


irq_exception:
end_loop:
    j end_loop


irq_entry:
	csrrw      sp,mscratch,sp
	addi       sp,sp,-0x80
	sw         ra,0x0(sp)
	sw         gp,0x4(sp)
	sw         tp,0x8(sp)
	sw         t0,0xc(sp)
	sw         t1,0x10(sp)
	sw         t2,0x14(sp)
	sw         s0,0x18(sp)
	sw         s1,0x1c(sp)
	sw         a0,0x20(sp)
	sw         a1,0x24(sp)
	sw         a2,0x28(sp)
	sw         a3,0x2c(sp)
	sw         a4,0x30(sp)
	sw         a5,0x34(sp)
	sw         a6,0x38(sp)
	sw         a7,0x3c(sp)
	sw         s2,0x40(sp)
	sw         s3,0x44(sp)
	sw         s4,0x48(sp)
	sw         s5,0x4c(sp)
	sw         s6,0x50(sp)
	sw         s7,0x54(sp)
	sw         s8,0x58(sp)
	sw         s9,0x5c(sp)
	sw         s10,0x60(sp)
	sw         s11,0x64(sp)
	sw         t3,0x68(sp)
	sw         t4,0x6c(sp)
	sw         t5,0x70(sp)
	sw         t6,0x74(sp)
	//csrrs      a1,mepc,zero
	sw         a1,0x78(sp)
	//csrrs      a0,mcause,zero
	//csrrs      a2,mtval,zero
	lw         t0,0x7c(sp)
	
	jal        irq_handler
	
# restore the saved registers before exiting IRQ
	lw         t0,0x78(sp)
	//csrrw      zero,mepc,t0
	lw         t6,0x74(sp)
	lw         t5,0x70(sp)
	lw         t4,0x6c(sp)
	lw         t3,0x68(sp)
	lw         s11,0x64(sp)
	lw         s10,0x60(sp)
	lw         s9,0x5c(sp)
	lw         s8,0x58(sp)
	lw         s7,0x54(sp)
	lw         s6,0x50(sp)
	lw         s5,0x4c(sp)
	lw         s4,0x48(sp)
	lw         s3,0x44(sp)
	lw         s2,0x40(sp)
	lw         a7,0x3c(sp)
	lw         a6,0x38(sp)
	lw         a5,0x34(sp)
	lw         a4,0x30(sp)
	lw         a3,0x2c(sp)
	lw         a2,0x28(sp)
	lw         a1,0x24(sp)
	lw         a0,0x20(sp)
	lw         s1,0x1c(sp)
	lw         s0,0x18(sp)
	lw         t2,0x14(sp)
	lw         t1,0x10(sp)
	lw         t0,0xc(sp)
	lw         tp,0x8(sp)
	lw         gp,0x4(sp)
	lw         ra,0x0(sp)
	addi       sp,sp, 0x80
	csrrw      sp,mscratch,sp
	mret
	