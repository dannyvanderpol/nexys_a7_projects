# Nexys A7 projects

Projects written with free software Vivado using VHDL (no Verilog).

## Board details

Projects for the Nexys A7 board from Digilent.

Part: AMD/Xilinx XC7A100T-1CSG324C

* FPGA Features
  * Internal clock speeds exceeding 450MHz
  * On-chip analog-to-digital converter (XADC)
  * Programmable over JTAG and Flash
* System Features
  * USB-JTAG programming circuitry
  * 16 MB QSPI Flash 
  * Powered from USB or any 7V-15V source
  * microSD card connector
* System Connectivity
  * 10/100 Mbps Ethernet
  * USB-UART Bridge
* Interaction and Sensory Devices
  * 3-axis accelerometer
  * PDM microphone
  * PWM audio output
  * Temperature Sensor
  * 8 digit seven-segment displays
  * USB HID for mice, keyboards, and memory sticks
  * 16 Switches
  * 16 LEDs
  * 2 tri-color LEDs
  * 12-bit VGA output
* Expansion Connectors
  * 4 Pmod connectors
  * Pmod for XADC signals

## Software

Download and install Xilinx/AMD Vivado ML Standard (standard edition is free, but requires and account).

## Project setup

### Add the board in Vivado:

* Menu: Tools -> Vivado store
* Tab: Boards
* Click the refresh button to update the boards
* Install: Digilent Nexys A7-100T

### Create project:

* Menu: File -> Project -> New
* Enter project name and location
* Select RTL project
* Select board: Nexys A7-100T
* Finish
* Open project settings
  * General:
    * Target language: VHDL
  * Bitstream
    * Enable -bin_file
* Open the hardware manager
  * Connect to the hardware
  * Add the flash program memory:
    * Click 'Add Configuration Memory Device' in the project tree
    * Select: s25fl128sxxxxxx0-spi-x1_x2_x4
    * Click OK
* Add the project files to the Vivado project

## Links

Product page: https://digilent.com/reference/programmable-logic/nexys-a7/start

Reference manual: https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual

AMD/Xilinx Vivado: https://www.xilinx.com/developer/products/vivado.html
