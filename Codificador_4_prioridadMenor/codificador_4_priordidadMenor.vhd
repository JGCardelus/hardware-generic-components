library IEEE;
use IEEE.std_logic_1164.all;

entity Codificador_4_prioridadMenor is
	port (
		e : in std_logic_vector(3 downto 0);
		s : out std_logic_vector(1 downto 0)
	);
end Codificador_4_prioridadMenor;

architecture behavioural of Codificador_4_prioridadMenor is
begin

	s(1) <= (not e(0)) or ((not e(0)) and (not e(1)) and (not e(2)) and (not e(3)));
	s(0) <= ((not e(2)) and (not e(0)) and e(3)) or ((not e(0)) and e(1));

end behavioural;