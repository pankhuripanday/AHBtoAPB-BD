# AHB-to-APB-Bridge-Design-

## Overview

This repository contains the design and implementation of an AHB to APB bridge. The bridge facilitates communication between the Advanced High-performance Bus (AHB) and the Advanced Peripheral Bus (APB), enabling efficient integration of high-performance system modules with low-power peripheral devices.

## About AMBA Buses

The Advanced Microcontroller Bus Architecture (AMBA) is a communication protocol designed for high-performance embedded microcontrollers. It includes:

- **Advanced High-performance Bus (AHB)**: Designed for high-performance, high-frequency system modules.
- **Advanced System Bus (ASB)**: Suitable for applications where AHB’s high-performance features are not required.
- **Advanced Peripheral Bus (APB)**: Optimized for low-power peripherals with reduced interface complexity.

### Advanced High-performance Bus (AHB)

The AHB acts as the backbone for high-performance system modules, connecting processors, memories, and external memory interfaces efficiently. It supports low-power peripheral functions and is optimized for synthesis and automated testing.

### Advanced System Bus (ASB)

The ASB offers an alternative to AHB, designed for cases where extreme performance is not necessary but still provides efficient connections with processors and memory systems.

### Advanced Peripheral Bus (APB)

APB is tailored for low-power peripheral functions. It simplifies the interface and reduces power consumption, working in conjunction with AHB or ASB for comprehensive system integration.

**Architecture Overview:**
![AMBA System](https://user-images.githubusercontent.com/91010702/194475317-68a7f60d-65ea-48de-a13a-fd85e25c364b.png)

## Basic Terminology

- **Bus Cycle**: A basic unit of one bus clock period, defined from rising-edge to rising-edge transitions.
- **Bus Transfer**: A read or write operation of a data object, which may span multiple bus cycles. APB transfers always require two cycles.
- **Burst Operation**: A series of data transactions with consistent width over an address space. APB does not support burst operations.

## AMBA Signals

### AHB Signals

| Name        | Source       | Description |
|-------------|--------------|-------------|
| `HCLK`      | Clock Source | Times all bus transfers with rising edge synchronization. |
| `HRESETn`   | Reset Controller | Active LOW reset signal used to initialize the system. |
| `HADDR[31:0]` | Master      | 32-bit address bus for system addressing. |
| `HTRANS[1:0]` | Master      | Transfer type: NONSEQUENTIAL, SEQUENTIAL, IDLE, or BUSY. |
| `HWRITE`    | Master       | Indicates a write (HIGH) or read (LOW) operation. |
| `HSIZE[2:0]` | Master      | Transfer size: byte, halfword, or word. |
| `HBURST[2:0]` | Master     | Burst type: incrementing or wrapping. |
| `HPROT[3:0]` | Master      | Protection signals for access control. |
| `HWDATA[31:0]` | Master    | Data bus for write operations. |
| `HSELx`     | Decoder      | Slave select signal indicating the target of the current transfer. |
| `HRDATA[31:0]` | Slave     | Data bus for read operations from slave to master. |
| `HREADY`    | Slave        | Indicates transfer completion or extension. |
| `HRESP[1:0]` | Slave       | Transfer response status: OKAY, ERROR, RETRY, or SPLIT. |

### APB Signals

| Name        | Source       | Description |
|-------------|--------------|-------------|
| `PCLK`      | Clock Source | Times all APB transfers with rising edge synchronization. |
| `PRESETn`   | Reset Controller | Active LOW reset signal for APB. |
| `PADDR[31:0]` | Master      | Address bus driven by the bridge unit. |
| `PSELx`     | Decoder      | Peripheral select signal indicating the target slave. |
| `PENABLE`   | Master       | Timing strobe for APB transfers, indicating the second cycle. |
| `PWRITE`    | Master       | Indicates a write (HIGH) or read (LOW) operation. |
| `PRDATA[31:0]` | Slave     | Read data bus driven by the selected slave during read operations. |
| `PWDATA[31:0]` | Master    | Write data bus driven by the bridge unit during write operations. |

## Implementation

### Objective

The project aims to design and simulate a synthesizable AHB to APB bridge using Verilog. The bridge translates AHB system bus transfers into APB transfers and performs essential functions, including:

- Latching and holding addresses valid throughout the transfer.
- Address decoding and generating the peripheral select signals (`PSELx`).
- Driving data onto the APB for write operations and from APB for read operations.
- Generating the timing strobe `PENABLE` for APB transfers.

**Bridge Interface:**
![APB Bridge](https://user-images.githubusercontent.com Block Diagram.png)

### Basic Implementation Tools

- **HDL Used**: Verilog
- **Simulator Tool**: ModelSim
- **Synthesis Tool**: Quartus Prime
- **Family**: Cyclone V
- **Device**: 5CSXFC6D6F31I7ES

### Design Modules

#### AHB Slave Interface

The AHB slave responds to transfers initiated by the AHB bus master. It uses the `HSELx` select signal to determine when it should respond to a transfer, relying on address and control signals from the master.

#### APB Controller

The APB controller consists of a state machine for generating APB and AHB output signals, and address decoding logic for generating `PSELx` lines for peripheral selection.

## Simulation Results

The simulation demonstrates successful mapping of AHB bus operations to the APB bus, including both write and read operations.

**Simulation Screenshot:**
![simulation_AHBtoAPB](https://user-images.githubusercontent.com/91010702/194483573-0e104260-c1b7-4810-88fe-c9aa4a32395f.png)

## Synthesis Results

**RTL Model:**
![bridge_rtl](https://user-images.githubusercontent.com/91010702/194485990-f8ff7727-387e-42ef-8fa7-d39034216ffc.png)

**State Machine Viewer:**
![bridge_fsm](https://user-images.githubusercontent.com/91010702/194485981-4a8f44e9-390b-4100-84b3-abe9c4930377.png)

## Further Work

- Extend functionality to support burst read and write operations in the AHB Master.
- Implement an arbitration mechanism and associated signals to generalize the testbench.

## Documentation

- [AMBA Modules](https://github.com/prajwalgekkouga/AHB-to-APB-Bridge/files/9731505/AMBA.Modules.pdf)
- [AMBA Specifications](https://github.com/prajwalgekkouga/AHB-to-APB-Bridge/files/9731507/AMBA.Specifications.pdf)

## Contact

For questions or support, please reach out via [email](mailto:your.email@example.com) or create an issue in the [Issue Tracker](https://github.com/yourusername/ahb-to-apb-bridge/issues).

Feel free to explore, contribute, and provide feedback!
