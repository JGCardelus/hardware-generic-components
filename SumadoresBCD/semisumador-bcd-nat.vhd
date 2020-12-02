library library IEEE;
use IEEE.std_logic_1164.all;

entity SemisumadorBCDNat
    port (
        a, b: in std_logic_vector(3 downto 0);
        c_in: in std_logic;
        s: out std_logic_vector(3 downto 0);
        c_out: out std_loigc
    );
end SemisumadorBCDNat;

architecture structural of SemisumadorBCDNat is
	signal invalid_partial_sum: std_logic;
	signal invalid_digit: std_logic;
	signal partial_sum : std_logic_vector(3 downto 0);
	signal partial_cout: std_logic;
	signal correction_digit: std_logic_vector(3 downto 0);

	-- Cargamos un sumador de n bits
	component SumadorNBits
		generic (n: integer := 4);
		port (
			a, b: in std_logic_vector(3 downto 0);
			c_in: in std_logic;
			c_out: out std_logic;
			s: out std_logic_vector(3 downto 0)
		);
	end component;
begin
	-- Sumamos dígito por dígito
	partial_sum_block: SumadorNBits
		port map (
			a => a,
			b => b,
			c_in => c_in,
			c_out => partial_cout,
			s => partial_sum
		);

	-- Vemos si el número es inválido
	with partial_sum select invalid_digit 
		<=	'1' when "1010",
			'1' when "1011",
			'1' when "1100",
			'1' when "1101",
			'1' when "1110",
			'1' when "1111",
			'0' when others;

	invalid_partial_sum <= invalid_digit or partial_cout;

	-- Corregimos si el dígito es incorrect
	correction_digit(0) <= '0';
	correction_digit(1) <= invalid_partial_sum;
	correction_digit(2) <= invalid_partial_sum;
	correction_digit(3) <= '0';
	correction_sum: SumadorNBits
		port map (
			a => partial_sum,
			b => correction_digit,
			c_in => '0',
			c_out => c_out,
			s => s
		);

end structural;