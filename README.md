🚦 FPGA-Based Traffic Light Controller

📌 Overview

This project implements a real-time Traffic Light Controller using Verilog HDL on a Xilinx Artix-7 FPGA (Nexys A7 board).

The system is designed using a Moore Finite State Machine (FSM) architecture to ensure deterministic and glitch-free control of a 4-way intersection.

⚙️ Key Features

Moore FSM architecture

- 4-way intersection logic (NS & EW control)

- Configurable timing:

    - Green = 30 seconds

    - Yellow = 4 seconds

    - All-Red = 2 seconds

- Clock divider (100MHz → 1Hz)

- Safety interlocks (mutual exclusion of green signals)

- 7-segment countdown display support

🧠 FSM Design

States:

  - NS_GREEN

  - NS_YELLOW

  - ALL_RED

  - EW_GREEN

  - EW_YELLOW

Outputs depend only on current state (Moore model).

🛠 Hardware Platform

- FPGA Board: Nexys A7 (Xilinx Artix-7)

- Onboard 100 MHz clock

- LEDs for R-Y-G signals

- Push button for reset

- 7-segment display (optional)

🔬 Verification

- Functional simulation in Vivado / ModelSim

- Timing validation via waveform

Hardware testing on FPGA board

Safety validation (no simultaneous conflicting greens)
