# PS/2 Keyboard Interface on FPGA

This project implements and verifies a PS/2 keyboard interface for the DE0 FPGA development board using Verilog and UVM. It includes synthesizable logic for decoding PS/2 signals, simulation testbenches, and UVM-based verification components.

## 💡 Project Description

The PS/2 protocol is a serial communication protocol used for keyboard data transfer. It involves two key signals:

- **PS2_KBCLK**: Clock signal (10–16.7kHz) for data synchronization.
- **PS2_KBDAT**: Serial data signal.

Each transmission starts with a **start bit (0)**, followed by **8 data bits** (LSB first), an **odd parity bit**, and ends with a **stop bit (1)**. When a key is pressed or released, the keyboard sends a **make code** or **break code**, respectively. Break codes typically start with `F0`.

The design includes:

- A debounced PS/2 decoder.
- Displaying the two lowest bytes of the received code on the 7-segment display.
- Handling noisy PS2_KBCLK signal with device clock (CLOCK_50).

---

## 🛠 Tools Used

- **Quartus II**: Synthesis and FPGA programming.
- **Questa SIM**: Simulation and UVM-based verification.
- **Visual Studio Code**: Code editing and navigation.
- **Makefile-based tooling** for running simulation and synthesis.

---

## ✅ Requirements

- DE0 FPGA development board
- Quartus II (version supporting DE0)
- Questa SIM with UVM support
- Verilog/SystemVerilog environment

---

## 🔬 Verification (UVM)

The PS/2 module is verified using the Universal Verification Methodology (UVM). The testbench stimulates the input signals, including pseudo-random values on **PS2_KBCLK**, and checks the correctness of the received scan codes.

---

## 🚀 Synthesis

After implementing modules:

- Run Quartus II to synthesize the design.
- The synthesized circuit will show the received scan code on the DE0’s 7-segment display.
- Modules should be robust to clock bouncing and work synchronously with CLOCK_50.

  ## 📸 Demo Output

After successful synthesis and flashing to the DE0 board, the 7-segment displays will show the two lowest bytes of the keycode when a key is pressed or released.

## 📄 License

This project is licensed under the MIT License
