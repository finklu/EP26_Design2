# Evaluation Board with MSP430F5659 

This repository contains the lab documentation for the **Evaluation Board with MSP430F5659** lab project, developed as part of the Electronic Packaging and Advanced PCB Design course at **FH Joanneum University of Applied Sciences**.

## 🛠 Project Overview
The objective of this project is to design a prototype microcontroller evaluation board utilizing a target chip (`MSP430F5659IPZ`) and an open-source serialized emulation concept (`eZ-FET lite` via MSP430F5528).

### Key Features & Requirements:
* **Target Microcontroller:** `MSP430F5659IPZ` driven by external quartz oscillators (XT1 for real clock $32.768\text{ kHz}$, XT2 for high-speed applications).
* **Emulation & Communication:** On-board USB hub concept using the TUSB controller and an eZ-FET implementation for Spy-Bi-Wire/JTAG programming and UART communication.
* **Power Management:** USB 2.0 bus-powered design utilizing an appropriate DC/DC supply circuit and a jumper to disconnect target supply if needed.
* **User Interface:** On-board LEDs and push buttons, plus reset circuitry[cite: 2, 11].
* **Breakout & Peripherals:** Extensive pin routing to socket headers for USCI interfaces (SPI, UART, $\text{I}^2\text{C}$), analog inputs for A/D conversion, and timer outputs for PWM generation[cite: 2].
