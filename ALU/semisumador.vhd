library IEEE;
use IEEE.std_logic_1164.all;

entity Semisumador is
    port (
        a,b,acr : in std_logic;
        s,ov : out std_logic
    );
end Semisumador;

architecture structural of Semisumador is
    signal a_xor_b : std_logic;
begin
    a_xor_b <= (a XOR b);
    s <= acr XOR a_xor_b;
    ov <= (acr and a_xor_b) OR (a and b);
end structural;