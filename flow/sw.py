from pydesignflow import Block, task, Result
from .tools.build_sw import build_sw, build_static_lib
from .tools.elf2mem import elfdelta
from .tools import openocd
from pathlib import Path
from .tools.overlay import filter_solutions_overlay

class Libc(Block):
    """
    A small libc providing basic system functions such as printf, memcpy etc.
    (`Baselibc <https://github.com/PetteriAimonen/Baselibc>`_)
    """

    def setup(self):
        self.src_dir = self.flow.base_dir / "src"

    @task(requires={'reggen':'reggen.generate'},hidden=True)
    def build(self, cwd, reggen):
        """
        Builds library for static linking (.a).
        """
        r = Result()

        sw_dir = self.src_dir / "sw"
        baselibc_src_dir = sw_dir / "baselibc/src"
        baselibc_templates_include = sw_dir / "baselibc/src/templates"
        baselibc_include_dir = sw_dir / "baselibc/include"
        srcs = list(baselibc_src_dir.glob("*.c"))
        user_includes = sw_dir / "include"

        r.lib = cwd / "baselibc.a"

        build_static_lib(cwd, srcs, r.lib,
            include_system=[baselibc_include_dir],
            include_quote=[
                baselibc_templates_include,
                reggen.c_include_dir,
                user_includes,
                ])

        return r

class Program(Block):
    """Program for the RISC-V CPU"""

    def __init__(self, name, **kwargs):
        """
        Args:
            name: Name of src/sw/ subdirectory containing program-specific
                sources files.
        """
        super().__init__(**kwargs)
        self.name = name

    def setup(self):
        self.src_dir = self.flow.base_dir / "src"
        self.design_dir = self.src_dir / "design"

    @task(requires={
        'libc':'libc.build',
        'reggen':'reggen.generate',
        }, hidden=True, always_rebuild=True)
    def build(self, cwd, libc, reggen):
        """
        Main program for simulation and later use on FPGA.
        """
        r = Result()

        sw_dir = self.src_dir / "sw"
        ldscript = str(sw_dir / "link.ld")
        main_dir = sw_dir / self.name
        baselibc_include_dir = sw_dir / "baselibc/include"
        user_includes = sw_dir / "include"

        srcs = []
        srcs += list(main_dir.glob("*.S"))
        srcs += list(main_dir.glob("*.c"))

        # Shared source files in sw/ folder:
        srcs += list(sw_dir.glob("*.S")) # should be [crt0.S] at the moment
        srcs += list(sw_dir.glob("*.c")) # should be [hostio.c] at the moment

        srcs = filter_solutions_overlay(srcs, self.src_dir)

        r.elf = cwd / "sw.elf"
        r.mem = cwd / "sw.mem"
        r.disasm = cwd / "sw.disasm"

        build_sw(
            cwd=cwd,
            srcs=srcs,
            ldscript=ldscript,
            output_elf_filename=r.elf,
            output_disasm_filename=r.disasm,
            output_mem_filename=r.mem,
            static_libs=[libc.lib],
            include_system=[baselibc_include_dir],
            include_quote=[reggen.c_include_dir, user_includes],
        )

        return r

    @task(requires={'build':'.build'})
    def run(self, cwd, build):
        """Run on FPGA via OpenOCD"""
        with openocd.start(self.design_dir / "openocd/fpga.cfg") as ocd:
            ocd.run_prog(build.elf)
            #input("Press enter to continue...")

    @task(requires={'build':'.build', 'ref_build':'ref.build'}, hidden=True, always_rebuild=True)
    def delta(self, cwd, build, ref_build):
        """Differential image for fast loading in simulator"""
        r = Result()
        r.deltafile = cwd / "delta"
        elfdelta(build.elf, ref_build.elf, r.deltafile)
        return r