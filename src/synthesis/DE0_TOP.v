// --------------------------------------------------------------------
// Copyright (c) 2009 by Terasic Technologies Inc.
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development
//   Kits made by Terasic. Other use of this code, including the selling,
//   duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods. Terasic provides no warranty regarding the use
//   or functionality of this code.
//
// --------------------------------------------------------------------
//
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions: DE0 TOP
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:

// --------------------------------------------------------------------

module DE0_TOP (CLOCK_50,
                CLOCK_50_2,
                BUTTON,
                SW,
                HEX0_D,
                HEX0_DP,
                HEX1_D,
                HEX1_DP,
                HEX2_D,
                HEX2_DP,
                HEX3_D,
                HEX3_DP,
                LEDG,
                UART_TXD,
                UART_RXD,
                UART_CTS,
                UART_RTS,
                DRAM_DQ,
                DRAM_ADDR,
                DRAM_LDQM,
                DRAM_UDQM,
                DRAM_WE_N,
                DRAM_CAS_N,
                DRAM_RAS_N,
                DRAM_CS_N,
                DRAM_BA_0,
                DRAM_BA_1,
                DRAM_CLK,
                DRAM_CKE,
                FL_DQ,
                FL_DQ15_AM1,
                FL_ADDR,
                FL_WE_N,
                FL_RST_N,
                FL_OE_N,
                FL_CE_N,
                FL_WP_N,
                FL_BYTE_N,
                FL_RY,
                LCD_BLON,
                LCD_RW,
                LCD_EN,
                LCD_RS,
                LCD_DATA,
                SD_DAT0,
                SD_DAT3,
                SD_CMD,
                SD_CLK,
                SD_WP_N,
                PS2_KBDAT,
                PS2_KBCLK,
                PS2_MSDAT,
                PS2_MSCLK,
                VGA_HS,
                VGA_VS,
                VGA_R,
                VGA_G,
                VGA_B,
                GPIO0_CLKIN,
                GPIO0_CLKOUT,
                GPIO0_D,
                GPIO1_CLKIN,
                GPIO1_CLKOUT,
                GPIO1_D);
    
    ///////////// Clock Input //////////////////////////////////////////
    input         CLOCK_50;     //  50 MHz
    input         CLOCK_50_2;   //  50 MHz
    ///////////// Push Button //////////////////////////////////////////
    input  [2:0]  BUTTON;       //  Pushbutton[2:0]
    ///////////// DPDT Switch //////////////////////////////////////////
    input  [9:0]  SW;           //  Toggle Switch[9:0]
    ///////////// 7-SEG Dispaly ////////////////////////////////////////
    output [6:0]  HEX0_D;       //  Seven Segment Digit 0
    output        HEX0_DP;      //  Seven Segment Digit DP 0
    output [6:0]  HEX1_D;       //  Seven Segment Digit 1
    output        HEX1_DP;      //  Seven Segment Digit DP 1
    output [6:0]  HEX2_D;       //  Seven Segment Digit 2
    output        HEX2_DP;      //  Seven Segment Digit DP 2
    output [6:0]  HEX3_D;       //  Seven Segment Digit 3
    output        HEX3_DP;      //  Seven Segment Digit DP 3
    ///////////// LED //////////////////////////////////////////////////
    output [9:0]  LEDG;         //  LED Green[9:0]
    
    ///////////// UART /////////////////////////////////////////////////
    output        UART_TXD;     //  UART Transmitter
    input         UART_RXD;     //  UART Receiver
    output        UART_CTS;     //  UART Clear To Send
    input         UART_RTS;     //  UART Request To Send
    ///////////// SDRAM Interface //////////////////////////////////////
    inout  [15:0] DRAM_DQ;      //  SDRAM Data bus 16 Bits
    output [12:0] DRAM_ADDR;    //  SDRAM Address bus 13 Bits
    output        DRAM_LDQM;    //  SDRAM Low-byte Data Mask
    output        DRAM_UDQM;    //  SDRAM High-byte Data Mask
    output        DRAM_WE_N;    //  SDRAM Write Enable
    output        DRAM_CAS_N;   //  SDRAM Column Address Strobe
    output        DRAM_RAS_N;   //  SDRAM Row Address Strobe
    output        DRAM_CS_N;    //  SDRAM Chip Select
    output        DRAM_BA_0;    //  SDRAM Bank Address 0
    output        DRAM_BA_1;    //  SDRAM Bank Address 1
    output        DRAM_CLK;     //  SDRAM Clock
    output        DRAM_CKE;     //  SDRAM Clock Enable
    ///////////// Flash Interface //////////////////////////////////////
    inout  [14:0] FL_DQ;        //  FLASH Data bus 15 Bits
    inout         FL_DQ15_AM1;  //  FLASH Data bus Bit 15 or Address A-1
    output [21:0] FL_ADDR;      //  FLASH Address bus 22 Bits
    output        FL_WE_N;      //  FLASH Write Enable
    output        FL_RST_N;     //  FLASH Reset
    output        FL_OE_N;      //  FLASH Output Enable
    output        FL_CE_N;      //  FLASH Chip Enable
    output        FL_WP_N;      //  FLASH Hardware Write Protect
    output        FL_BYTE_N;    //  FLASH Selects 8/16-bit mode
    input         FL_RY;        //  FLASH Ready/Busy
    ///////////// LCD Module 16X2 //////////////////////////////////////
    inout  [7:0]  LCD_DATA;     //  LCD Data bus 8 bits
    output        LCD_BLON;     //  LCD Back Light ON/OFF
    output        LCD_RW;       //  LCD Read/Write Select, 0 = Write, 1 = Read
    output        LCD_EN;       //  LCD Enable
    output        LCD_RS;       //  LCD Command/Data Select, 0 = Command, 1 = Data
    ///////////// SD Card Interface ////////////////////////////////////
    inout         SD_DAT0;      //  SD Card Data 0
    inout         SD_DAT3;      //  SD Card Data 3
    inout         SD_CMD;       //  SD Card Command Signal
    output        SD_CLK;       //  SD Card Clock
    input         SD_WP_N;      //  SD Card Write Protect
    ///////////// PS2 //////////////////////////////////////////////////
    inout         PS2_KBDAT;    //  PS2 Keyboard Data
    inout         PS2_KBCLK;    //  PS2 Keyboard Clock
    inout         PS2_MSDAT;    //  PS2 Mouse Data
    inout         PS2_MSCLK;    //  PS2 Mouse Clock
    ///////////// VGA //////////////////////////////////////////////////
    output        VGA_HS;       //  VGA H_SYNC
    output        VGA_VS;       //  VGA V_SYNC
    output [3:0]  VGA_R;        //  VGA Red[3:0]
    output [3:0]  VGA_G;        //  VGA Green[3:0]
    output [3:0]  VGA_B;        //  VGA Blue[3:0]
    ///////////// GPIO /////////////////////////////////////////////////
    input  [1:0]  GPIO0_CLKIN;  //  GPIO Connection 0 Clock In Bus
    output [1:0]  GPIO0_CLKOUT; //  GPIO Connection 0 Clock Out Bus
    inout  [31:0] GPIO0_D;      //  GPIO Connection 0 Data Bus
    input  [1:0]  GPIO1_CLKIN;  //  GPIO Connection 1 Clock In Bus
    output [1:0]  GPIO1_CLKOUT; //  GPIO Connection 1 Clock Out Bus
    inout  [31:0] GPIO1_D;      //  GPIO Connection 1 Data Bus
    
    // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  == 
    //  REG/WIRE declarations
    // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  == 
    
    wire PS2_KBCLK_deb;
    wire [15:0] data_keyboard;

    assign {HEX0_DP, HEX1_DP, HEX2_DP, HEX3_DP} = 4'hF;

    // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  == 
    //  Structural coding
    // ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  == 

    deb deb_inst(CLOCK_50, SW[9], PS2_KBCLK, PS2_KBCLK_deb);
    keyboard keyboard_inst(CLOCK_50, SW[9], PS2_KBDAT,PS2_KBCLK_deb, data_keyboard);
    hex hex0_inst(data_keyboard[3:0], HEX0_D);
    hex hex1_inst(data_keyboard[7:4], HEX1_D);
    hex hex2_inst(data_keyboard[11:8], HEX2_D);
    hex hex3_inst(data_keyboard[15:12], HEX3_D);

endmodule
