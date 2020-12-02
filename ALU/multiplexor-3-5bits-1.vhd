-- Create custom variables
library IEEE;
use IEEE.std_logic_1164.all;

package Multiplexor3_5bits_1_Variables is
	type e_vector3_5bits is array (0 to 2) of std_logic_vector(4 downto 0);
end Multiplexor3_5bits_1_Variables;

-- Load libraries and custom variables for multiplexor
library IEEE;
use IEEE.std_logic_1164.all;
use work.Multiplexor3_5bits_1_Variables.all;

entity Multiplexor3_5bits_1 is
	port (
		e : in e_vector3_5bits;
		s : out std_logic_vector(4 downto 0);
		c : in std_logic_vector(1 downto 0)
	);
end Multiplexor3_5bits_1;

architecture structural of Multiplexor3_5bits_1 is
begin
	with c select
		s <=	e(0) when "00",
				e(1) when "01",
				e(2) when "10",
				"XXXXX" when others;
end structural;