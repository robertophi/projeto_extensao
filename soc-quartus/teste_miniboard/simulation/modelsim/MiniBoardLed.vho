-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 32-bit"
-- VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

-- DATE "09/29/2016 19:13:14"

-- 
-- Device: Altera EP2C5T144C8 Package TQFP144
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEII;
LIBRARY IEEE;
USE CYCLONEII.CYCLONEII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	miniBoardLed IS
    PORT (
	clock : IN std_logic;
	reset : IN std_logic;
	output : OUT std_logic_vector(7 DOWNTO 0)
	);
END miniBoardLed;

-- Design Ports Information
-- output[0]	=>  Location: PIN_3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- output[1]	=>  Location: PIN_7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- output[2]	=>  Location: PIN_9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- output[3]	=>  Location: PIN_86,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- output[4]	=>  Location: PIN_81,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- output[5]	=>  Location: PIN_80,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- output[6]	=>  Location: PIN_75,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- output[7]	=>  Location: PIN_74,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- reset	=>  Location: PIN_144,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- clock	=>  Location: PIN_17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF miniBoardLed IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clock : std_logic;
SIGNAL ww_reset : std_logic;
SIGNAL ww_output : std_logic_vector(7 DOWNTO 0);
SIGNAL \clock~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \current_timer[6]~44_combout\ : std_logic;
SIGNAL \current_timer[12]~56_combout\ : std_logic;
SIGNAL \LessThan2~1_combout\ : std_logic;
SIGNAL \LessThan2~6_combout\ : std_logic;
SIGNAL \LessThan0~0_combout\ : std_logic;
SIGNAL \LessThan0~4_combout\ : std_logic;
SIGNAL \clock~combout\ : std_logic;
SIGNAL \clock~clkctrl_outclk\ : std_logic;
SIGNAL \reset~combout\ : std_logic;
SIGNAL \current_timer[0]~32_combout\ : std_logic;
SIGNAL \current_timer[20]~73\ : std_logic;
SIGNAL \current_timer[21]~74_combout\ : std_logic;
SIGNAL \current_timer[21]~75\ : std_logic;
SIGNAL \current_timer[22]~76_combout\ : std_logic;
SIGNAL \current_timer[22]~77\ : std_logic;
SIGNAL \current_timer[23]~78_combout\ : std_logic;
SIGNAL \current_timer[23]~79\ : std_logic;
SIGNAL \current_timer[24]~81\ : std_logic;
SIGNAL \current_timer[25]~82_combout\ : std_logic;
SIGNAL \current_timer[25]~83\ : std_logic;
SIGNAL \current_timer[26]~85\ : std_logic;
SIGNAL \current_timer[27]~86_combout\ : std_logic;
SIGNAL \current_timer[27]~87\ : std_logic;
SIGNAL \current_timer[28]~88_combout\ : std_logic;
SIGNAL \current_timer[26]~84_combout\ : std_logic;
SIGNAL \current_timer[24]~80_combout\ : std_logic;
SIGNAL \next_timer[31]~0_combout\ : std_logic;
SIGNAL \current_timer[28]~89\ : std_logic;
SIGNAL \current_timer[29]~90_combout\ : std_logic;
SIGNAL \current_timer[29]~91\ : std_logic;
SIGNAL \current_timer[30]~92_combout\ : std_logic;
SIGNAL \next_timer[31]~1_combout\ : std_logic;
SIGNAL \current_timer[19]~70_combout\ : std_logic;
SIGNAL \LessThan0~6_combout\ : std_logic;
SIGNAL \LessThan0~7_combout\ : std_logic;
SIGNAL \current_timer[17]~66_combout\ : std_logic;
SIGNAL \LessThan0~1_combout\ : std_logic;
SIGNAL \current_timer[8]~48_combout\ : std_logic;
SIGNAL \current_timer[10]~52_combout\ : std_logic;
SIGNAL \LessThan0~2_combout\ : std_logic;
SIGNAL \LessThan0~3_combout\ : std_logic;
SIGNAL \LessThan0~5_combout\ : std_logic;
SIGNAL \next_timer[31]~2_combout\ : std_logic;
SIGNAL \current_timer[0]~33\ : std_logic;
SIGNAL \current_timer[1]~34_combout\ : std_logic;
SIGNAL \current_timer[1]~35\ : std_logic;
SIGNAL \current_timer[2]~36_combout\ : std_logic;
SIGNAL \current_timer[2]~37\ : std_logic;
SIGNAL \current_timer[3]~39\ : std_logic;
SIGNAL \current_timer[4]~40_combout\ : std_logic;
SIGNAL \current_timer[4]~41\ : std_logic;
SIGNAL \current_timer[5]~43\ : std_logic;
SIGNAL \current_timer[6]~45\ : std_logic;
SIGNAL \current_timer[7]~46_combout\ : std_logic;
SIGNAL \current_timer[7]~47\ : std_logic;
SIGNAL \current_timer[8]~49\ : std_logic;
SIGNAL \current_timer[9]~50_combout\ : std_logic;
SIGNAL \current_timer[9]~51\ : std_logic;
SIGNAL \current_timer[10]~53\ : std_logic;
SIGNAL \current_timer[11]~54_combout\ : std_logic;
SIGNAL \current_timer[11]~55\ : std_logic;
SIGNAL \current_timer[12]~57\ : std_logic;
SIGNAL \current_timer[13]~58_combout\ : std_logic;
SIGNAL \current_timer[13]~59\ : std_logic;
SIGNAL \current_timer[14]~60_combout\ : std_logic;
SIGNAL \current_timer[14]~61\ : std_logic;
SIGNAL \current_timer[15]~62_combout\ : std_logic;
SIGNAL \current_timer[15]~63\ : std_logic;
SIGNAL \current_timer[16]~64_combout\ : std_logic;
SIGNAL \current_timer[16]~65\ : std_logic;
SIGNAL \current_timer[17]~67\ : std_logic;
SIGNAL \current_timer[18]~68_combout\ : std_logic;
SIGNAL \current_timer[18]~69\ : std_logic;
SIGNAL \current_timer[19]~71\ : std_logic;
SIGNAL \current_timer[20]~72_combout\ : std_logic;
SIGNAL \LessThan2~0_combout\ : std_logic;
SIGNAL \LessThan2~8_combout\ : std_logic;
SIGNAL \LessThan2~9_combout\ : std_logic;
SIGNAL \LessThan2~7_combout\ : std_logic;
SIGNAL \LessThan2~10_combout\ : std_logic;
SIGNAL \current_timer[30]~93\ : std_logic;
SIGNAL \current_timer[31]~94_combout\ : std_logic;
SIGNAL \current_timer[5]~42_combout\ : std_logic;
SIGNAL \current_timer[3]~38_combout\ : std_logic;
SIGNAL \LessThan2~3_combout\ : std_logic;
SIGNAL \LessThan2~4_combout\ : std_logic;
SIGNAL \LessThan2~2_combout\ : std_logic;
SIGNAL \LessThan2~5_combout\ : std_logic;
SIGNAL \LessThan2~11_combout\ : std_logic;
SIGNAL current_timer : std_logic_vector(31 DOWNTO 0);
SIGNAL \ALT_INV_LessThan2~11_combout\ : std_logic;

BEGIN

ww_clock <= clock;
ww_reset <= reset;
output <= ww_output;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clock~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \clock~combout\);
\ALT_INV_LessThan2~11_combout\ <= NOT \LessThan2~11_combout\;

-- Location: LCFF_X12_Y7_N13
\current_timer[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[6]~44_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(6));

-- Location: LCFF_X12_Y7_N25
\current_timer[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[12]~56_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(12));

-- Location: LCCOMB_X12_Y7_N12
\current_timer[6]~44\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[6]~44_combout\ = (current_timer(6) & (\current_timer[5]~43\ $ (GND))) # (!current_timer(6) & (!\current_timer[5]~43\ & VCC))
-- \current_timer[6]~45\ = CARRY((current_timer(6) & !\current_timer[5]~43\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(6),
	datad => VCC,
	cin => \current_timer[5]~43\,
	combout => \current_timer[6]~44_combout\,
	cout => \current_timer[6]~45\);

-- Location: LCCOMB_X12_Y7_N24
\current_timer[12]~56\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[12]~56_combout\ = (current_timer(12) & (\current_timer[11]~55\ $ (GND))) # (!current_timer(12) & (!\current_timer[11]~55\ & VCC))
-- \current_timer[12]~57\ = CARRY((current_timer(12) & !\current_timer[11]~55\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(12),
	datad => VCC,
	cin => \current_timer[11]~55\,
	combout => \current_timer[12]~56_combout\,
	cout => \current_timer[12]~57\);

-- Location: LCCOMB_X13_Y7_N2
\LessThan2~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~1_combout\ = (current_timer(6) & (current_timer(8) & current_timer(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(6),
	datab => current_timer(8),
	datad => current_timer(9),
	combout => \LessThan2~1_combout\);

-- Location: LCCOMB_X13_Y7_N12
\LessThan2~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~6_combout\ = (current_timer(15)) # ((current_timer(16)) # (current_timer(17)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(15),
	datac => current_timer(16),
	datad => current_timer(17),
	combout => \LessThan2~6_combout\);

-- Location: LCCOMB_X13_Y7_N10
\LessThan0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~0_combout\ = (!current_timer(12) & !current_timer(13))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => current_timer(12),
	datad => current_timer(13),
	combout => \LessThan0~0_combout\);

-- Location: LCCOMB_X13_Y7_N6
\LessThan0~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~4_combout\ = ((!current_timer(13) & (!current_timer(14) & !current_timer(12)))) # (!current_timer(15))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(15),
	datab => current_timer(13),
	datac => current_timer(14),
	datad => current_timer(12),
	combout => \LessThan0~4_combout\);

-- Location: PIN_17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\clock~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_clock,
	combout => \clock~combout\);

-- Location: CLKCTRL_G2
\clock~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clock~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clock~clkctrl_outclk\);

-- Location: PIN_144,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\reset~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_reset,
	combout => \reset~combout\);

-- Location: LCCOMB_X12_Y7_N0
\current_timer[0]~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[0]~32_combout\ = current_timer(0) $ (VCC)
-- \current_timer[0]~33\ = CARRY(current_timer(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => current_timer(0),
	datad => VCC,
	combout => \current_timer[0]~32_combout\,
	cout => \current_timer[0]~33\);

-- Location: LCCOMB_X12_Y6_N8
\current_timer[20]~72\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[20]~72_combout\ = (current_timer(20) & (\current_timer[19]~71\ $ (GND))) # (!current_timer(20) & (!\current_timer[19]~71\ & VCC))
-- \current_timer[20]~73\ = CARRY((current_timer(20) & !\current_timer[19]~71\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(20),
	datad => VCC,
	cin => \current_timer[19]~71\,
	combout => \current_timer[20]~72_combout\,
	cout => \current_timer[20]~73\);

-- Location: LCCOMB_X12_Y6_N10
\current_timer[21]~74\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[21]~74_combout\ = (current_timer(21) & (!\current_timer[20]~73\)) # (!current_timer(21) & ((\current_timer[20]~73\) # (GND)))
-- \current_timer[21]~75\ = CARRY((!\current_timer[20]~73\) # (!current_timer(21)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(21),
	datad => VCC,
	cin => \current_timer[20]~73\,
	combout => \current_timer[21]~74_combout\,
	cout => \current_timer[21]~75\);

-- Location: LCFF_X13_Y7_N11
\current_timer[21]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	sdata => \current_timer[21]~74_combout\,
	sclr => \next_timer[31]~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(21));

-- Location: LCCOMB_X12_Y6_N12
\current_timer[22]~76\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[22]~76_combout\ = (current_timer(22) & (\current_timer[21]~75\ $ (GND))) # (!current_timer(22) & (!\current_timer[21]~75\ & VCC))
-- \current_timer[22]~77\ = CARRY((current_timer(22) & !\current_timer[21]~75\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(22),
	datad => VCC,
	cin => \current_timer[21]~75\,
	combout => \current_timer[22]~76_combout\,
	cout => \current_timer[22]~77\);

-- Location: LCFF_X13_Y7_N9
\current_timer[22]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	sdata => \current_timer[22]~76_combout\,
	sclr => \next_timer[31]~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(22));

-- Location: LCCOMB_X12_Y6_N14
\current_timer[23]~78\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[23]~78_combout\ = (current_timer(23) & (!\current_timer[22]~77\)) # (!current_timer(23) & ((\current_timer[22]~77\) # (GND)))
-- \current_timer[23]~79\ = CARRY((!\current_timer[22]~77\) # (!current_timer(23)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(23),
	datad => VCC,
	cin => \current_timer[22]~77\,
	combout => \current_timer[23]~78_combout\,
	cout => \current_timer[23]~79\);

-- Location: LCFF_X12_Y6_N15
\current_timer[23]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[23]~78_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(23));

-- Location: LCCOMB_X12_Y6_N16
\current_timer[24]~80\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[24]~80_combout\ = (current_timer(24) & (\current_timer[23]~79\ $ (GND))) # (!current_timer(24) & (!\current_timer[23]~79\ & VCC))
-- \current_timer[24]~81\ = CARRY((current_timer(24) & !\current_timer[23]~79\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(24),
	datad => VCC,
	cin => \current_timer[23]~79\,
	combout => \current_timer[24]~80_combout\,
	cout => \current_timer[24]~81\);

-- Location: LCCOMB_X12_Y6_N18
\current_timer[25]~82\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[25]~82_combout\ = (current_timer(25) & (!\current_timer[24]~81\)) # (!current_timer(25) & ((\current_timer[24]~81\) # (GND)))
-- \current_timer[25]~83\ = CARRY((!\current_timer[24]~81\) # (!current_timer(25)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(25),
	datad => VCC,
	cin => \current_timer[24]~81\,
	combout => \current_timer[25]~82_combout\,
	cout => \current_timer[25]~83\);

-- Location: LCFF_X12_Y6_N19
\current_timer[25]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[25]~82_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(25));

-- Location: LCCOMB_X12_Y6_N20
\current_timer[26]~84\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[26]~84_combout\ = (current_timer(26) & (\current_timer[25]~83\ $ (GND))) # (!current_timer(26) & (!\current_timer[25]~83\ & VCC))
-- \current_timer[26]~85\ = CARRY((current_timer(26) & !\current_timer[25]~83\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(26),
	datad => VCC,
	cin => \current_timer[25]~83\,
	combout => \current_timer[26]~84_combout\,
	cout => \current_timer[26]~85\);

-- Location: LCCOMB_X12_Y6_N22
\current_timer[27]~86\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[27]~86_combout\ = (current_timer(27) & (!\current_timer[26]~85\)) # (!current_timer(27) & ((\current_timer[26]~85\) # (GND)))
-- \current_timer[27]~87\ = CARRY((!\current_timer[26]~85\) # (!current_timer(27)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(27),
	datad => VCC,
	cin => \current_timer[26]~85\,
	combout => \current_timer[27]~86_combout\,
	cout => \current_timer[27]~87\);

-- Location: LCFF_X12_Y6_N23
\current_timer[27]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[27]~86_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(27));

-- Location: LCCOMB_X12_Y6_N24
\current_timer[28]~88\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[28]~88_combout\ = (current_timer(28) & (\current_timer[27]~87\ $ (GND))) # (!current_timer(28) & (!\current_timer[27]~87\ & VCC))
-- \current_timer[28]~89\ = CARRY((current_timer(28) & !\current_timer[27]~87\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(28),
	datad => VCC,
	cin => \current_timer[27]~87\,
	combout => \current_timer[28]~88_combout\,
	cout => \current_timer[28]~89\);

-- Location: LCFF_X12_Y6_N25
\current_timer[28]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[28]~88_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(28));

-- Location: LCFF_X12_Y6_N21
\current_timer[26]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[26]~84_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(26));

-- Location: LCFF_X12_Y6_N17
\current_timer[24]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[24]~80_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(24));

-- Location: LCCOMB_X13_Y7_N16
\next_timer[31]~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \next_timer[31]~0_combout\ = (!current_timer(25) & (!current_timer(26) & (!current_timer(24) & !current_timer(27))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(25),
	datab => current_timer(26),
	datac => current_timer(24),
	datad => current_timer(27),
	combout => \next_timer[31]~0_combout\);

-- Location: LCCOMB_X12_Y6_N26
\current_timer[29]~90\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[29]~90_combout\ = (current_timer(29) & (!\current_timer[28]~89\)) # (!current_timer(29) & ((\current_timer[28]~89\) # (GND)))
-- \current_timer[29]~91\ = CARRY((!\current_timer[28]~89\) # (!current_timer(29)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(29),
	datad => VCC,
	cin => \current_timer[28]~89\,
	combout => \current_timer[29]~90_combout\,
	cout => \current_timer[29]~91\);

-- Location: LCFF_X12_Y6_N27
\current_timer[29]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[29]~90_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(29));

-- Location: LCCOMB_X12_Y6_N28
\current_timer[30]~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[30]~92_combout\ = (current_timer(30) & (\current_timer[29]~91\ $ (GND))) # (!current_timer(30) & (!\current_timer[29]~91\ & VCC))
-- \current_timer[30]~93\ = CARRY((current_timer(30) & !\current_timer[29]~91\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(30),
	datad => VCC,
	cin => \current_timer[29]~91\,
	combout => \current_timer[30]~92_combout\,
	cout => \current_timer[30]~93\);

-- Location: LCFF_X12_Y6_N29
\current_timer[30]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[30]~92_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(30));

-- Location: LCCOMB_X13_Y7_N26
\next_timer[31]~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \next_timer[31]~1_combout\ = (!current_timer(29) & (!current_timer(28) & (\next_timer[31]~0_combout\ & !current_timer(30))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(29),
	datab => current_timer(28),
	datac => \next_timer[31]~0_combout\,
	datad => current_timer(30),
	combout => \next_timer[31]~1_combout\);

-- Location: LCCOMB_X12_Y6_N6
\current_timer[19]~70\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[19]~70_combout\ = (current_timer(19) & (!\current_timer[18]~69\)) # (!current_timer(19) & ((\current_timer[18]~69\) # (GND)))
-- \current_timer[19]~71\ = CARRY((!\current_timer[18]~69\) # (!current_timer(19)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(19),
	datad => VCC,
	cin => \current_timer[18]~69\,
	combout => \current_timer[19]~70_combout\,
	cout => \current_timer[19]~71\);

-- Location: LCFF_X12_Y6_N7
\current_timer[19]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[19]~70_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(19));

-- Location: LCCOMB_X13_Y7_N18
\LessThan0~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~6_combout\ = (!current_timer(21) & (!current_timer(22) & ((!current_timer(20)) # (!current_timer(19)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(21),
	datab => current_timer(22),
	datac => current_timer(19),
	datad => current_timer(20),
	combout => \LessThan0~6_combout\);

-- Location: LCCOMB_X13_Y7_N24
\LessThan0~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~7_combout\ = (\LessThan0~6_combout\) # (!current_timer(23))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => current_timer(23),
	datad => \LessThan0~6_combout\,
	combout => \LessThan0~7_combout\);

-- Location: LCCOMB_X12_Y6_N2
\current_timer[17]~66\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[17]~66_combout\ = (current_timer(17) & (!\current_timer[16]~65\)) # (!current_timer(17) & ((\current_timer[16]~65\) # (GND)))
-- \current_timer[17]~67\ = CARRY((!\current_timer[16]~65\) # (!current_timer(17)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(17),
	datad => VCC,
	cin => \current_timer[16]~65\,
	combout => \current_timer[17]~66_combout\,
	cout => \current_timer[17]~67\);

-- Location: LCFF_X13_Y7_N3
\current_timer[17]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	sdata => \current_timer[17]~66_combout\,
	sclr => \next_timer[31]~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(17));

-- Location: LCCOMB_X13_Y7_N4
\LessThan0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~1_combout\ = (!current_timer(16) & (!current_timer(22) & (!current_timer(17) & !current_timer(21))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(16),
	datab => current_timer(22),
	datac => current_timer(17),
	datad => current_timer(21),
	combout => \LessThan0~1_combout\);

-- Location: LCCOMB_X12_Y7_N16
\current_timer[8]~48\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[8]~48_combout\ = (current_timer(8) & (\current_timer[7]~47\ $ (GND))) # (!current_timer(8) & (!\current_timer[7]~47\ & VCC))
-- \current_timer[8]~49\ = CARRY((current_timer(8) & !\current_timer[7]~47\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(8),
	datad => VCC,
	cin => \current_timer[7]~47\,
	combout => \current_timer[8]~48_combout\,
	cout => \current_timer[8]~49\);

-- Location: LCFF_X12_Y7_N17
\current_timer[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[8]~48_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(8));

-- Location: LCCOMB_X12_Y7_N20
\current_timer[10]~52\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[10]~52_combout\ = (current_timer(10) & (\current_timer[9]~51\ $ (GND))) # (!current_timer(10) & (!\current_timer[9]~51\ & VCC))
-- \current_timer[10]~53\ = CARRY((current_timer(10) & !\current_timer[9]~51\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(10),
	datad => VCC,
	cin => \current_timer[9]~51\,
	combout => \current_timer[10]~52_combout\,
	cout => \current_timer[10]~53\);

-- Location: LCFF_X12_Y7_N21
\current_timer[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[10]~52_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(10));

-- Location: LCCOMB_X13_Y7_N14
\LessThan0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~2_combout\ = (((!current_timer(7) & !current_timer(8))) # (!current_timer(9))) # (!current_timer(10))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(7),
	datab => current_timer(8),
	datac => current_timer(10),
	datad => current_timer(9),
	combout => \LessThan0~2_combout\);

-- Location: LCCOMB_X13_Y7_N28
\LessThan0~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~3_combout\ = (!current_timer(14) & (!current_timer(11) & (\LessThan0~2_combout\ & !current_timer(13))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(14),
	datab => current_timer(11),
	datac => \LessThan0~2_combout\,
	datad => current_timer(13),
	combout => \LessThan0~3_combout\);

-- Location: LCCOMB_X13_Y7_N0
\LessThan0~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan0~5_combout\ = (\LessThan0~1_combout\ & (!current_timer(18) & ((\LessThan0~4_combout\) # (\LessThan0~3_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~4_combout\,
	datab => \LessThan0~1_combout\,
	datac => current_timer(18),
	datad => \LessThan0~3_combout\,
	combout => \LessThan0~5_combout\);

-- Location: LCCOMB_X13_Y7_N30
\next_timer[31]~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \next_timer[31]~2_combout\ = (current_timer(31)) # (((!\LessThan0~7_combout\ & !\LessThan0~5_combout\)) # (!\next_timer[31]~1_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(31),
	datab => \next_timer[31]~1_combout\,
	datac => \LessThan0~7_combout\,
	datad => \LessThan0~5_combout\,
	combout => \next_timer[31]~2_combout\);

-- Location: LCFF_X12_Y7_N1
\current_timer[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[0]~32_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(0));

-- Location: LCCOMB_X12_Y7_N2
\current_timer[1]~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[1]~34_combout\ = (current_timer(1) & (!\current_timer[0]~33\)) # (!current_timer(1) & ((\current_timer[0]~33\) # (GND)))
-- \current_timer[1]~35\ = CARRY((!\current_timer[0]~33\) # (!current_timer(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(1),
	datad => VCC,
	cin => \current_timer[0]~33\,
	combout => \current_timer[1]~34_combout\,
	cout => \current_timer[1]~35\);

-- Location: LCFF_X12_Y7_N3
\current_timer[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[1]~34_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(1));

-- Location: LCCOMB_X12_Y7_N4
\current_timer[2]~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[2]~36_combout\ = (current_timer(2) & (\current_timer[1]~35\ $ (GND))) # (!current_timer(2) & (!\current_timer[1]~35\ & VCC))
-- \current_timer[2]~37\ = CARRY((current_timer(2) & !\current_timer[1]~35\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(2),
	datad => VCC,
	cin => \current_timer[1]~35\,
	combout => \current_timer[2]~36_combout\,
	cout => \current_timer[2]~37\);

-- Location: LCFF_X12_Y7_N5
\current_timer[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[2]~36_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(2));

-- Location: LCCOMB_X12_Y7_N6
\current_timer[3]~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[3]~38_combout\ = (current_timer(3) & (!\current_timer[2]~37\)) # (!current_timer(3) & ((\current_timer[2]~37\) # (GND)))
-- \current_timer[3]~39\ = CARRY((!\current_timer[2]~37\) # (!current_timer(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(3),
	datad => VCC,
	cin => \current_timer[2]~37\,
	combout => \current_timer[3]~38_combout\,
	cout => \current_timer[3]~39\);

-- Location: LCCOMB_X12_Y7_N8
\current_timer[4]~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[4]~40_combout\ = (current_timer(4) & (\current_timer[3]~39\ $ (GND))) # (!current_timer(4) & (!\current_timer[3]~39\ & VCC))
-- \current_timer[4]~41\ = CARRY((current_timer(4) & !\current_timer[3]~39\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(4),
	datad => VCC,
	cin => \current_timer[3]~39\,
	combout => \current_timer[4]~40_combout\,
	cout => \current_timer[4]~41\);

-- Location: LCFF_X12_Y7_N9
\current_timer[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[4]~40_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(4));

-- Location: LCCOMB_X12_Y7_N10
\current_timer[5]~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[5]~42_combout\ = (current_timer(5) & (!\current_timer[4]~41\)) # (!current_timer(5) & ((\current_timer[4]~41\) # (GND)))
-- \current_timer[5]~43\ = CARRY((!\current_timer[4]~41\) # (!current_timer(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(5),
	datad => VCC,
	cin => \current_timer[4]~41\,
	combout => \current_timer[5]~42_combout\,
	cout => \current_timer[5]~43\);

-- Location: LCCOMB_X12_Y7_N14
\current_timer[7]~46\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[7]~46_combout\ = (current_timer(7) & (!\current_timer[6]~45\)) # (!current_timer(7) & ((\current_timer[6]~45\) # (GND)))
-- \current_timer[7]~47\ = CARRY((!\current_timer[6]~45\) # (!current_timer(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(7),
	datad => VCC,
	cin => \current_timer[6]~45\,
	combout => \current_timer[7]~46_combout\,
	cout => \current_timer[7]~47\);

-- Location: LCFF_X12_Y7_N15
\current_timer[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[7]~46_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(7));

-- Location: LCCOMB_X12_Y7_N18
\current_timer[9]~50\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[9]~50_combout\ = (current_timer(9) & (!\current_timer[8]~49\)) # (!current_timer(9) & ((\current_timer[8]~49\) # (GND)))
-- \current_timer[9]~51\ = CARRY((!\current_timer[8]~49\) # (!current_timer(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(9),
	datad => VCC,
	cin => \current_timer[8]~49\,
	combout => \current_timer[9]~50_combout\,
	cout => \current_timer[9]~51\);

-- Location: LCFF_X12_Y7_N19
\current_timer[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[9]~50_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(9));

-- Location: LCCOMB_X12_Y7_N22
\current_timer[11]~54\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[11]~54_combout\ = (current_timer(11) & (!\current_timer[10]~53\)) # (!current_timer(11) & ((\current_timer[10]~53\) # (GND)))
-- \current_timer[11]~55\ = CARRY((!\current_timer[10]~53\) # (!current_timer(11)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(11),
	datad => VCC,
	cin => \current_timer[10]~53\,
	combout => \current_timer[11]~54_combout\,
	cout => \current_timer[11]~55\);

-- Location: LCFF_X12_Y7_N23
\current_timer[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[11]~54_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(11));

-- Location: LCCOMB_X12_Y7_N26
\current_timer[13]~58\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[13]~58_combout\ = (current_timer(13) & (!\current_timer[12]~57\)) # (!current_timer(13) & ((\current_timer[12]~57\) # (GND)))
-- \current_timer[13]~59\ = CARRY((!\current_timer[12]~57\) # (!current_timer(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(13),
	datad => VCC,
	cin => \current_timer[12]~57\,
	combout => \current_timer[13]~58_combout\,
	cout => \current_timer[13]~59\);

-- Location: LCFF_X12_Y7_N27
\current_timer[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[13]~58_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(13));

-- Location: LCCOMB_X12_Y7_N28
\current_timer[14]~60\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[14]~60_combout\ = (current_timer(14) & (\current_timer[13]~59\ $ (GND))) # (!current_timer(14) & (!\current_timer[13]~59\ & VCC))
-- \current_timer[14]~61\ = CARRY((current_timer(14) & !\current_timer[13]~59\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(14),
	datad => VCC,
	cin => \current_timer[13]~59\,
	combout => \current_timer[14]~60_combout\,
	cout => \current_timer[14]~61\);

-- Location: LCFF_X12_Y7_N29
\current_timer[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[14]~60_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(14));

-- Location: LCCOMB_X12_Y7_N30
\current_timer[15]~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[15]~62_combout\ = (current_timer(15) & (!\current_timer[14]~61\)) # (!current_timer(15) & ((\current_timer[14]~61\) # (GND)))
-- \current_timer[15]~63\ = CARRY((!\current_timer[14]~61\) # (!current_timer(15)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(15),
	datad => VCC,
	cin => \current_timer[14]~61\,
	combout => \current_timer[15]~62_combout\,
	cout => \current_timer[15]~63\);

-- Location: LCFF_X12_Y7_N31
\current_timer[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[15]~62_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(15));

-- Location: LCCOMB_X12_Y6_N0
\current_timer[16]~64\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[16]~64_combout\ = (current_timer(16) & (\current_timer[15]~63\ $ (GND))) # (!current_timer(16) & (!\current_timer[15]~63\ & VCC))
-- \current_timer[16]~65\ = CARRY((current_timer(16) & !\current_timer[15]~63\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(16),
	datad => VCC,
	cin => \current_timer[15]~63\,
	combout => \current_timer[16]~64_combout\,
	cout => \current_timer[16]~65\);

-- Location: LCFF_X13_Y7_N13
\current_timer[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	sdata => \current_timer[16]~64_combout\,
	sclr => \next_timer[31]~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(16));

-- Location: LCCOMB_X12_Y6_N4
\current_timer[18]~68\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[18]~68_combout\ = (current_timer(18) & (\current_timer[17]~67\ $ (GND))) # (!current_timer(18) & (!\current_timer[17]~67\ & VCC))
-- \current_timer[18]~69\ = CARRY((current_timer(18) & !\current_timer[17]~67\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => current_timer(18),
	datad => VCC,
	cin => \current_timer[17]~67\,
	combout => \current_timer[18]~68_combout\,
	cout => \current_timer[18]~69\);

-- Location: LCFF_X12_Y6_N5
\current_timer[18]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[18]~68_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(18));

-- Location: LCFF_X12_Y6_N9
\current_timer[20]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[20]~72_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(20));

-- Location: LCCOMB_X13_Y7_N8
\LessThan2~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~0_combout\ = (current_timer(23)) # ((current_timer(22) & ((current_timer(20)) # (current_timer(21)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(23),
	datab => current_timer(20),
	datac => current_timer(22),
	datad => current_timer(21),
	combout => \LessThan2~0_combout\);

-- Location: LCCOMB_X13_Y7_N20
\LessThan2~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~8_combout\ = (current_timer(10)) # ((current_timer(7) & (current_timer(8) & current_timer(9))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(7),
	datab => current_timer(8),
	datac => current_timer(10),
	datad => current_timer(9),
	combout => \LessThan2~8_combout\);

-- Location: LCCOMB_X13_Y7_N22
\LessThan2~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~9_combout\ = (current_timer(14) & (((\LessThan2~8_combout\ & current_timer(11))) # (!\LessThan0~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~0_combout\,
	datab => \LessThan2~8_combout\,
	datac => current_timer(14),
	datad => current_timer(11),
	combout => \LessThan2~9_combout\);

-- Location: LCCOMB_X14_Y7_N0
\LessThan2~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~7_combout\ = (current_timer(22) & (current_timer(18) & current_timer(19)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(22),
	datab => current_timer(18),
	datad => current_timer(19),
	combout => \LessThan2~7_combout\);

-- Location: LCCOMB_X14_Y7_N2
\LessThan2~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~10_combout\ = ((\LessThan2~7_combout\ & ((\LessThan2~6_combout\) # (\LessThan2~9_combout\)))) # (!\next_timer[31]~1_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan2~6_combout\,
	datab => \LessThan2~9_combout\,
	datac => \next_timer[31]~1_combout\,
	datad => \LessThan2~7_combout\,
	combout => \LessThan2~10_combout\);

-- Location: LCCOMB_X12_Y6_N30
\current_timer[31]~94\ : cycloneii_lcell_comb
-- Equation(s):
-- \current_timer[31]~94_combout\ = \current_timer[30]~93\ $ (current_timer(31))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => current_timer(31),
	cin => \current_timer[30]~93\,
	combout => \current_timer[31]~94_combout\);

-- Location: LCFF_X12_Y6_N31
\current_timer[31]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[31]~94_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(31));

-- Location: LCFF_X12_Y7_N11
\current_timer[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[5]~42_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(5));

-- Location: LCFF_X12_Y7_N7
\current_timer[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock~clkctrl_outclk\,
	datain => \current_timer[3]~38_combout\,
	sclr => \next_timer[31]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => current_timer(3));

-- Location: LCCOMB_X14_Y7_N10
\LessThan2~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~3_combout\ = (current_timer(2)) # ((current_timer(1)) # ((current_timer(3)) # (current_timer(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(2),
	datab => current_timer(1),
	datac => current_timer(3),
	datad => current_timer(0),
	combout => \LessThan2~3_combout\);

-- Location: LCCOMB_X14_Y7_N28
\LessThan2~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~4_combout\ = (current_timer(5)) # ((current_timer(4)) # (\LessThan2~3_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => current_timer(5),
	datac => current_timer(4),
	datad => \LessThan2~3_combout\,
	combout => \LessThan2~4_combout\);

-- Location: LCCOMB_X14_Y7_N12
\LessThan2~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~2_combout\ = (current_timer(22) & (current_timer(18) & (current_timer(14) & current_timer(19))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => current_timer(22),
	datab => current_timer(18),
	datac => current_timer(14),
	datad => current_timer(19),
	combout => \LessThan2~2_combout\);

-- Location: LCCOMB_X14_Y7_N30
\LessThan2~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~5_combout\ = (\LessThan2~1_combout\ & (\LessThan2~4_combout\ & (current_timer(11) & \LessThan2~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan2~1_combout\,
	datab => \LessThan2~4_combout\,
	datac => current_timer(11),
	datad => \LessThan2~2_combout\,
	combout => \LessThan2~5_combout\);

-- Location: LCCOMB_X14_Y7_N8
\LessThan2~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \LessThan2~11_combout\ = (!current_timer(31) & ((\LessThan2~0_combout\) # ((\LessThan2~10_combout\) # (\LessThan2~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan2~0_combout\,
	datab => \LessThan2~10_combout\,
	datac => current_timer(31),
	datad => \LessThan2~5_combout\,
	combout => \LessThan2~11_combout\);

-- Location: PIN_3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \reset~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(0));

-- Location: PIN_7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LessThan2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(1));

-- Location: PIN_9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LessThan2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(2));

-- Location: PIN_86,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LessThan2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(3));

-- Location: PIN_81,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LessThan2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(4));

-- Location: PIN_80,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LessThan2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(5));

-- Location: PIN_75,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LessThan2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(6));

-- Location: PIN_74,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\output[7]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LessThan2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_output(7));
END structure;


