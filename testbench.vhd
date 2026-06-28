library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture arch of testbench is
	signal STOP  : BOOLEAN;
	constant PERIOD: TIME := 10 NS;
	signal w_CLK : std_logic := '0';

	signal w_inst   : std_logic_vector(31 downto 0);
	signal w_ula_op : std_logic_vector(3 downto 0);
	signal w_sel    : std_logic;
	signal w_ula    : std_logic_vector(31 downto 0);
	signal w_zero   : std_logic;

begin

	DUT: entity work.design
	port map(w_clk, w_inst, w_ula_op, w_sel, w_ula, w_zero);

	u_CLK_GEN: process
	begin
		while not STOP loop
			w_CLK <= '0';
			wait for PERIOD/2;
			w_CLK <= '1';
			wait for PERIOD/2;
		end loop;
		wait;
	end process u_CLK_GEN;

	process
	begin
		STOP <= FALSE;

		w_inst   <= "00000000011000000000001010010011"; -- ADDI x5, x0, 6
		w_ula_op <= "0000";
		w_sel    <= '1';
		wait for PERIOD;

		w_inst   <= "00000000010000000000001100010011"; -- ADDI x6, x0, 4
		w_ula_op <= "0000";
		w_sel    <= '1';
		wait for PERIOD;

		w_inst   <= "00000000011000101000001110110011"; -- ADD x7, x5, x6
		w_ula_op <= "0000";
		w_sel    <= '0';
		wait for PERIOD;

		STOP <= TRUE;
		wait;
	end process;

end arch;