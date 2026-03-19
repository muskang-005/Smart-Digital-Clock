# Smart Digital Clock with Calendar (Verilog)

## Abstract
This project implements a digital clock using Verilog HDL that displays time and date. The system automatically updates time every second and manages calendar changes including month and year updates. It also includes leap year handling and mode-based display.

## Table of Contents
- Introduction  
- Features  
- Working  
- Outputs  
- Conclusion  
- Future Scope  

## Introduction
Digital clocks are commonly used in embedded systems. This project is a Verilog-based implementation of a smart digital clock that keeps track of time (hours, minutes, seconds) and date (day, month, year).

It demonstrates basic digital design concepts like counters, clock division, and conditional logic.

## Features
- Time display in **HH:MM:SS (12-hour format)**
- Date display in **DD-MM-YY**
- Automatic **AM/PM switching**
- **Leap year handling**
- Automatic **date, month, and year update**
- Day tracking (**0–6 format**)
- Mode switching using a button:
  - Mode 0 → Time
  - Mode 1 → Date
  - Mode 2 → Day
- Output shown using **6 display digits (d1–d6)**

---

## Working

### 1. Clock Divider
- Input clock is divided to generate a **1-second signal (`clk_1s`)**
- This controls the time updates 

### 2. Time Storage
Time is stored using:
h1 h2 → Hours
m1 m2 → Minutes
s1 s2 → Seconds

### 3. Time Counting Logic
- Seconds increase every second
- After 59 seconds → minutes increase
- After 59 minutes → hours increase

### 4. 12-Hour Format
- Clock runs in 12-hour format
- Transitions:
  - 11 → 12 → AM/PM toggles
  - 12 → 01 → new cycle starts

### 5. Date Handling
- Date updates at midnight
- Month updates when maximum days reached
- Year updates after December

### 6. Leap Year Logic
(year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
- February has 29 days in leap year, otherwise 28

### 7. Mode-Based Display
#### Mode 0 → Time
#### Mode 1 → Date
#### Mode 2 → Day

## Outputs
- Time increases correctly every second  
- Example:


## Conclusion
This project successfully shows how a digital clock can be designed using Verilog. It correctly tracks time and date, including leap year handling. The design uses basic digital logic concepts and is suitable for FPGA implementation.


## Future Scope
- Display output on **7-segment display**
- Implementation on **FPGA board**
- Adding **alarm feature**
- Adding manual **time setting using buttons**
