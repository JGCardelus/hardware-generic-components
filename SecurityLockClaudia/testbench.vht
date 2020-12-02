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

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "11/21/2020 09:54:28"
                                                            
-- Vhdl Test Bench template for design  :  Practica9
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY Practica9_vhd_tst IS
END Practica9_vhd_tst;
ARCHITECTURE Practica9_arch OF Practica9_vhd_tst IS
SIGNAL clk : STD_LOGIC:='0';
SIGNAL espera : STD_LOGIC;
SIGNAL p0 : STD_LOGIC;
SIGNAL p1 : STD_LOGIC;
SIGNAL reset_n : STD_LOGIC;
SIGNAL valid : STD_LOGIC;
COMPONENT Practica9
PORT (
 clk : IN STD_LOGIC;
 espera : OUT STD_LOGIC;
 p0 : IN STD_LOGIC;
 p1 : IN STD_LOGIC;
 reset_n : IN STD_LOGIC;
 valid : OUT STD_LOGIC);
END COMPONENT;
BEGIN
i1 : Practica9
PORT MAP (
 clk => clk,
 espera => espera,
 p0 => p0,
 p1 => p1,
 reset_n => reset_n,
 valid => valid);
init : PROCESS
-- variable declarations
BEGIN
-- code that executes only once
WAIT;
END PROCESS init;
clk <= not clk after 50 ns;
always : PROCESS
BEGIN
 reset_n <= '0';
 p1 <= '1';
 p0 <= '1';
 wait for 100 ns;
 reset_n <= '1';
 wait for 10 ns;
 p0 <= '0'; -- Pulso p0
 wait for 200 ns;
 p0 <= '1';
 wait for 200 ns;
 p1 <= '0'; -- Pulso p1
 wait for 200 ns;
 p1 <= '1';
 wait for 300 ns;
  p1 <= '0'; -- Pulso p1
 wait for 200 ns;
 p1 <= '1';
 wait for 300 ns;
 p0 <= '0'; -- Fin de secuencia: pulso en p0
 wait for 200 ns;
 p0 <= '1';
 assert valid = '1'
 report "Error: No se activa la salida tras introducir una secuencia correcta"
 severity warning;
 -- Enlazamos con otra nueva secuencia
 wait for 200 ns;
 p1 <= '0'; -- Pulso p1
 wait for 200 ns;
 p1 <= '1';
 assert valid = '0'
 report "Error: No se desactiva la salida tras volver a pulsar otra tecla"
 severity warning;
 wait for 300 ns;
 p1 <= '0'; -- Pulso p1
 wait for 200 ns;
 p1 <= '1';
 wait for 300 ns;
 p0 <= '0'; -- Fin de secuencia: pulso en p0
 wait for 200 ns;
 p0 <= '1';
 wait for 300 ns;
 assert valid = '1'
 report "Error: No se activa la salida tras introducir una secuencia correcta"
 severity warning;
 -- Volvemos a introducir una nueva secuencia
 p0 <= '0'; -- Pulso p0
 wait for 200 ns;
 p0 <= '1';
 wait for 200 ns;
 p1 <= '0'; -- Pulso p1
 wait for 200 ns;
 p1 <= '1';
 wait for 300 ns;
 p1 <= '0'; -- Pulso p1
 wait for 200 ns;
 p1 <= '1';
 wait for 300 ns;
 p0 <= '0'; -- Fin de secuencia: pulso en p0
 wait for 200 ns;
 p0 <= '1';
 assert valid = '1'
 report "Error: No se activa la salida tras introducir una secuencia correcta"
 severity warning;
 assert false
 report "Fin de la simulacion"
 severity failure;
END PROCESS always;
END Practica9_arch;

