library IEEE;
use IEEE.std_logic_1164.all;

entity Codificador_8_prioridadNo is
	port (
		e : in std_logic_vector(7 downto 0);
		i : out std_logic;
		s : out std_logic_vector(3 downto 0)
	);
end Codificador_8_prioridadNo;

architecture behavioural of Codificador_8_prioridadNo is
begin

	with e select
		s <= 	"0001" when "00000000",
				"0001" when "00000001",
				"0010" when "00000010",
				"0011" when "00000100",
				"0100" when "00001000",
				"0101" when "00010000",
				"0110" when "00100000",
				"0111" when "01000000",
				"1000" when "10000000",
				"XXXX" when others;

	i <= '1' when e = "00000000" else '0';
end behavioural;