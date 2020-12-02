library IEEE;
use IEEE.std_logic_1164.all;

entity SumadorRestador is
    generic (n : integer := 5);
    port (
        a,b : in std_logic_vector((n-1) downto 0); -- if we want 4 bits, n-1
        sr : in std_logic;
        ov : out std_logic;
        s : out std_logic_vector((n-1) downto 0)
    );
end entity;

architecture structural of SumadorRestador is
    signal c_i : std_logic_vector(n downto 0);
    signal b_xor_sr : std_logic_vector((n-1) downto 0);

begin
    c_i(0) <= sr;
    sumadorRestadorBloque : for i in 0 to (n-1) generate
        b_xor_sr(i) <= b(i) XOR sr;
        semisumador : entity work.Semisumador
            port map (
                a => a(i),
                b => b_xor_sr(i),
                acr => c_i(i),
                ov => c_i(i+1),
                s => s(i) 
            );
    end generate;
    ov <= c_i(n) XOR c_i(n-1);
end structural;