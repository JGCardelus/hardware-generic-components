library IEEE;
use IEEE.std_logic_1164.all;

-- Activate valid if a sequence is correct

entity SequenceDetector is
	port (
		clk, reset_n, p0, p1 : in std_logic;
		s : out std_logic
	);
end SequenceDetector;

architecture behavioural of SequenceDetector is
	type states is (Closed, Sq0, Sq0Sq1, Sq0Sq1Sq1, ValidSequence);
	signal state_current, state_next : states;

	signal in_vector : std_logic_vector(1 downto 0);

	component EdgeDetector 
		port(
			p : in std_logic;
			clk : in std_logic;
			reset_n : in std_logic;
			s : out std_logic);
	end component; 

begin

	i_1 : EdgeDetector
		port map (
			p => p0,
			clk => clk,
			reset_n => reset_n,
			s => in_vector(1));
			
	i_2 : EdgeDetector	
		port map (
			p => p1,
			clk => clk,
			reset_n => reset_n,
			s => in_vector(0));


	EventHandler : process(clk, reset_n, state_next)
	begin
		if not(reset_n) = '1' then
			state_current <= Closed;
		elsif clk'event and clk = '1' then
			state_current <= state_next;
		end if;
	end process EventHandler;

	StateManager : process(state_current, in_vector)
	begin
		-- By default leave state as is
		state_next <= state_current;
		case state_current is
			when Closed =>
				if in_vector = "10" then
					state_next <= Sq0;
				end if;
			when Sq0 =>
				if in_vector = "01" then
					state_next <= Sq0Sq1;
				elsif in_vector = "11" then
					state_next <= Closed;
				end if;
			when Sq0Sq1 =>
				if in_vector = "01" then
					state_next <= Sq0Sq1Sq1;
				elsif in_vector = "10" then
					state_next <= Sq0;	
				elsif in_vector = "11" then
					state_next <= Closed;
				end if;
			when Sq0Sq1Sq1 =>
				if in_vector = "10" then
					state_next <= ValidSequence;
				elsif in_vector = "11" or in_vector = "01" then
					state_next <= Closed;
				end if;
			when ValidSequence =>
				if in_vector = "10" then
					state_next <= Sq0;
				elsif in_vector = "01" then
					state_next <= Sq0Sq1;
				elsif in_vector = "11" then
					state_next <= Closed;
				end if;
			when others =>
				state_next <= Closed;
		end case;
	end process StateManager;

	s <= '1' when state_current = ValidSequence else '0';

end behavioural;