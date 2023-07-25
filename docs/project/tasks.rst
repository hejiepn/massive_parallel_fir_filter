Tasks
=====

This exercise sheet describes the tasks until completion your project.


1. Specification
----------------

Write the sections "Requirements Specification" and "Functional Specification" of your project’s documentation. Use the template *rvlab/docs/project/specification.rst*. Your project’s size should reflect the number of team members, i.e. have a minimum complexity coordinated with the tutor.

2. High level design
--------------------

Fill out the corresponding section *RVLAB/docs/project/high_level.rst* of the documentation template. As a minimum requirement your project should use interrupts wherever sensible and, at least at one point, a TL-UL host.

3. HW module creation
---------------------

Every team member should develop a (small) Verilog module and the software necessary to integrate the module into the project (HAL and optional higher driver layers). 

Each Verilog module should be accompanied by a C test bench which verifies the entire functionality of the module and the HAL in the rvlab system. For this it may be necessary to add software configurable HW test structures (such as for the IRQ controller) to the design to be able to test the hardware modules in the system simulation as well later on the FPGA.

Also implement models of the external hardware used and instantiate them in *src/fv/rvlab_board.sv*. For example if your design uses the Ethernet PHY, the model should emulate the Phys RGMII interface to the FPGA, sending data read from a file and dumping the received data into another file. 

Synthesize and P&R your module as early as possible to find non synthesizable HDL.

4. System integration & tests
-----------------------------

When all hardware modules are verified individually write a "mini application" with only the minimal possible functionality which uses all hardware modules together as in the final application. 

Perform a netlist simulation of this "mini application" running on the P&R netlist.


5. FPGA upload & application development
----------------------------------------

Prerequisites for FPGA board access:

* successful netlist simulation of "mini application" (see above)
* review by tutor of synthesis, P&R & bitgen transcripts & reports (warning & error messages)
* if you build your own PCB: see PCB checklist in :ref:`high_level`

Read the :ref:`fpga_upload` tutorial, esp. the notes regarding handling of the FPGA board. 

Develop the final application on the FPGA board. 


6. Live demonstration
---------------------

All features promised in the function specification have to be presented to the tutor.
Alternatively, submit a video showing all features. This can be the video of the presentation (if it demonstrates all promised features) or a 2nd "boring" video covering all features.

7. Presentations
----------------

Two presentations are scheduled

* Mid term presentation
    * High level design (including modules!)

* Final presentation

    * final date to complete the project, only the project documentation can be handed in afterwards.
    * each team member must be present
    * strict time limit per group
    * show a (short) video demonstrating the project

8. Project documentation
------------------------

Complete your project documentation by filling out the template *rvlab/docs/project/results.rst*.


Deliverables
------------

Each deliverables should be submitted as a single PDF file.

    #. for task 1: Requirements and functional specification (due date: one week after the exercise, deadline: two weeks). Please continue working on the project only after your requirements and functional specification has been signed off. This guards against accidentally starting a project too simple (or too complex).

    #. for 2: High level design (due date: mid term presentation). It is recommended to hand in the complete high-level design before proceeding to the implementation to make conceptual errors which might manifest only very late in the project cycle more unlikely.

    #. for 3: Individual deliverables (due date: before final presentation). Every team member hands in the following components of his/hers HW module in a single pdf for a short personal review:

        - module section of the documentation    
        - Verilog code (excluding the auto generated code)
        - HAL
        - C test bench

    #. for 7: slides of the mid term presentation (4 days before mid term presentation)

    #. for 7: slides & video of the final presentation (one week before final presentation)

    #. project itself & project documentation (git pull request)