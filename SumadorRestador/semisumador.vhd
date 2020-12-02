library IEEE;
use IEEE.std_logic_1164.all;

entity Semisumador is
    port (
        a,b,c_in : in std_logic;
        s,c_out : out std_logic
    );
end Semisumador;

architecture structural of Semisumador is
    signal a_xor_b : std_logic;
begin
    a_xor_b <= (a XOR b);
    s <= c_in XOR a_xor_b;
    c_out <= (c_in and a_xor_b) OR (a and b);
end structural;