library IEEE;
use IEEE.std_logic_1164.all;

-- Emits a pulse if detects an edge in the input

entity EdgeDetector is
	port (
		p, clk, reset_n : in std_logic;
		s : out std_logic
	);
end EdgeDetector;

architecture behavioural of EdgeDetector is
	-- Machinge states
	type states is (Waiting0, Pulse, Waiting1);
	signal state_current, state_next : states;
begin

	EventHandler : process (clk, reset_n)
	begin
		if not(reset_n) = '1' then
			state_current <= Waiting0;
		elsif clk'event and clk = '1' then
			state_current <= state_next;
		end if;
	end process EventHandler;

	StateManager : process(state_current, p)
	begin
		-- By default leave state as is
		state_next <= state_current;

		case state_current is
			when Waiting0 =>
				if p = '0' then
					state_next <= Pulse;
				end if;
			when Pulse =>
				if p = '1' then
					state_next <= Waiting0;
				else
					state_next <= Waiting1;
				end if;
			when Waiting1 =>
				if p = '1' then
					state_next <= Waiting0;
				end if;
			when others =>
				state_next <= Waiting0;
		end case;
	end process StateManager;

	OutputManager : process(state_current)
	begin
		s <= '0';
		case state_current is
			when Waiting0 =>
				null;
			when Waiting1 =>
				null;
			when Pulse =>
				s <= '1';
			when others => 
				null;
		end case;
	end process OutputManager;

end behavioural;