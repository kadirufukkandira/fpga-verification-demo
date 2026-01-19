```markdown
# FPGA Verification Demo

[![FPGA Timer Verification CI](https://github.com/kadirufukkandira/fpga-verification-demo/actions/workflows/ci.yml/badge.svg)](https://github.com/kadirufukkandira/fpga-verification-demo/actions/workflows/ci.yml)

## Project Overview & Goals

This project, designed by **Kadir Ufuk Kandira**, demonstrates a complete, professional FPGA engineering workflow. It bridges the gap between clean RTL design and modern verification methodologies.

The core of the repository is a **Parametric Timer Module**, developed to illustrate the following engineering pillars:

* **RTL Design:** Clean, synthesis-ready VHDL code with high configurability.
* **Advanced Simulation:** Python-based automated verification using the **VUnit** framework.
* **Formal Verification:** Mathematical proofs ensuring correctness using **SymbiYosys (SBY)**.
* **Continuous Integration:** A fully automated testing pipeline via **GitHub Actions** that runs both simulation and formal proofs on every push.

### Technical Highlights

The `timer` entity is designed for reliability and ease of integration:

* **Parametric Precision:** The module internally calculates the target cycle count based on the input clock frequency (`clk_freq_hz_g`) and the desired delay generic (`delay_g`).
* **Robust Control Logic:**
    * Initiates counting on a `start_i` pulse.
    * **Input Protection:** Safely ignores start triggers if the timer is already busy counting.
    * **Status Reporting:** The `done_o` signal acts as a "Ready/Idle" indicator, remaining High (`'1'`) whenever the timer is not busy.
* **Synthesis Ready:** The design is fully synchronous (supporting synchronous reset) and is ready for physical FPGA deployment by simply mapping the ports and adjusting the generics.

## Local Development & Verification

Follow these steps to set up the environment and run tests on your local machine.

### 1. Prerequisites & Installation

You need the following tools installed on your system:

* **Python 3.x:** Required for the VUnit test runner.
    ```bash
    pip3 install vunit_hdl
    ```
* **GHDL:** An open-source VHDL simulator.
    * *Linux:* `sudo apt install ghdl` or via package manager.
    * *Windows:* Download the installer from the [GHDL GitHub Releases](https://github.com/ghdl/ghdl).
* **OSS CAD Suite (Required for Formal Verification):**
    * This suite includes **SymbiYosys (sby)** and **Yosys**.
    * Download from [YosysHQ/oss-cad-suite-build](https://github.com/YosysHQ/oss-cad-suite-build/releases).
    * *Note:* Ensure the `bin` folder of the CAD suite is added to your system's PATH.

### 2. Running VUnit Simulations

We use VUnit to manage test benches and simulate various frequency/delay scenarios automatically.

To run the full simulation suite:

```bash
python3 run.py -v

```

* **-v (verbose):** Displays detailed output of passing/failing tests in the terminal.
* The script will compile `src/timer.vhd` and `tb/tb_timer_vunit.vhd`, link them, and execute the test cases defined in the Python runner.

### 3. Running Formal Verification

Formal verification mathematically proves that the design adheres to specifications under *all* possible states, not just specific test cases.

To run the formal proofs using SymbiYosys:

```bash
sby -f timer.sby

```

* This reads the `timer.sby` configuration.
* It uses the properties defined in the PSL (Property Specification Language) within the VHDL code or separate verification units.
* **Success:** Means the design is proven correct for the specified depth.

---

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions CI Pipeline configuration
├── src/
│   └── timer.vhd             # Main VHDL RTL Source Code
├── tb/
│   ├── tb_timer_vivado.vhd   # Standard Testbench (Manual/Vivado usage)
│   └── tb_timer_vunit.vhd    # VUnit Compliant Testbench
├── AI_USAGE.md               # AI Tools Declaration
├── README.md                 # Project Documentation
├── run.py                    # VUnit Python Runner Script
└── timer.sby                 # SymbiYosys Formal Verification Config

```

```

```