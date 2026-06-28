library ieee;
use ieee.std_logic_1164.all;

entity Control is
    port (
        opcode    : in  std_logic_vector(6 downto 0);
        funct3    : in  std_logic_vector(2 downto 0);
        funct7b5  : in  std_logic;

        reg_write  : out std_logic;
        alu_src    : out std_logic;
        mem_read   : out std_logic;
        mem_write  : out std_logic;
        mem_to_reg : out std_logic;
        branch     : out std_logic;
        jump       : out std_logic;
        lui        : out std_logic;
        auipc      : out std_logic;
        jalr       : out std_logic;
        alu_op     : out std_logic_vector(3 downto 0)
    );
end Control;

architecture rtl of Control is
begin
    process(opcode, funct3, funct7b5)
    begin
        reg_write <= '0'; alu_src    <= '0'; mem_read  <= '0';
        mem_write <= '0'; mem_to_reg <= '0'; branch    <= '0';
        jump      <= '0'; lui        <= '0'; auipc     <= '0';
        jalr      <= '0'; alu_op     <= "0000";

        case opcode is

            when "0110011" => -- R-type
                reg_write <= '1';
                case funct3 is
                    when "000" =>
                        if funct7b5 = '1' then alu_op <= "0001"; -- SUB
                        else                   alu_op <= "0000"; end if; -- ADD
                    when "111" => alu_op <= "0010"; -- AND
                    when "110" => alu_op <= "0011"; -- OR
                    when "100" => alu_op <= "0100"; -- XOR
                    when "001" => alu_op <= "0101"; -- SLL
                    when "101" =>
                        if funct7b5 = '1' then alu_op <= "0111"; -- SRA
                        else                   alu_op <= "0110"; end if; -- SRL
                    when "010" => alu_op <= "1000"; -- SLT
                    when "011" => alu_op <= "1001"; -- SLTU
                    when others => null;
                end case;

            when "0010011" => -- I-type aritmética
                reg_write <= '1'; alu_src <= '1';
                case funct3 is
                    when "000" => alu_op <= "0000"; -- ADDI
                    when "010" => alu_op <= "1000"; -- SLTI
                    when "011" => alu_op <= "1001"; -- SLTIU
                    when "111" => alu_op <= "0010"; -- ANDI
                    when "110" => alu_op <= "0011"; -- ORI
                    when "100" => alu_op <= "0100"; -- XORI
                    when "001" => alu_op <= "0101"; -- SLLI
                    when "101" =>
                        if funct7b5 = '1' then alu_op <= "0111"; -- SRAI
                        else                   alu_op <= "0110"; end if; -- SRLI
                    when others => null;
                end case;

            when "0000011" => -- LW
                reg_write  <= '1'; alu_src    <= '1';
                mem_read   <= '1'; mem_to_reg <= '1';
                alu_op <= "0000";

            when "0100011" => -- SW
                alu_src   <= '1'; mem_write <= '1';
                alu_op <= "0000";

            when "1100011" => -- Branch
                branch <= '1';
                case funct3 is
                    when "000" => alu_op <= "0001"; -- BEQ
                    when "001" => alu_op <= "0001"; -- BNE
                    when "100" => alu_op <= "1000"; -- BLT
                    when "101" => alu_op <= "1000"; -- BGE
                    when "110" => alu_op <= "1001"; -- BLTU
                    when "111" => alu_op <= "1001"; -- BGEU
                    when others => null;
                end case;

            when "0110111" => -- LUI
                reg_write <= '1'; lui <= '1';

            when "0010111" => -- AUIPC
                reg_write <= '1'; auipc <= '1'; alu_op <= "0000";

            when "1101111" => -- JAL
                reg_write <= '1'; jump <= '1';

            when "1100111" => -- JALR
                reg_write <= '1'; jump <= '1'; jalr <= '1';
                alu_src <= '1';   alu_op <= "0000";

            when others => null;
        end case;
    end process;
end rtl;