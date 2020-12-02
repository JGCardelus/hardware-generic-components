library IEEE;
use IEEE.std_logic_1164.all;
use work.Multiplexor2_5bits_1_Variables.all;
use work.Multiplexor3_5bits_1_Variables.all;

entity ALU is
	port (
		a, b : in std_logic_vector(4 downto 0);
		sel : in std_logic_vector(2 downto 0);
		s : out std_logic_vector(4 downto 0);
		ov: out std_logic
	);
end ALU;

architecture behavioural of ALU is
	-- Control unit signals
	signal sel_out, sel_log: std_logic_vector(1 downto 0);
	signal sr, sel_use_b, sel_ov_origin: std_logic;
	-- Sum/Subtraction
	signal mod_b : std_logic_vector(4 downto 0);
	signal sum_ov : std_logic;
	signal sum_multiplexor_inputs : e_vector2_5bits;
	-- Product
	signal product_ov : std_logic;
	-- Output signals
	signal s_logic_unit, s_product, s_sum: std_logic_vector(4 downto 0);
	-- Output multiplexor input
	signal output_multiplexor_input: e_vector3_5bits;
	-- Overflow multiplexor input
	signal overflow_multiplexor_input: std_logic_vector(1 downto 0);

begin
	control_unit: entity work.ControlUnit
		port map(
			sel => sel,
			sel_ov_origin => sel_ov_origin,
			sr => sr,
			sel_use_b => sel_use_b,
			sel_log => sel_log,
			sel_out => sel_out
		);

	logic_unit: entity work.LogicUnit
		port map (
			a => a,
			b => b,
			c => sel_log,
			s => s_logic_unit
		);

	sum_multiplexor_inputs(0) <= "00001";
	sum_multiplexor_inputs(1) <= b;
	sum_multiplexor: entity work.Multiplexor2_5bits_1
		port map (
			e => sum_multiplexor_inputs,
			c => sel_use_b,
			s => mod_b
		);

	sum: entity work.SumadorRestador
		port map (
			a => a,
			b => mod_b,
			sr => sr,
			ov => sum_ov,
			s => s_sum
		);

	product: entity work.Multiplicador5
		port map (
			a => a,
			b => b,
			p => s_product,
			ov => product_ov
		);

	output_multiplexor_input(0) <= s_logic_unit;
	output_multiplexor_input(1) <= s_sum;
	output_multiplexor_input(2) <= s_product;
	output_multiplexor: entity work.Multiplexor3_5bits_1
		port map (
			e => output_multiplexor_input,
			c => sel_out,
			s => s
		);

	overflow_multiplexor_input(0) <= sum_ov;
	overflow_multiplexor_input(1) <= product_ov;
	overflow_multiplexor: entity work.Multiplexor2_1bit_1
		port map (
			e => overflow_multiplexor_input,
			c => sel_ov_origin,
			s => ov
		);


end behavioural;