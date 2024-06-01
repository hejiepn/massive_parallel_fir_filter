.. _ex1:

Ex. 1: HDL entry and simulation
===============================

Objectives
----------

- solve simple problem using HDL

  - register read / write
  - simple state machines

- RTL simulation using QuestaSim
- get an overview of the rvlab repository

Preparation
-----------

* First of all it is necessary to get to know the overall :ref:`directory_structure` of the RISC-V laboratory.
* Make yourself familiar with the basics of the :ref:`design_flow`.
* If you haven't used QuestaSim before read the :ref:`questa_sim` tutorial.
* If you a new to System Verilog take part in the System Verilog crash course and study the "Verilog" section on the :ref:`resources` page.

**Blinkenlichten (start up project)**

As an introductory project a simple running light (blinkenlichten_) is to be designed and simulated which controls the eight LEDs connected to the FPGA.

Tasks
-----

**1. Develop a running light with the following functionality**

- Any LED pattern can be programmed into a pattern register
- There should be four modes of the running light:

  - **rotation left**: The pattern is shifted left (in direction of the MSB, bit 7) every N clock cycles. The value of bit 7 is shifted to bit 0.
  - **rotation right**: The pattern is shifted right (in direction of the LSB, bit 0) every N clock cycles. The value of bit 0 is shifted to bit 7.
  - **ping pong**: The pattern is shifted left every N clock cycles until the initial value from bit 0 has reached bit 7.
    The values shifted beyond bit 7 are not copied to bit 0 but are preserved internally.
    After the value of bit 0 has reached bit 6 the direction is reversed. 
    The bits previously shifted out appear successively at bit 7 until the original pattern is restored. Then the pattern is
    shifted further right until the original value of bit 7 has reached bit 0 upon which the direction
    is reversed again.     
  - **stop**: The currently displayed pattern is kept.

- N should be programmable with a register (Note: the FPGA internally operates with 60 MHz).
- A status register reflects the current status of the LEDs
- All registers must be readable by the CPU via the register bus.
- A maximum of four 32bit addresses (relative addresses 0x0, 0x4, 0x8, 0xC) of the address space may be used to access the registers of the running light.
- After a reset your running light should start in ping pong mode with a reasonable speed and pattern. In the final project this pattern is used to distinguish your project from the other projects when loaded into the FPGA.

Use the template *rvlab/src/rtl/student/student_rlight.sv* to implement your running light.
It contains *tul_adapter_reg* converting TileLink Uncached Lightweight (TL-UL)  to the register bus to be used by your code.
Replace / modify the demo FSM and register read write processes to implement the running light.

.. image:: res/rlight_tb.svg
   :width: 600

**2. Simulate**

Test your running light with the test bench *rvlab/src/fv/student_rlight_tb.sv* , which instantiates your running light and simulates TL-UL write accesses to
your module.

Extend the test bench to cover the following functionality:

* All registers should be read and written at least once.
* All modes should be tested at least once
* Check how the design behaves if the pattern or delay is changed during operation (i.e. delay changes from 10 to 20 to 8 cycles). At no time should a delay or pattern be displayed which has not been programmed. 

To compile your design and invoke QuestaSim for simulation *from the rvlab directory*::

  flow student_rlight_tb.sim_rtl_questa

.. _blinkenlichten: https://en.wikipedia.org/wiki/Blinkenlights
.. _Blinkenlichten: https://en.wikipedia.org/wiki/Blinkenlights
