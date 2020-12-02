library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplicador5 is
    port (
        a, b: in std_logic_vector(4 downto 0);
        p: out std_logic_vector(9 downto 0)
    );
end Multiplicador5;

architecture structural of Multiplicador5 is
    type inter_product is array (4 to 0) of unsigned(9 downto 0);
    signal inter_products : inter_product;
begin
    inter_product_calculation: for i in 4 to 0 generate
        -- Suffix zeros
        suffix: for j in i to 0 generate
            inter_products(i)(j) <= '0';
        end generate;
        -- Product
        product: for j in i to (i + 4) generate
            inter_products(i)(j) <= a(j-i) and b(i);
        end generate;
        -- Prefix
        prefix: for j in (i + 5) to 9 generate
            inter_products(i)(j) <= '0';
        end generate;
    end generate;

    p <= std_logic_vector((inter_product(0) + inter_product(1)) + (inter_product(2) + inter_product(3)) + inter_product(4))

end structural;