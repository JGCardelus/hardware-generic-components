library IEEE;
use IEEE.std_logic_1164.all;

entity Demultiplexor1_8bits_N is
	generic (n : integer := 16);
	port (
		e : in std_logic_vector((n-1) downto 0);
		ctr : in std_logic_vector(2 downto 0);
		s0, s1, s2, s3, s4, s5, s6, s7: out std_logic_vector((n-1) downto 0)
	);
end entity Demultiplexor1_8bits_N;

architecture behavioural of Demultiplexor1_8bits_N is
	signal null_ : std_logic_vetor((n-1) downto 0);
begin

	-- Very dirty way of doing a demultiplexor

	null_ <= (others => '0');

	s0 <= e when ctr = "000" else null_;
	s1 <= e when ctr = "001" else null_;
	s2 <= e when ctr = "010" else null_;
	s3 <= e when ctr = "011" else null_;
	s4 <= e when ctr = "100" else null_;
	s5 <= e when ctr = "101" else null_;
	s6 <= e when ctr = "110" else null_;
	s7 <= e when ctr = "111" else null_;

end behavioural;