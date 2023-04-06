.. _questa_sim:

QuestaSim Guide
===============

Ultra brief introduction to QuestaSim for new users.

Prerequisite: QuestaSim installed, environmental variables set and added to $PATH, see :ref:`setup`.

Compiling & loading
-------------------

Example: Running light from :ref:`ex1`

*Using the flow*::

    flow rlight_tb.sim_rtl_questa


*Manual*::

    vlib work                                                                   # create directory work as the library "work" to complile the source texts to
    vlog src/rtl/rvlab_fpga/pkg/top_pkg.sv  src/rtl/tlul/pkg/tlul_pkg.sv        # compile the packages before the files which use them !
    vlog -mfcu src/rtl/inc/prim_assert.sv src/rtl/tlul/tlul_adapter_reg.sv src/rtl/tlul/tlul_err.sv 
    vlog src/rtl/student/student_rlight.sv src/fv/tlul_test_host.sv src/fv/student_rlight_tb.sv # compile the design and testbench
    vsim work.student_rlight_tb                                                 # start the simulator and load the design rlight_tb

Verilog modules can be compiled in any order as linking happens at run time. Packages must be compiled before use.

These steps compile student_rlight, start the simulator loading student_rlight_tb (click to enlarge):

.. image:: res/QuestaSim_design.drawio.svg
   :width: 800

Tracing  & formatting signals
-----------------------------

During simulation QuestaSim only records signals which have been added to the wave window:

1. The "sim" view contains a hierarchical view of the loaded design.

2/3. All signals of the selected instance are shown in the "Objects" window.

4. Drag & drop the signals you want to trace to the wave window.

5. Format the wave view

* use "Combine Signals" to create a vector of individual selected (use shift) signals e.g. in netlist simulation when a vector has been split up into individual flip flops.
* use "Radix" for e.g. hexadecimal or binary display and "Format" for e.g. analog signals

6. Save the Wave formatting. "File -> Save Format". Save the resulting .do file as *src/design/wave/<toplevel name>.do* so it is automatically loaded by the flow.


Run the simulation
------------------

`I.` restart

`II.` run -all

View the results
----------------

A. Fit the entire simulation run to the wave view.

B. Use click & drag the middle mouse button inside the wave view to zoom.

C. Place a time cursor.

D. Move the cursor to the next edge of the selected signal in the wave view (e.g. to find the next TL-UL transfer).

Other features
--------------

From the "View" menu

* "Dataflow": Drag & Drop a signal to trace it through the hierarchy.

* loads more (Profiler, ....)