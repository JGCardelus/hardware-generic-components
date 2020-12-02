library IEEE;
use IEEE.std_logic_1164.all;

entity DetectorSequencia is
	port (
		p0, p1, clk, reset_n : in std_logic;
		s : out std_logic
	);
end DetectorSequencia;

architecture behavioural of DetectorSequencia is

	type states is (Closed, P0, P0P1, P0P1P1, P0P1P1P0);
	signal state_current, state_next : states;
	signal entradas : std_logic_vector(1 downto 0);

begin
	i1: entity work.DetectorFlanco
		port map (
			e => p0,
			clk => clk,
			reset_n => reset_n,
			s => entradas(1)
		);

	i2: entity work.DetectorFlanco
		port map (
			e => p1,
			clk => clk,
			reset_n => reset_n,
			s => entradas(0)
		);

	EventHandler : process (clk, reset_n)
	begin
		if not(reset_n) = '1' then
			state_current <= Closed;
		elsif clk'event and clk = '1' then
			state_current <= state_next;
		end if;
	end process EventHandler;

	StateManager : process(entradas, state_next)
	begin
		state_next <= state_current;
		case state_current is
			when Closed =>
				if entradas = "11" then
					state_next <= P0;
				end if;
			when P0 =>
				if entradas = "01" then
					state_next <= P0P1;
				elsif entradas = "11" then
					state_next <= closed;
				end if;
			when P0P1 =>
				if entradas = "01" then
					state_next <= P0P1P1;
				elsif entradas = "10" then
					state_next <= P0; -- If you hit 0, start sequence again
				elsif entradas = "11" then
					state_next <= Closed;
				end if;
			when P0P1P1 =>
				if entradas = "10" then
					state_next <= P0P1P1P0;
				elsif entradas = "01" or entradas = "11" then
					state_next <= Closed;
				end if;
			when P0P1P1P0 =>
				if entradas = "10" then
					state_next <= P0; -- If you hit p0, start sequence again
				elsif entradas = "01" then
					state_next <= P0P1; -- If you press p1, chain sequence
				elsif entradas = "11" then
					state_next <= Closed;
				end if;
			when others =>
				state_next <= state_current;
		end case;
	end process StateManager;

	s <= '1' when state_current = P0P1P1P0 else '0';
end behavioural;