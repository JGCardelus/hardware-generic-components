library IEEE;
use IEEE.std_logic_1164.all;

entity SumadorNBits is
	generic (n : integer := 4); -- Default to 4
	port (
		a, b: in std_logic_vector((n-1) downto 0);
		c_in: in std_logic;
		c_out: out std_logic;
		s: out std_logic_vector((n-1) downto 0)
	);
end SumadorNBits;

architecture behavioural of SumadorNBits is
	signal c_i : std_logic_vector(n downto 0);
	-- Cargar semisumador
	component Semisumador
		port (
			a, b: in std_logic;
			c_in: in std_logic;
			c_out: out std_logic;
			s: out std_loigc
		);
	end component;
begin
	c_i(0) <= c_in;

	digit_sums: for i in ((n-1) downto 0) generate
		digit_sum: Semisumador
			port map(
				a => a(i),
				b => b(i),
				c_in => c_i(i),
				c_out => c_i(i+1),
				s => s(i)
			);
	end generate;

end behavioural;

