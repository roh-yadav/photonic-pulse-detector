# Photonic Pulse Detector IC

A digital IC that detects and analyzes optical pulses — implemented from RTL to GDS on SKY130 130nm PDK.

## What it does
- Detects rising and falling edges of optical pulses
- Measures pulse width in clock cycles
- Counts pulse frequency per second
- Streams data via UART to laptop for live visualization

## Applications
- Photonic LiDAR pulse processing
- Optical fiber signal monitoring
- Photodetector readout circuits
- Optical communications testing

## Tools Used
- Verilog HDL — RTL design
- Icarus Verilog — functional simulation
- GTKWave — waveform viewing
- OpenLane — RTL to GDS flow
- SKY130 PDK — 130nm process
- Python matplotlib — live visualization

## Project Structure
- src/ — Verilog RTL source files
- sim/ — testbenches and simulation files
- docs/ — documentation and screenshots


## Simulation Waveforms

### Complete Chip (Top Module)
![Top Waveform](docs/waveform_top.png)

### Module 1 — Pulse Detector
![Module 1](docs/waveform_module1.png)

### Module 2 — Pulse Width Counter
![Module 2](docs/waveform_module2.png)

### Module 3 — Frequency Counter
![Module 3](docs/waveform_module3.png)

### Module 4 — UART Transmitter
![Module 4](docs/waveform_module4.png)
