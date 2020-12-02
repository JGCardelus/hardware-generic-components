library IEEE;
use IEEE.std_logic_1164.all;

entity SumadorBCDNatNBits is 
	generic (n : integer := 16);
	port (
		a, b : in std_logic_vector((n-1) downto 0);
		d : out std_logic;
		s : out std_logic_vector((n-1) downto 0)
	);
end SumadorBCDNatNBits;

architecture behavioural of SumadorBCDNatNBits is
	signal c_i : std_logic_vector((n / 4) downto 0);
begin
	c_i(0) <= '0';

	sum_series: for i in (n / 4) to 0 generate
		partial_sum: entity work.SemisumadorBCDNat
			port map (
				a => a(((i*4) + 4) downto (i*4)),
				b => b(((i*4) + 4) downto (i*4)),
				c_in => c_i(i),
				c_out => c_i(i + 1),
				s => b(((i*4) + 4) downto (i*4))
			);
	end generate;

	d <= c_i(n/4);

end behavioural;