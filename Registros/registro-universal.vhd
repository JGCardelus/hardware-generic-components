library IEEE;
use IEEE.std_logic_1164.all;

entity RegistroUniversal is
    generic (n : integer := 6);
    port (
        clk, reset_n : in std_logic;
        control : in std_logic_vector(1 downto 0);
        entrada_serie_izq, entrada_serie_dech : in std_logic;
        entrada_paralelo : in std_logic_vector((n-1) downto 0);
        salida_serie_izq, salida_serie_izq : out std_logic;
        salida_paralelo : out std_logic_vector((n-1) downto 0)
    );
end entity RegistroUniversal;

architecture behavioural of RegistroUniversal is
    signal q : std_logic_vector((n-1) downto 0);
begin
    registroUniversalProcess : process(clk, reset_n)
    begin
        if reset_n = '1' then
            q <= (others => '0');
        elsif clk'event and clk = '1' then
            if control = "00" then
                q(0) <= entrada_serie_dech;
                q(n-1 downto 1) <= q(n-2 downto 0);
            elsif control = "10" then
                q <= entrada_paralelo;
            elsif control = "11" then
                q(n-1) <= entrada_serie_izq;
                q(n-2 downto 0) <= q(n-1 downto 1);
            end if;
        end if;
    end process registroUniversalProcess;

    salida_paralelo <= q;
    salida_serie_izq <= q(0);
    salida_serie_dech <= q(n-1);

end behavioural;