library IEEE;
use IEEE.std_logic_1164.all;

entity DetectorFlanco is
	port (
		e, clk, reset_n: in std_logic;
		s: out std_logic
	);
end DetectorFlanco;

architecture behavioural of DetectorFlanco is

	type states is (Waiting1, Pulse, Waiting0);
	signal state_current, state_next : states;

begin

	EventHandler : process (clk, reset_n)
	begin
		if not(reset_n) = '1' then
			state_current <= Waiting1;
		elsif clk'event and clk = '1' then
			state_current <= state_next;
		end if;
	end process EventHandler;

	StateHandler : process(state_next, e)
	begin

		state_next <= state_current;
		case state_current is
			when Waiting0 =>
				if e = '0' then
					state_next <= Pulse;
				end if;
			when Pulse =>
				if e = '1' then
					state_next <= Waiting0;
				else
					state_next <= Waiting1;
				end if;
			when Waiting1 =>
				if e = '1' then
					state_next <= Waiting0;
				end if;
			when others =>
				state_next <= state_current;
		end case;
	end process StateHandler;

	OutputManager : process(state_current)
	begin
		s <= '0';
		case state_current is
			when Pulse =>
				s <= '1';
		end case;
	end process OutputManager;

end behavioural;