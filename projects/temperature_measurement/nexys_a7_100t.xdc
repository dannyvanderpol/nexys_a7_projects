# Constrainst for the temperature measurement

# Speedup the flash loading
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH          4           [current_design]
set_property BITSTREAM.GENERAL.COMPRESS             true        [current_design]

# Clock signal
set_property -dict { PACKAGE_PIN E3     IOSTANDARD LVCMOS33 }   [get_ports { clk_100mhz }];
create_clock -name clk_100mhz -period 10.00 -waveform {0 5}     [get_ports { clk_100mhz }];

# Reset button, active low, external pull-up on board
set_property -dict { PACKAGE_PIN C12    IOSTANDARD LVCMOS33 }   [get_ports { btn_reset_n }];


# Debug output on Pmod Header JD, connected to the logic analyser (8 channels)
set_property -dict { PACKAGE_PIN H4     IOSTANDARD LVCMOS33 }   [get_ports { debug[0] }];
set_property -dict { PACKAGE_PIN H1     IOSTANDARD LVCMOS33 }   [get_ports { debug[1] }];
set_property -dict { PACKAGE_PIN G1     IOSTANDARD LVCMOS33 }   [get_ports { debug[2] }];
set_property -dict { PACKAGE_PIN G3     IOSTANDARD LVCMOS33 }   [get_ports { debug[3] }];
set_property -dict { PACKAGE_PIN H2     IOSTANDARD LVCMOS33 }   [get_ports { debug[4] }];
set_property -dict { PACKAGE_PIN G4     IOSTANDARD LVCMOS33 }   [get_ports { debug[5] }];
set_property -dict { PACKAGE_PIN G2     IOSTANDARD LVCMOS33 }   [get_ports { debug[6] }];
set_property -dict { PACKAGE_PIN F3     IOSTANDARD LVCMOS33 }   [get_ports { debug[7] }];
