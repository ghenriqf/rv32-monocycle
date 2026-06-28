library IEEE;
use IEEE.std_logic_1164.all;

entity design is
	port(
		i_clk    : in  std_logic;
		i_inst   : in  std_logic_vector(31 downto 0);
		i_ula_op : in  std_logic_vector(3 downto 0);
		i_sel    : in  std_logic;
		o_ula    : out std_logic_vector(31 downto 0);
		o_zero   : out std_logic
	);
end design;

architecture arch of design is
	signal w_mux_alu_out : std_logic_vector(31 downto 0);
	signal w_rs1_data, w_rs2_data, w_ula : std_logic_vector(31 downto 0);
	signal w_imm : std_logic_vector(31 downto 0);
	signal w_wr_ena : std_logic;

	signal reg_write  : std_logic;
	signal alu_src    : std_logic;
	signal mem_read   : std_logic;
	signal mem_write  : std_logic;
	signal mem_to_reg : std_logic;
	signal branch     : std_logic;
	signal jump       : std_logic;
	signal lui        : std_logic;
	signal auipc      : std_logic;
	signal jalr       : std_logic;
	signal alu_op     : std_logic_vector(3 downto 0);

begin
	u_ULA : entity work.ula
	port map(w_rs1_data, w_mux_alu_out, i_ula_op, w_ula, o_zero);

	u_MUX : entity work.mux21
	port map(w_rs2_data, w_imm, i_sel, w_mux_alu_out);

	u_REGBANK : entity work.RegFile
	port map(i_clk, w_wr_ena, i_inst(19 downto 15), i_inst(24 downto 20),
	         i_inst(11 downto 7), w_ula, w_rs1_data, w_rs2_data);

	u_IMMGEN : entity work.ImmGen
	port map(i_inst, w_imm);

	u_CONTROL : entity work.Control
	port map(
		i_inst(6 downto 0),
		i_inst(14 downto 12),
		i_inst(30),

		reg_write,
		alu_src,
		mem_read,
		mem_write,
		mem_to_reg,
		branch,
		jump,
		lui,
		auipc,
		jalr,
		alu_op
	);

	w_wr_ena <= reg_write;
	o_ula <= w_ula;

end arch;