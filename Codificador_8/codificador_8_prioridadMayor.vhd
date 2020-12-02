library IEEE;
use IEEE.std_logic_1164.all;

entity Codificador_8_prioridadMayor is
	port (
		e : in std_logic_vector(7 downto 0);
		i : out std_logic;
		s : out std_logic_vector(3 downto 0)
	);
end Codificador_8_prioridadMayor;

architecture behavioural of Codificador_8_prioridadMayor is
begin

	s <=	"0001" when e(0) = '1' else
			"0010" when e(1) = '1' else
			"0011" when e(2) = '1' else
			"0100" when e(3) = '1' else
			"0101" when e(4) = '1' else
			"0110" when e(5) = '1' else
			"0111" when e(6) = '1' else
			"1000" when e(7) = '1' else
			"0000";

	i <= '1' when e = "00000000" else '0';
end behavioural;