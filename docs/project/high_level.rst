High Level Design
=================

**"HOW is your project build." -  Architecture: Partitioning and Interfaces**

Hardware top level block diagram
--------------------------------

Contains at least

* operating environment (e.g. hardware connected to the FPGA)
* all Verilog modules 
* all connections between modules and between modules and the environment using descriptive signal names 

Focus should be the student level and your modules, the rest of the (supplied) rvlab shall be drawn in an abstracted manner.

Software top level block diagram
--------------------------------

Contains at least

* all SW modules (HALs, libraries, major application components)
* all relationships between SW modules. Exception: Shared libraries can be displayed separately.
* show which SW module(s) access which HW module
* show if a module runs in an IRQ or in the main loop

For example you can use a layered diagram as shown in the exercise.

Modules
-------

Functionality, interface and verification of each module.

If a functionality is identical to the Functional Specification do *not* copy, just refer.

Verilog module X
~~~~~~~~~~~~~~~~

Mandatory for each verilog module

* functionality: *brief*, in bullet point form. Should be identical to the header comment of the verilog module. 
* interface

  * generated HTML of the register definitions (if the module has CPU accessible registers)
  * DMA descriptors (for TL-UL hosts)  
  * block memory layout (if used, e.g. video memory)

* verification plan: bullet points of the tests performed by your C code

Add everything else a programmer needs to know to use your module (e.g. timing diagrams, pseudo code for complex algorithms, ...)

HW module Y
~~~~~~~~~~~

Extension PCB / hardware build for this project.

* functionality: schematic This needs to be reviewed by the tutor before connecting to the FPGA board !
* interface: label all connections on the PCB as in the schematic to allow reuse in future projects.

SW module Z
~~~~~~~~~~~

"SW module" refers to a major SW components such as your application. HALs do not need to be documented.

Mandatory for each SW module

* functionality: *brief*, in bullet point form. Should be identical to the header comment of the C file.
* interface: function signatures and data structures

Optional

* verification plan: Saves more time than it costs. Anyway, optional.

