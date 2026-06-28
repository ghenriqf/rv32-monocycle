library ieee;
use ieee.std_logic_1164.all;

entity ImmGen is
    port (
        instr : in  std_logic_vector(31 downto 0);
        imm   : out std_logic_vector(31 downto 0)
    );
end ImmGen;

architecture rtl of ImmGen is
begin
    process(instr)
        variable op : std_logic_vector(6 downto 0);
    begin
        op := instr(6 downto 0);
        case op is

            when "0010011" | "0000011" | "1100111" => -- I-type
                imm <= (31 downto 12 => instr(31)) & instr(31 downto 20);

            when "0100011" => -- S-type
                imm <= (31 downto 12 => instr(31)) &
                       instr(31 downto 25) & instr(11 downto 7);

            when "1100011" => -- B-type
                imm <= (31 downto 13 => instr(31)) &
                       instr(31) & instr(7) &
                       instr(30 downto 25) & instr(11 downto 8) & '0';

            when "0110111" | "0010111" => -- U-type
                imm <= instr(31 downto 12) & (11 downto 0 => '0');

            when "1101111" => -- J-type
                imm <= (31 downto 21 => instr(31)) &
                       instr(31) & instr(19 downto 12) &
                       instr(20) & instr(30 downto 21) & '0';

            when others =>
                imm <= (others => '0');
        end case;
    end process;
end rtl;