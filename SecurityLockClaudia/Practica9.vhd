library ieee;
use ieee.std_logic_1164.all;

entity Practica9 is
	port (
		p0,p1 : in std_logic;
		reset_n : in std_logic;
		clk : in std_logic;
		valid: out std_logic;
		espera : out std_logic);
end Practica9;

architecture structural of Practica9 is
	
	signal s : std_logic;
	
	component DetectorSecuencia
	 port (
		reset_n : in std_logic;
		clk : in std_logic;
		p1,p0 : in std_logic;
		s : out std_logic);
	end component;
	
begin
	
	DetSec : DetectorSecuencia
		port map (
			reset_n => reset_n,
			clk => clk,
			p1 => p1,
			p0 => p0,
			s => s);
			
	valid <= '1' when s = '1' else '0';
	espera <= '1' when s = '0' else '0';
	
end structural;
	
	