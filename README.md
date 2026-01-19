# FPGA Verification Demo

[![FPGA Timer Verification CI](https://github.com/kadirufukkandira/fpga-verification-demo/actions/workflows/ci.yml/badge.svg)](https://github.com/kadirufukkandira/fpga-verification-demo/actions/workflows/ci.yml)

## Project Overview & Goals

This project, designed by **Kadir Ufuk Kandira**, demonstrates a professional FPGA engineering workflow built around a parametric timer module.

- Clean and synthesis ready VHDL design following industry conventions
- Automated and self checking simulation using the VUnit framework
- Formal verification of timer behavior using SymbiYosys and PSL properties
- Continuous integration with GitHub Actions running on every push

### Technical Highlights

The `timer` entity is designed for reliability and ease of integration:

- The module internally calculates the target cycle count based on the input clock frequency (`clk_freq_hz_g`) and the desired delay generic (`delay_g`).
- Initiates counting on a `start_i` pulse.
- Safely ignores start triggers if the timer is already busy counting.
- The `done_o` signal acts as a "Ready/Idle" indicator, remaining High (`'1'`) whenever the timer is not busy.
- The design is fully synchronous (supporting synchronous reset) and is ready for physical FPGA deployment by simply mapping the ports and adjusting the generics.

## Local Development & Verification

Follow these steps to set up the environment and run tests on your local machine.

### 1. Prerequisites & Installation

Follow the steps below based on your operating system. You can either use the provided command-line instructions or download the installers from the official links.

#### A. Install Python 3.x
Python is required to run the VUnit framework.

* **Official Download:** [python.org/downloads](https://www.python.org/downloads/)
* **Windows (PowerShell):**
  ```powershell
  winget install Python.Python.3
  # Note: During installation, check "Add Python to PATH" if installing manually.
  ```

* **Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install python3 python3-pip

```

#### B. Install VUnit HDL

Once Python is installed, install the VUnit library using pip.

* **Official Documentation:** [vunit.github.io](https://vunit.github.io/)
* **Windows:**
```powershell
python -m pip install vunit_hdl

```
* **Linux:**
```bash
pip3 install vunit_hdl

```

#### C. Install GHDL (Simulator)

GHDL compiles and simulates the VHDL code.

* **Official Download:** [github.com/ghdl/ghdl/releases](https://github.com/ghdl/ghdl/releases)
* **Windows:**
1. Download the latest installer (e.g., `ghdl-0.37-mingw32-mcode.exe`) from the link above.
2. Run the installer and follow the instructions.


* **Linux:**
```bash
sudo apt install ghdl
# Or build from source if a newer version is needed.

```

#### D. Install OSS CAD Suite (For Formal Verification)

Required for running `sby` (SymbiYosys). This is a portable package (no installer).

* **Official Download:** [github.com/YosysHQ/oss-cad-suite-build/releases](https://github.com/YosysHQ/oss-cad-suite-build/releases)
* **Windows:**
1. Download the `windows-x64` zip file and extract it to `C:\oss-cad-suite`.
2. **Add to PATH manually:**
* Search Windows for **"Edit the system environment variables"**.
* Click **"Environment Variables"**.
* Under "User variables", find **Path** and click **Edit**.
* Click **New** and paste: `C:\oss-cad-suite\bin`
* Click OK on all windows.




* **Linux:**
```bash
# Download (Example filename, check link for latest)
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2024-01-20/oss-cad-suite-linux-x64-20240120.tgz
tar -xvf oss-cad-suite-linux-x64-*.tgz

# Add to PATH (Temporary)
export PATH=$PWD/oss-cad-suite/bin:$PATH

```
### 2. Running VUnit Simulations

We use VUnit to manage test benches and simulate various frequency/delay scenarios automatically.

To run the full simulation suite:

* **Windows:**
```powershell
python run.py -v

```


* **Linux / macOS:**
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
* *Success:* Means the design is proven correct for the specified depth.

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









