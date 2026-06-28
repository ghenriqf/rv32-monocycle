library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        i_a, i_b : in  std_logic_vector(31 downto 0);
        i_ula_op : in  std_logic_vector(3 downto 0);
        o_ula    : out std_logic_vector(31 downto 0);
        o_zero   : out std_logic
    );
end ula;

architecture arch of ula is
    signal w_ula  : std_logic_vector(31 downto 0);
    signal shamt  : integer range 0 to 31;
begin
    shamt <= to_integer(unsigned(i_b(4 downto 0)));

    process(i_a, i_b, i_ula_op, shamt)
    begin
        case i_ula_op is
            when "0000" => -- ADD
                w_ula <= std_logic_vector(signed(i_a) + signed(i_b));

            when "0001" => -- SUB
                w_ula <= std_logic_vector(signed(i_a) - signed(i_b));

            when "0010" => -- AND
                w_ula <= i_a and i_b;

            when "0011" => -- OR
                w_ula <= i_a or i_b;

            when "0100" => -- XOR
                w_ula <= i_a xor i_b;

            when "0101" => -- SLL
                w_ula <= std_logic_vector(shift_left(unsigned(i_a), shamt));

            when "0110" => -- SRL
                w_ula <= std_logic_vector(shift_right(unsigned(i_a), shamt));

            when "0111" => -- SRA
                w_ula <= std_logic_vector(shift_right(signed(i_a), shamt));

            when "1000" => -- SLT
                if signed(i_a) < signed(i_b) then
                    w_ula <= (0 => '1', others => '0');
                else
                    w_ula <= (others => '0');
                end if;

            when "1001" => -- SLTU
                if unsigned(i_a) < unsigned(i_b) then
                    w_ula <= (0 => '1', others => '0');
                else
                    w_ula <= (others => '0');
                end if;

            when others =>
                w_ula <= (others => '0');
        end case;
    end process;

    o_zero <= '1' when w_ula = (w_ula'range => '0') else '0';
    o_ula  <= w_ula;
end arch;