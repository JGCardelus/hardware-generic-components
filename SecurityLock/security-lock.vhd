library IEEE;
use IEEE.std_logic_1164.all;


entity SecurityLock is
	port (
		clk,reset : in std_logic;
		p : in std_logic_vector(1 downto 0);
		lock_state, waiting : out std_logic
	);
end SecurityLock;

architecture behavioural of SecurityLock is

	-- MACHINE STATES
	type states is (closed, seq_1, wait_1, seq_2, wait_2, seq_3, wait_3, seq_4, valid);
	signal state_now, state_next : states;

begin

	StateEventHandler : process(clk, reset, state_next)
	begin
		if clk'event and clk = '1' then -- Flank detector
			state_now <= state_next;
		elsif not(reset) <= '1' then -- Async event
			state_now <= closed;
		else
			state_now <= closed;
		end if;
	end process StateEvent;

	StateManager : process(state_now, p)
	begin
		state_next <= state_now; -- Keep the same by default
		case state_now is
			when closed =>
				if p = "01" then
					state_next <= seq_1;
				end if;
			when seq_1 =>
				if p = "11" then
					state_next <= wait_1;
				elsif p = "00" then
					state_next <= closed;
				elsif p = "10" then
					state_next <= seq_2;
				end if;
			when wait_1 =>
				if p = "10" or p = "00" then
					state_next <= closed;
				elsif p = "10" then
					state_next <= seq_2;
				end if;
			when seq_2 =>
				if p = "11" then
					state_next <= wait_2;
				elsif p = "01" or p = "00" then
					state_next <= closed;
				end if;
			when wait_2 =>
				if p = "10" then
					state_next <= seq_3;
				elsif p = "01" or p = "00" then
					state_next <= closed;
				end if;
			when seq_3 => 
				if p = "11" then
					state_next <= wait_3;
				elsif p = "01" then
					state_next <= seq_4;
				elsif p = 00 then
					state_next <= closed;
				end if;
			when wait_3 =>
				if p = "10" then
					state_next <= seq_2;
				elsif p = "11" then
					state_next <= valid;
				elsif p = "00" then
					state_next <= closed;
				end if;
			when valid => 
				if p = "10" then
					state_next <= seq_2;
				elsif p = "01" or p = "00" then
					state_next <= closed;
				end if;
 		end case;
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