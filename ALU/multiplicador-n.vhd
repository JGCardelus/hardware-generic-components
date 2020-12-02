library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplicador5 is
	generic (n : integer := 5);
	port(
		a,b: in std_logic_vector((n-1) downto 0); --entradas
		p: out std_logic_vector((n-1) downto 0); --salida truncada
		ov: out std_logic
	);
end Multiplicador5;

architecture behavioral of Multiplicador5 is
	signal s_int: std_logic_vector(9 downto 0);
begin
	s_int <= std_logic_vector(signed(a)*signed(b)); --resultado sin truncar (10 bits)
	p <= s_int(4 downto 0); --resultado truncado a 5 bits
	
	with s_int(9 downto 4) select
		ov <= 	'0' when "000000",
					'0' when "111111",
					'1' when others;
end behavioral;