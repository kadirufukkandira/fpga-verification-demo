from vunit import VUnit
from vunit.sim_if import ghdl

# --- GHDL 5.x FIX ---
def patched_determine_backend(cls, prefix):
    return "mcode"

ghdl.GHDLInterface.determine_backend = classmethod(patched_determine_backend)
# --------------------

vu = VUnit.from_argv(compile_builtins=False)
vu.add_vhdl_builtins()

lib = vu.add_library("lib")
lib.add_source_files("src/*.vhd")
lib.add_source_files("tb/tb_timer_vunit.vhd")

tb = lib.test_bench("tb_timer_vunit")

# PARAMETERS
freqs = [10_000_000, 100_000_000]

# Delays in NANOSECONDS (Integers)
# 10000 = 10us, 100000 = 100us
delays_ns = [10000, 100000] 

for f in freqs:
    for d in delays_ns:
        # Create a descriptive name for the test
        test_name = f"Freq={int(f/1e6)}MHz_Delay={d}ns"
        
        tb.add_config(
            name=test_name,
            generics={
                "clk_freq_hz_g": f,
                "delay_ns_g": d   # Passing Integer to TB
            }
        )

vu.main()