# 5-Stage Pipelined 32-bit RISC Processor

A custom-designed **32-bit RISC processor** implemented in **Verilog HDL** featuring a classic **five-stage pipeline**, comprehensive **data hazard handling**, **control hazard management**, and a modular RTL architecture.

The processor supports arithmetic, logical, memory, branch, jump and halt instructions through a custom Instruction Set Architecture (ISA) and has been verified using simulation and waveform analysis.

---

# Project Overview

This project implements a custom **five-stage pipelined processor** to demonstrate the core concepts of modern processor architecture including:

- Instruction Pipelining
- Hazard Detection
- Data Forwarding
- Pipeline Control
- Branch Handling
- Memory Operations

The processor has been designed using a modular RTL architecture where every functional block has been independently developed, verified and integrated. Particular emphasis has been placed on efficient hazard resolution while maintaining maximum instruction throughput.

---

# Features

- Custom 32-bit Instruction Set Architecture
- Five-stage pipeline (IF–ID–EX–MEM–WB)
- Harvard Architecture
- 16 × 32-bit Register File
- Arithmetic and Logical ALU
- Immediate Instructions
- Load and Store Instructions
- Branch Instructions
- Jump Instruction
- Halt Instruction
- Hazard Detection Unit
- EX/MEM Forwarding
- MEM/WB Forwarding
- Store Data Forwarding
- Pipeline Stall Generation
- Pipeline Flush Logic
- Modular RTL Design
- Directed RTL Verification
- GTKWave Waveform Analysis

---

# Processor Architecture

> *(Insert datapath image here)*

---

# Pipeline Stages

## Instruction Fetch (IF)

- Program Counter update
- Instruction fetch
- Instruction Memory access
- Branch / Jump redirection
- Pipeline stall support

---

## Instruction Decode (ID)

- Instruction decoding
- Register File read
- Immediate generation
- Control signal generation
- Hazard detection

---

## Execute (EX)

- ALU operations
- Effective address calculation
- Branch comparison
- Operand forwarding

---

## Memory Access (MEM)

- Data Memory read
- Data Memory write
- Load operation
- Store operation

---

## Write Back (WB)

- Write ALU results
- Write Memory results

---

# Instruction Set Architecture

## Instruction Formats

### R-Type

|31:29|28:25|24:21|20:17|16:13|12:0|
|------|------|------|------|------|------|
|ISA|Opcode|Rd|Rs1|Rs2|Unused|

---

### I-Type

|31:29|28:25|24:21|20:17|16:0|
|------|------|------|------|------|
|ISA|Opcode|Rd|Rs1|Immediate|

---

### Memory-Type (LOAD / STORE)

|31:29|28:25|24:21|20:17|16:0|
|------|------|------|------|------|
|ISA|Opcode|Register 1|Register 2|Immediate|

**LOAD**

- Register 1 = Destination Register
- Register 2 = Base Register

**STORE**

- Register 1 = Base Register
- Register 2 = Data Register

---

### Branch-Type

|31:29|28:25|24:21|20:17|16:0|
|------|------|------|------|------|
|ISA|Opcode|Rs1|Rs2|Target Address|

---

### Jump-Type

|31:29|28:25|24:0|
|------|------|------|
|ISA|Opcode|Target Address|

---

# Opcode Table

## ISA Types

|ISA|Instruction Type|
|----|----------------|
|000|R-Type|
|001|I-Type|
|010|Memory|
|011|Branch|
|100|Jump|
|101|HALT|

---

## ALU Operations

|Opcode|Instruction|
|-------|-----------|
|0000|ADD|
|0001|SUB|
|0010|AND|
|0011|OR|
|0100|XOR|
|0101|NAND|
|0110|NOR|
|0111|XNOR|

---

## Memory Instructions

|Opcode|Instruction|
|-------|-----------|
|0000|LOAD|
|0001|STORE|

---

## Branch Instructions

|Opcode|Instruction|
|-------|-----------|
|0000|BEQ|
|0001|BNE|

---

# Pipeline Registers

- IF/ID
- ID/EX
- EX/MEM
- MEM/WB

Each pipeline register isolates adjacent stages allowing multiple instructions to execute simultaneously.

---

# Hazard Handling

## Data Hazards

Implemented using

- EX/MEM Forwarding
- MEM/WB Forwarding
- Store Data Forwarding
- Load-use Hazard Detection
- Pipeline Stall Generation

---

## Control Hazards

Handled using

- Branch Evaluation
- Pipeline Flush
- Program Counter Redirection

---

## Structural Hazards

Structural hazards are eliminated by using separate

- Instruction Memory
- Data Memory

(Harvard Architecture)

---

# Major Hardware Modules

- Program Counter
- Instruction Memory
- Register File
- ALU
- Control Unit
- Hazard Detection Unit
- Forwarding Unit
- Data Memory
- IF/ID Register
- ID/EX Register
- EX/MEM Register
- MEM/WB Register

---

# Verification

Verified using directed RTL simulations covering

- Arithmetic Instructions
- Logical Instructions
- Immediate Instructions
- Load / Store Operations
- Branch Instructions
- Jump Instructions
- Data Forwarding
- Load-use Hazards
- Store Forwarding
- Pipeline Flush
- Pipeline Stalls

Waveforms were analyzed using **GTKWave**.

---

# Repository Structure

```text
.
├── rtl/
├── tb/
├── docs/
├── images/
├── program.mem
└── README.md
```

---

# Design Highlights

- Custom ISA
- Modular RTL
- Five-stage Pipeline
- Data Hazard Resolution
- Branch Handling
- Efficient Forwarding Network
- Parameterized Hardware Design

---

# Future Improvements

- Branch Prediction
- Cache Memory
- UART Peripheral
- Interrupt Support
- Hardware Multiplier
- Memory Mapped I/O
- Performance Counters
- CPI Analysis
- RTL-to-GDSII ASIC Implementation

---

# Documentation

Detailed explanations are provided in

- Pipeline Architecture
- Instruction Set
- Hazard Detection
- Forwarding Unit
- Branch Handling
- Verification

---

# Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Git
- GitHub

---

# Learning Outcomes

This project provided practical experience in

- RTL Design
- Processor Architecture
- Instruction Pipelining
- Hazard Detection
- Data Forwarding
- Datapath Design
- Control Unit Design
- RTL Verification
- Digital Hardware Debugging

# Author
Urja Sheth
