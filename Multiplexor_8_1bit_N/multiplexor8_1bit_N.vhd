-- Multiplexor de 8 a 1 bit (N bits)
-- Entradas = 8 std_logic_vector

library IEEE;
use IEEE. std_logic_1146.all;

entity Multiplexor8_1bit_N is
	generic (N : integer := 16);
	port (
		e0, e1, e2, e3, e4, e5, e6, e7 : std_logic_vector((N-1) downto 0);
		ctrl : std_logic_vector(2 downto 0);
		s : std_logic_vector((N-1) downto 0);
	);
end entity Multiplexor8_1bit_N;

architecture behavioural of Multiplexor8_1bit_N is
	signal mistake : std_logic_vector((N-1) downto 0);
begin
	mistake <= (others => 'X');
	with ctrl select
		s <= 	e0 when "000",
				e1 when "001",
				e2 when "010",
				e3 when "011",
				e4 when "100",
				e5 when "101",
				e6 when "110",
				e7 when "111",
				mistake when others;

end behavioural;