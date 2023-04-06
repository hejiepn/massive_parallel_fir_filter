.. _ex4:

Ex. 4: DMA / TL-UL host implementation
======================================

The past exercises only used a "register bus" device interface for transferring data to/from your student module. In this exercise you will extend a simple TL-UL host. This will form the base for your own, application specific bus master.

Objectives
----------

- working knowledge of Tilelink Uncached Lightweight (TL-UL)
- develop architectures using DMA controlled by simple descriptors  

Preparation
-----------

* Study the TileLink Uncached Lightweight (TL-UL) specification linked on the :ref:`resources` page. Read at least chapters 1-4 and 7. Only topics related to TL-UL must be read, i.e. skip sections dealing with TL-C and Bursts.

Tasks
-----

**1. Explore the example**

*rvlab/src/rtl/student/student_dma.sv* contains a TL-UL host implementing memset which fills a given memory area with a constant value.  The module *student_dma* is already instantiated in *rvlab/src/rtl/student/student.sv* and connected as a host and device to the main TL-UL crossbar. Its CPU accessible registers are defined in *rvlab/src/design/reggen/student_dma.json*.
  
Note: To simplify the operation of the bus master module only 32-bit accesses aligned to 4-byte boundaries are
used. Smaller accesses would involve more complex logic.

The descriptor is as follows:

======  ====  =======  ============================================================
offset  size  name     description
======  ====  =======  ============================================================
0x0     0x4   length   number of bytes to be set. 
0x4     0x4   src_adr  memset: fill value. memcpy: 1st address of the source buffer
0x8     0x4   dst_adr  1st address of the destination buffer
======  ====  =======  ============================================================

Simulate and test by running::

  flow systb_student.sim_rtl_questa


**2. Hardware implementation**

Extend the module to implement a function called memcpy, which copies one memory area to another. The register and descriptor definitions remain unchanged.
The module should use the maximum bandwidth available from the TL-UL interface, i.e. there should always be **simultaneous** (pending) read and write transactions. Use a (short) FIFO between read and write processes to achieve this.

**3. Software implementation**

A sample implementation of the memset function is available in student_dma.c/h. The function memset_soft is a complete software implementation of memset, memset_hard uses the hardware implementation to fill a memory area. There are already stubs for memcpy_soft and memcpy_hard. Extend memcpy_soft to contain a complete software implementation of mem copy with the same functionality as your hardware implementation. Complete memcpy_hard so it invokes your hardware implementation.

**4. Test cases**

There are test cases for memset in student_dma.c. Add appropriate test cases for your memcpy function!

Make sure you do not overwrite any substantial information, like the stack, data or code of your mini application. A small test_area is already allocated on the stack by the memset test case, which also contains two cookies to check whether the memory function corrupts any data out of the testing area. You can re-use this testing area for your memcpy test case, too.

**5. Benchmarking**

Compare the speed of the software implementation of memcpy and memset with the speed of the hardware component for the scenarios listed in the Deliverables_.  Measure the cycles from the write of the now_dadr register until the status register becomes 0 again.


Deliverables
------------

All deliverables should be submitted in a single PDF file.

**1. Source texts**

#. Verilog of your TL-UL host (excluding any generated code)
#. C of memcpy_soft and memcpy_hard
#. C of your memcpy test cases

**2. Wave views**

The wave views should be zoomed in as much as possible to only show the sections specified below. They should contain at least the clk signal, all CPU readable registers (status, length, src_adr, dst_adr) and the TL-UL host interface.

#. memcyp_hard: zoomed in view showing the transfer of at least 3 words
#. memcyp_soft: zoomed in view showing the transfer of at least 1 word

**3. Benchmarking results**

==========================  ================= ================= =====
operation                   software [cycles] hardware [cycles] ratio
==========================  ================= ================= =====
memset of 1kB in SRAM
memset of 1kB in DDR3
memcpy of 1kB SRAM to SRAM
memcpy of 1kB SRAM to DDR3
memcpy of 1kB DDR3 to SRAM
==========================  ================= ================= =====
