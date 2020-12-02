library IEEE;
use IEEE.std_logic_1164.all;

entity ControlUnit is
	port (
		sel : in std_logic_vector(2 downto 0);
		sel_out : out std_logic_vector(1 downto 0);
		sel_ov_origin : out std_logic;
		sr : out std_logic;
		sel_use_b : out std_logic;
		sel_log : out std_logic_vector(1 downto 0)
	);
end ControlUnit;

architecture behavioural of ControlUnit is

begin
	-- Define sel_out
	sel_out(0) <= ((not sel(0)) and sel(2)) or (sel(2) and (not sel(1)));
	sel_out(1) <= sel(2) and sel(1) and sel(0);
	-- Define sel_ov_origin
	sel_ov_origin <= sel(2) and sel(1) and sel(0);
	-- Define sr
	sr <= sel(2) and sel(0);
	-- Define sel_use_b
	sel_use_b <= sel(2) and (not sel(1));
	-- Define sel_log
	sel_log <= sel(1 downto 0);
end behavioural;