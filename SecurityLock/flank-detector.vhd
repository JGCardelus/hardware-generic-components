library IEEE;
use IEEE.std_logic_1164.all;


entity SecurityLock is
	port (
		clk : in std_logic;
		p : in std_logic;
		s : out std_logic
	);
end SecurityLock;

architecture behavioural of SecurityLock is

	-- MACHINE STATES
	type states is (waiting_1, pulse, waiting_0);
	signal state_now, state_next : states;

begin

	StateEventHandler : process(clk, reset, state_next)
	begin
		if clk'event and clk = '1' then -- Flank detector
			state_now <= state_next;
		else
			state_now <= closed;
		end if;
	end process StateEvent;

	StateManager : process(state_now, p)
	begin

	end process StateManager;

	StateOutputs : process (state_now)
	begin
		lock_state <= '0';
		waiting <= '1';
		case state_now is
			when valid =>
				lock_state <= '1';
				waiting <= '0';
			when others =>
				null;
		end case;
	end process StateOutputs;

end behavioural;