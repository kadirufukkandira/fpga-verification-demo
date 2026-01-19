# FPGA Verification Demo

![CI passing](https://github.com/kadirufukkandira/fpga-verification-demo/actions/workflows/ci.yml/badge.svg)
[![VUnit Simulation passing](https://github.com/kadirufukkandira/fpga-verification-demo/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/kadirufukkandira/fpga-verification-demo/actions)
[![Formal Verification passing](https://github.com/kadirufukkandira/fpga-verification-demo/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/kadirufukkandira/fpga-verification-demo/actions)

FPGA Verification Dashboard
![VUNIT SIMULATION passing](https://img.shields.io/badge/VUNIT_SIMULATION-passing-brightgreen)
![FORMAL VERIFICATION passing](https://img.shields.io/badge/FORMAL_VERIFICATION-passing-brightgreen)

This repository demonstrates a professional workflow for verifying an FPGA timer design. The project implements a parameterized timer module, verifies it using VUnit test benches, integrates the verification into CI via GitHub Actions, and includes support for formal verification.

Local setup requires Python 3, GHDL, VUnit, and optionally SymbiYosys for formal verification. Run the provided Python script to execute all tests locally.

To run VUnit simulation tests locally use:
python run.py

vbnet
Copy code

To run formal verification locally (with SymbiYosys installed):
sby timer.sby

vbnet
Copy code

The timer design is synthesis ready and can be integrated into FPGA builds for hardware testing.

Directory structure:

.
├── src VHDL RTL source files
├── tb VUnit based test benches
├── .github CI workflow configuration
├── run.py VUnit test runner
├── timer.sby Formal verification setup
├── AI_USAGE.md
└── README.md

pgsql
Copy code

All verification must pass in CI against every push before merges are accepted.
::contentReference[oaicite:0]{index=0}