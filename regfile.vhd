library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile is
    port (
        clk    : in  std_logic;
        we     : in  std_logic;
        rs1    : in  std_logic_vector(4 downto 0);
        rs2    : in  std_logic_vector(4 downto 0);
        rd     : in  std_logic_vector(4 downto 0);
        wdata  : in  std_logic_vector(31 downto 0);
        rdata1 : out std_logic_vector(31 downto 0);
        rdata2 : out std_logic_vector(31 downto 0)
    );
end RegFile;

architecture rtl of RegFile is
    type rf_t is array(0 to 31) of std_logic_vector(31 downto 0);
    signal RF : rf_t := (others => (others => '0'));
begin

    rdata1 <= (others => '0') when rs1 = "00000"
              else RF(to_integer(unsigned(rs1)));
    rdata2 <= (others => '0') when rs2 = "00000"
              else RF(to_integer(unsigned(rs2)));

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' and rd /= "00000" then
                RF(to_integer(unsigned(rd))) <= wdata;
            end if;
        end if;
    end process;

end rtl;