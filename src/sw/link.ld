OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x00000000;

  .text.boot : { *(.text.boot) } 

  . = 0x400;
  .text.lib : { *libc.a:*(.text .text.*) }
  .data.lib : { *libc.a:*(.data .data.* .rodata .rodata.* .sdata .sdata.* .srodata .srodata.*) }
  .bss.lib : { *libc.a:*(.bss .eh_frame .sbss) }


  .text : { *(.text .text.*) }
  .data : { *(.data .data.* .rodata .rodata.* .sdata .sdata.* .srodata .srodata.*)  }

  /* _memory_init_start = .; */

  .bss : { *(.bss .eh_frame .sbss) }
  _main_stack_top = 0x00038000;
  _irq_stack_top = 0x0003F000;
  hostio = 0x0003F000;
}