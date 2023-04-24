.. _resources:

Resources
=========

Xilinx Hardware & Design Tools
------------------------------
- `7 Series Product Tables and Product Selection Guide (XMP101)`_ The last page contains links to the most important user guides (CLBs, rams, DSPs, IOs, ...)
- `Vivado Design Suite 7 Series FPGA and Zynq-7000 SoC Libraries Guide UG953 (v2021.2) October 22, 2021`_ Instance templates for all library primitives
- `UltraFast Design Methodology Timing Closure Quick Reference Guide (UG1292)`_
- `Vivado Design Suite Tcl Command Reference Guide (UG835)`_
- `Vivado Design Suite Properties Reference Guide (UG912)`_

Digilent Nexys Video FPGA Board:

- `Nexys Video Reference Manual <https://digilent.com/reference/programmable-logic/nexys-video/reference-manual>`_ (:download:`local PDF copy<res/nexys-video_rm.pdf>`)
- `Nexys Video schematic <https://digilent.com/reference/_media/reference/programmable-logic/nexys-video/nexys_video_sch.pdf>`_

RISC-V System
-------------

- `RISC-V Instruction Set Manual Vol. I: Unprivileged ISA <https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf>`_
- `RISC-V Instruction Set Manual Vol. II: Privileged ISA <https://github.com/riscv/riscv-isa-manual/releases/download/Priv-v1.12/riscv-privileged-20211203.pdf>`_
- `TileLink Spec`_ (:download:`local PDF copy<res/tilelink-spec-1.8.0.pdf>`)

- OpenTitan's `Reggen manual <https://opentitan.org/book/util/reggen/index.html>`_ (differs in details from the version used in rvlab!)
- OpenTitan's `Crossbar Generation tool manual <https://opentitan.org/book/util/tlgen/index.html>`_ (differs in details from the version used in rvlab!)

- `Ibex Documentation <https://ibex-core.readthedocs.io/en/latest/index.html>`_
- `Ibex Github page <https://github.com/lowRISC/ibex>`_

SystemVerilog
-------------

- `System Verilog for synthesis <https://verilogguide.readthedocs.io/en/latest/verilog/systemverilog.html>`_
- `Verilog Language reference manual (LRM) <https://ieeexplore.ieee.org/document/8299595>`_ (the authorative source to consult for in depth questions, e.g. how a certain language element is to be handeled by a simulator).


TUB
---

- Modulbeschreibung_
- `MSC Website`_

Recommended External IP
-----------------------

The following projects are not integrated into rvlab but could be useful for student projects:

- `verilog-ethernet <https://github.com/alexforencich/verilog-ethernet>`_
- For HDMI output: `display_controller <https://github.com/projf/display_controller>`_


.. _7 Series Product Tables and Product Selection Guide (XMP101): https://docs.xilinx.com/v/u/en-US/7-series-product-selection-guide
.. _Vivado Design Suite 7 Series FPGA and Zynq-7000 SoC Libraries Guide UG953 (v2021.2) October 22, 2021: https://www.xilinx.com/content/dam/xilinx/support/documents/sw_manuals/xilinx2021_2/ug953-vivado-7series-libraries.pdf

.. _UltraFast Design Methodology Timing Closure Quick Reference Guide (UG1292): https://www.xilinx.com/content/dam/xilinx/support/documents/sw_manuals/xilinx2022_1/ug1292-ultrafast-timing-closure-quick-reference.pdf
.. _Vivado Design Suite Tcl Command Reference Guide (UG835): https://docs.xilinx.com/r/en-US/ug835-vivado-tcl-commands
.. _Vivado Design Suite Properties Reference Guide (UG912): https://docs.xilinx.com/r/en-US/ug912-vivado-properties

.. _TileLink Spec: https://starfivetech.com/uploads/tilelink_spec_1.8.1.pdf


.. _Modulbeschreibung: https://moseskonto.tu-berlin.de/moses/modultransfersystem/bolognamodule/beschreibung/anzeigen.html?nummer=41097&version=1&sprache=1
.. _MSC Website: https://www.tu.berlin/msc/studium-lehre/lehrveranstaltungen-sose/soc
