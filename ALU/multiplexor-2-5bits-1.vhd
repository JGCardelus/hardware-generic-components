-- Create custom variables
library IEEE;
use IEEE.std_logic_1164.all;

package Multiplexor2_5bits_1_Variables is
	type e_vector2_5bits is array (0 to 1) of std_logic_vector(4 downto 0);
end Multiplexor2_5bits_1_Variables;

-- Load libraries and custom variables for multiplexor
library IEEE;
use IEEE.std_logic_1164.all;
use work.Multiplexor2_5bits_1_Variables.all;

entity Multiplexor2_5bits_1 is
	port (
		e : in e_vector2_5bits;
		c : in std_logic;
		s : out std_logic_vector(4 downto 0)
	);
end Multiplexor2_5bits_1;

architecture structural of Multiplexor2_5bits_1 is
begin
	s <= e(0) when c = '0' else e(1); 
end structural;