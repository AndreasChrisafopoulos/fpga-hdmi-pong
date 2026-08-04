create_clock -period 10.000 -name clk [get_ports clk]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}]
# On-board Buttons
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {rst}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {up_btn}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {new_game_btn}]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {down_btn}]
# switches
set_property -dict { PACKAGE_PIN V2 IOSTANDARD LVCMOS33 } [get_ports { down_btn2 }]; #sw0
set_property -dict { PACKAGE_PIN U2 IOSTANDARD LVCMOS33 } [get_ports { up_btn2 }]; #sw1
set_property -dict { PACKAGE_PIN P1 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[0] }]; #sw8
set_property -dict { PACKAGE_PIN N2 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[1] }]; #sw9
set_property -dict { PACKAGE_PIN N1 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[2] }]; #sw10
set_property -dict { PACKAGE_PIN M2 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[3] }]; #sw11
set_property -dict { PACKAGE_PIN M1 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[0] }]; #sw12
set_property -dict { PACKAGE_PIN L1 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[1] }]; #sw13
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[2] }]; #sw14
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[3] }]; #sw15
# On-board LEDs
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {new_frame_LED}]
#HDMI Signals
set_property -dict { PACKAGE_PIN T14 IOSTANDARD TMDS_33} [get_ports {hdmi_clk_n}]
set_property -dict { PACKAGE_PIN R14 IOSTANDARD TMDS_33} [get_ports {hdmi_clk_p}]
set_property -dict { PACKAGE_PIN T15 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[0]}]
set_property -dict { PACKAGE_PIN R17 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[1]}]
set_property -dict { PACKAGE_PIN P16 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[2]}]
set_property -dict { PACKAGE_PIN R15 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[0]}]
set_property -dict { PACKAGE_PIN R16 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[1]}]
set_property -dict { PACKAGE_PIN N15 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[2]}]
# 7-Segment Display
set_property -dict { PACKAGE_PIN D7 IOSTANDARD LVCMOS33 } [get_ports { a }];
set_property -dict { PACKAGE_PIN C5 IOSTANDARD LVCMOS33 } [get_ports { b }];
set_property -dict { PACKAGE_PIN A5 IOSTANDARD LVCMOS33 } [get_ports { c }];
set_property -dict { PACKAGE_PIN B7 IOSTANDARD LVCMOS33 } [get_ports { d }];
set_property -dict { PACKAGE_PIN A7 IOSTANDARD LVCMOS33 } [get_ports { e }];
set_property -dict { PACKAGE_PIN D6 IOSTANDARD LVCMOS33 } [get_ports { f }];
set_property -dict { PACKAGE_PIN B5 IOSTANDARD LVCMOS33 } [get_ports { g }];
set_property -dict { PACKAGE_PIN A6 IOSTANDARD LVCMOS33 } [get_ports { dp }];
set_property -dict { PACKAGE_PIN D5 IOSTANDARD LVCMOS33 } [get_ports { an0 }];
set_property -dict { PACKAGE_PIN C4 IOSTANDARD LVCMOS33 } [get_ports { an1 }];
set_property -dict { PACKAGE_PIN C7 IOSTANDARD LVCMOS33 } [get_ports { an2 }];
set_property -dict { PACKAGE_PIN A8 IOSTANDARD LVCMOS33 } [get_ports { an3 }];
# Set Bank 0 voltage
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]