library IEEE;
use IEEE.std_logic_1164.all;

entity Kit is
    port (
        clk, reset_n : in std_logic;
        lamparas : out std_logic_vector(5 downto 0)
    );
end Kit;

architecture behavioural of Kit is 
    signal seq_started : std_logic := '0';
    signal control : std_logic_vector (1 downto 0) := "00";
    signal entrada_serie_izq, entrada_serie_dech : std_logic;
    signal salida_serie_izq, salida_serie_dech : std_logic := '0';
    signal salida_paralelo : std_logic_vector(5 downto 0);
begin
    rgu1: entity work.RegistroUniversal
        generic map (
            n => 6
        )
        port map(
            clk => clk,
            reset_n => reset_n,

        )

    process (clk, reset_n)
    begin
        if reset_n = '1' then
            control = "00";
            salida_serie_izq <= '1';
        elsif clk'event and clk = '1' then
            if control = "00" and salida_serie_dech = '1' then
                entrada_serie_izq <= salida_serie_dech;
                control = "11";
            elsif control = "11" and salida_serie_dech = '1' then
                salida_serie_dech <= '0';
            elsif control "11" and salida_serie_izq = '1' then
                entrada_serie_dech <= salida_serie_izq;
                control = "00";
            elsif control = "00" and salida_serie_izq = '1' then
                salida_serie_izq <= '0';
            end if;
        end if;
    end process;

    lamparas <= salida

end behavioural;