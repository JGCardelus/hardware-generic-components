library IEEE;
use IEEE.std_logic_1164.all;

entity Lab9 is
	port (
		clk, reset_n, p0, p1 : in std_logic;
		espera, valid : out std_logic
	);
end Lab9;

architecture behavioural of Lab9 is
	signal s : std_logic;
begin

	sequenceDetector : entity work.SequenceDetector
		port map (
			clk => clk,
			reset_n => reset_n,
			p0 => p0,
			p1 => p1,
			s => s
		);

	valid <= '1' when s = '1' else '0';
	espera <= '1' when s = '0' else '0';

end behavioural;