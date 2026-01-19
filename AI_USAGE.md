## AI Usage Declaration

| Task / Component | AI Tool Used | Purpose & Contribution | Verification Method |
| :--- | :--- | :--- | :--- |
| VHDL Syntax | Gemini | Generated initial entity/architecture skeleton. | The timer RTL was verified throughout development using Vivado and a dedicated testbench, and the FSM was adjusted accordingly. |
| VUnit Integration | Gemini | Provided some Python runner scripts | Confirmed successful compilation and test execution. Fixed a GHDL backend issue by cross-referencing error logs with AI suggestions. |
| CI/CD Pipeline | Gemini | Drafted the GitHub Actions YAML configuration for GHDL/SBY setup. | Iteratively pushed code to GitHub and monitored the Actions tab until the pipeline turned green in a different branch. |
| Formal Verification PSL | Gemini | Suggested PSL properties. | Ran `sby` locally and in CI. Confirmed that the mathematical proof passed BMC & k-induction for different specified depths and generic parameters. |


> All AI suggestions were treated as drafts. The final logic, parameter selection, and verification strategies were manually reviewed, tested, and validated to ensure compliance with the project requirements.