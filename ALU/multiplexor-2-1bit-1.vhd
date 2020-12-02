library IEEE;
use IEEE.std_logic_1164.all;

entity Multiplexor2_1bit_1 is
	port (
		e : in std_logic_vector(1 downto 0);
		c : in std_logic;
		s : out std_logic
	);
end Multiplexor2_1bit_1;

architecture structural of Multiplexor2_1bit_1 is
begin
	s <= e(1) when c = '1' else e(0);
end structural;