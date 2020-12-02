library ieee;
use ieee.std_logic_1164.all;

entity DetectorSecuencia is
	port(
		reset_n : in std_logic;
		clk : in std_logic;
		p1,p0 : in std_logic;
		s : out std_logic);
end DetectorSecuencia;

architecture behavioral of DetectorSecuencia is

	type t_estados is (Reposo,EP0,EP0P1,EP0P1P1,EP0P1P1P0);
	signal estado_act, estado_sig : t_estados;
	signal entradas : std_logic_vector(1 downto 0); -- para agrupar 2 entradas en un vector
	
	component DetectorFlanco 
		port(
			e : in std_logic;
			clk : in std_logic;
			reset_n : in std_logic;
			s : out std_logic);
	end component; 
	
begin
	
	i_1 : DetectorFlanco
		port map (
			e => p1,
			clk => clk,
			reset_n => reset_n,
			s => entradas(1));
			
	i_2 : DetectorFlanco	
		port map (
			e => p0,
			clk => clk,
			reset_n => reset_n,
			s => entradas(0));
	
	VarEstado : process(clk, reset_n, estado_sig)
	begin
		if reset_n = '0' then
			estado_act <= Reposo;
		elsif clk'event and clk = '1' then
			estado_act <= estado_sig;
		end if;
	end process VarEstado;
	
	
	TransicionEstados : process (estado_act, entradas)
	begin
		estado_sig <= estado_act; -- por defecto
		case estado_act is
			when Reposo =>
				if entradas = "01" then
					estado_sig <= EP0;
				end if;
			when EP0 =>
				if entradas = "10" then
					estado_sig <= EP0P1;
				elsif entradas = "11" then
					estado_sig <= Reposo;
				end if;
			when EP0P1 =>
				if entradas = "10" then
					estado_sig <= EP0P1P1;
				elsif entradas = "01" then
					estado_sig <= EP0; 
				elsif entradas = "11" then
					estado_sig <= Reposo;
				end if;
			when EP0P1P1 =>
				if entradas = "01" then
					estado_sig <= EP0P1P1P0;
				elsif entradas = "10" then
					estado_sig <= Reposo;
				elsif entradas = "11" then
					estado_sig <= Reposo;
				end if;
			when EP0P1P1P0 =>
				if entradas = "01" then
					estado_sig <= EP0;
				elsif entradas = "10" then
					estado_sig <= EP0P1;
				elsif entradas = "11" then
					estado_sig <= Reposo;
				end if;
			when others =>
				estado_sig <= Reposo;
		end case;
	end process;
	
	s <= '1' when estado_act = EP0P1P1P0 else '0';
end behavioral;
				
				
				