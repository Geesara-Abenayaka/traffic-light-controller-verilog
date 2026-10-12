# 🚦 Four-Way Traffic Light Controller with Pedestrian Crossing (Verilog HDL)

A digital finite state machine (FSM) implementation of a four-way traffic light control system with on-demand pedestrian crossing signals, modeled and verified in Verilog HDL.

---

## 📌 Project Overview

This project designs a synchronous digital traffic controller for a standard North-South (NS) and East-West (EW) intersection. It incorporates safety clearance intervals (All-Red states) and on-demand pedestrian crossings activated via external push-button inputs.

### Key Highlights
- **Finite State Machine (FSM):** 7 distinct states managing standard vehicular transitions and pedestrian intervals.
- **Safety Clearance:** Dedicated `ALL_RED` buffer states between phase shifts to clear intersecting traffic safely.
- **Pedestrian Support:** Conditional transition logic responding to pedestrian requests (`ped_NS`, `ped_EW`).
- **Configurable Timing:** Synchronous internal timer handling predictable state dwell durations.

---

## 🔄 State Machine Architecture

The controller cycles through a sequential Moore/Mealy hybrid FSM architecture:

| State Encoding | State Name | NS Signals | EW Signals | Pedestrian Signals | Description |
| :--- | :--- | :---: | :---: | :---: | :--- |
| `3'd0` | **NS_GREEN** | 🟢 Green | 🔴 Red | 🛑 Stop | NS traffic flows |
| `3'd1` | **NS_YELLOW** | 🟡 Yellow | 🔴 Red | 🛑 Stop | NS traffic prepares to stop |
| `3'd2` | **ALL_RED_1** | 🔴 Red | 🔴 Red | 🛑 Stop | Intersection clearance buffer |
| `3'd3` | **EW_GREEN** | 🔴 Red | 🟢 Green | 🛑 Stop | EW traffic flows |
| `3'd4` | **EW_YELLOW** | 🔴 Red | 🟡 Yellow | 🛑 Stop | EW traffic prepares to stop |
| `3'd5` | **ALL_RED_2** | 🔴 Red | 🔴 Red | 🛑 Stop | Evaluates pedestrian crossing requests |
| `3'd6` | **PED_GREEN** | 🔴 Red | 🔴 Red | 🚶 Walk | Pedestrian walk signals activated on demand |

---

## 📁 Repository Structure

```text
├── traffic_light.v      # Synthesizable RTL design module (traffic_light_top)
├── tb_traffic_light.v   # Testbench stimulus generator & monitoring harness
└── README.md            # Hardware architecture documentation
