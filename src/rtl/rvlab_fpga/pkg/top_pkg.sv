// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

package top_pkg;
  typedef struct packed {
    logic [7:0] switch;

    logic       hdmi_rx_clk;
    logic [2:0] hdmi_rx;
    logic       hdmi_rx_cec;
    logic       hdmi_rx_scl;
    logic       hdmi_rx_sda;

    logic hdmi_tx_cec;
    logic hdmi_tx_rscl;
    logic hdmi_tx_rsda;
    logic hdmi_tx_hpd;

    logic ac_adc_sdata;
    logic scl;
    logic sda;

    logic ps2_clk;
    logic ps2_data;

    logic uart_tx_in;

    logic [3:0] eth_rxd;
    logic       eth_rxctl;
    logic       eth_rxck;
    logic       eth_int_b;
    logic       eth_pme_b;
    logic       eth_mdio;

    logic sd_cd;
    logic sd_miso;

    logic [7:0] pmod_a;
    logic [7:0] pmod_b;
    logic [7:0] pmod_c;
  } userio_board2fpga_t;

  typedef struct packed {
    logic [7:0] led;

    logic oled_sdin;
    logic oled_sclk;
    logic oled_dc;
    logic oled_res;
    logic oled_vbat;
    logic oled_vdd;

    logic hdmi_rx_hpa;
    logic hdmi_rx_txen;
    logic hdmi_rx_cec_oe;  // output enable. 0 = High-Z, 1 = drive output to 0
    logic hdmi_rx_scl_oe;  // output enable. 0 = High-Z, 1 = drive output to 0
    logic hdmi_rx_sda_oe;  // output enable. 0 = High-Z, 1 = drive output to 0

    logic       hdmi_tx_clk;
    logic [2:0] hdmi_tx;
    logic       hdmi_tx_cec_oe;   // output enable. 0 = High-Z, 1 = drive output to 0
    logic       hdmi_tx_rscl_oe;  // output enable. 0 = High-Z, 1 = drive output to 0
    logic       hdmi_tx_rsda_oe;  // output enable. 0 = High-Z, 1 = drive output to 0

    logic ac_dac_sdata;
    logic ac_bclk;
    logic ac_lrclk;
    logic ac_mclk;

    logic scl_oe;
    logic sda_oe;

    logic uart_rx_out;

    logic ps2_clk_oe;
    logic ps2_data_oe;

    logic [3:0] eth_txd;
    logic       eth_txctl;
    logic       eth_txck;
    logic       eth_mdc;
    logic       eth_rst_b;
    logic       eth_mdio_out;
    logic       eth_mdio_oe;   // output enable. 0 = High-Z, 1 = drive eth_mdio to eth_mdio_out

    logic sd_sck;
    logic sd_mosi;
    logic sd_cs;
    logic sd_reset;

    logic [7:0] pmod_a_oe;
    logic [7:0] pmod_a_out;
    logic [7:0] pmod_b_oe;
    logic [7:0] pmod_b_out;
    logic [7:0] pmod_c_oe;
    logic [7:0] pmod_c_out;
  } userio_fpga2board_t;

  localparam int TL_AW = 32;
  localparam int TL_DW = 32;  // = TL_DBW * 8; TL_DBW must be a power-of-two
  localparam int TL_AIW = 8;  // a_source, d_source
  localparam int TL_DIW = 1;  // d_sink
  localparam int TL_AUW = 21;  // a_user
  localparam int TL_DUW = 14;  // d_user
  localparam int TL_DBW = (TL_DW >> 3);
  localparam int TL_SZW = $clog2($clog2(TL_DBW) + 1);

endpackage
