-- Create custom variables
library IEEE;
use IEEE.std_logic_1164.all;

entity LogicUnit is
	port (
		a,b : in std_logic_vector(4 downto 0);
		c : in std_logic_vector(1 downto 0);
		s : out std_logic_vector(4 downto 0)
	);
end LogicUnit;

architecture behavioural of LogicUnit is
	type e_vector is array (0 to 4) of std_logic_vector(4 downto 0);
	signal e : e_vector;
begin
	-- Inputs of multiplexor & logic functions
	e(0) <= (a and b);
	e(1) <= (a or b);
	e(2) <= (a xor b);
	e(3) <= (not a);

	-- Multiplexor
	with c select
		s <= 	e(0) when "00",
				e(1) when "01",
				e(2) when "10",
				e(3) when "11",
				"XXXXX" when others;
	
end behavioural;