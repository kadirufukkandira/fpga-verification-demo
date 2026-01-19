## AI Usage Declaration

| Task | AI Tool | Contribution | Verification Method |
| :--- | :--- | :--- | :--- |
| VHDL Syntax | Gemini | Generated initial entity/architecture skeleton. | The timer RTL was verified throughout development using Vivado and a dedicated testbench, and the FSM was adjusted accordingly. |
| VUnit Integration | Gemini | Provided some Python runner scripts | Developed Python runner scripts guided by publicly available VUnit integration examples and verified them locally before pushing to the main branch. |
| CI Pipeline | Gemini | Drafted GitHub Actions YAML for VUnit setup | Tested the pipeline by pushing code to a separate branch and ensuring all Actions checks passed. |
| Formal Verification | Gemini | Suggested PSL properties. | Used the generic parameters to write PSL properties myself and verified that done_o always asserts correctly for all specified cycles. |


