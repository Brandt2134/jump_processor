# Jump Processor (jumper_processor)

A digital processor written in VHDL that simulates the jump mechanic of an endless-runner game, built for a Digital Systems course. Given a button input and an 8-bit jump power value, the processor computes a character's vertical position each clock cycle and outputs signals indicating whether the character is running or jumping.

Full design walkthrough (HLSM, FSM, and datapath diagrams with explanation) is included in [`design_report.pdf`](./design_report.pdf).

## Design approach

The processor was built using a standard controller/datapath architecture, following this design flow:

1. **High-Level State Machine (HLSM):** mapped out the states needed for running and jumping behavior, which informed what the datapath needed to compute.
2. **Datapath design:** built the registers, adders, and comparators needed to track vertical velocity and position based on the HLSM.
3. **Finite State Machine (FSM):** designed the controller logic that decides which datapath control signals (loads, clears, mux selects) should be active in each state.
4. **Integration:** connected the controller and datapath into a single top-level processor (`jumper_processor`), with the controller driving the datapath's control lines based on state and inputs.

## How it works

- **Two states:** `Run` (S = 0) and `Jump` (S = 1).
- Pressing the button (`B`) while running transitions to the Jump state and initializes vertical velocity from `JmpPow` (via `init_YVel`).
- While jumping, vertical velocity decrements each cycle (simulating gravity) and vertical position accumulates that velocity.
- When vertical position returns to zero (`Y_eq_zero`), the state returns to `Run`.
- `testport` outputs are exposed on both the controller and datapath for simulation/debugging visibility.

## Files

| File | Description |
|---|---|
| `jumper_datapath.vhd` | Registers, adders, and comparator that track Y-velocity and Y-position |
| `jumper_controller.vhd` | FSM controller that generates datapath control signals based on button input and ground-contact state |
| `jumper_processor.vhd` | Top-level module connecting the controller and datapath |
| `design_report.pdf` | Full write-up with HLSM, FSM, and datapath diagrams |

## Dependencies

This design instantiates basic structural components (`reg8`, `mux8`, `adder8`, `eq8`, `dff`, `notgate`, `andgate`, `orgate`) that were provided as a course component library rather than written from scratch as part of this project. If you have those source files, add them here under a `components/` folder for the project to be fully self-contained and simulatable in Vivado.

## Tools

- **Language:** VHDL
- **Simulation:** Xilinx Vivado

---
*Course project for Digital Systems, University at Albany.*
