library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity IDEXE is
port(
	clk : in std_logic;
	stall : in std_logic;
	flush : in std_logic;
	reset : in std_logic;

	I_BADDR_SOURCE : IN std_logic;
	I_GPR_RS : IN std_logic_vector(31 downto 0);
	I_GPR_RT : IN std_logic_vector(31 downto 0);
	I_OPERA_SOURCE  : IN std_logic_vector(1 downto 0);
	I_OPERB_SOURCE : IN std_logic;
	I_BDECIDE_SOURCE : IN std_logic_vector(1 downto 0);
	I_MEM_WRITE : IN std_logic;
	I_WREG_ADDR : IN std_logic_vector(4 downto 0);
	I_ALU_OP : IN std_logic_vector(2 downto 0);
	I_MEM_READ : IN std_logic;
	I_WREG_SOURCE : IN std_logic_vector(1 downto 0);
	I_WREG_WRITE : IN std_logic;
	I_JAL : IN std_logic;
	I_INST : IN std_logic_vector(31 downto 0);
	I_PC : IN std_logic_vector(31 downto 0);

	O_BADDR_SOURCE : out std_logic := '0';
	O_GPR_RS : out std_logic_vector(31 downto 0) := (others => '0');
	O_GPR_RT : out std_logic_vector(31 downto 0) := (others => '0');
	O_OPERA_SOURCE  : out std_logic_vector(1 downto 0) := (others => '0');
	O_OPERB_SOURCE : out std_logic := '0';
	O_BDECIDE_SOURCE : out std_logic_vector(1 downto 0) := (others => '0');
	O_MEM_WRITE : out std_logic := '0';
	O_WREG_ADDR : out std_logic_vector(4 downto 0) := (others => '0');
	O_ALU_OP : out std_logic_vector(2 downto 0) := (others => '0');
	O_MEM_READ : out std_logic := '0';
	O_WREG_SOURCE : out std_logic_vector(1 downto 0) := (others => '0');
	O_WREG_WRITE : out std_logic := '0';
	O_JAL : OUT std_logic;
	O_INST : out std_logic_vector(31 downto 0) := (others => '0');
	O_PC : out std_logic_vector(31 downto 0) := (others => '0')

);
end IDEXE;

architecture IDEXE of IDEXE is
begin

	process(clk,reset)
	begin
		if (reset = '1' or (clk'event and clk = '1' and flush = '1' )) then
			O_BADDR_SOURCE  <= '0';
			O_GPR_RS <= (others => '0');
			O_GPR_RT <=  (others => '0');
			O_OPERA_SOURCE   <= (others => '0');
			O_OPERB_SOURCE  <= '0';
			O_BDECIDE_SOURCE  <= (others => '0');
			O_MEM_WRITE  <= '0';
			O_WREG_ADDR  <= (others => '0');
			O_ALU_OP  <= (others => '0');
			O_MEM_READ <= '0';
			O_WREG_SOURCE <= (others => '0');
			O_WREG_WRITE  <= '0';
			O_JAL <= '0';
			O_INST <= (others => '0');
			O_PC  <= (others => '0');
		elsif (clk'event and clk = '1' and stall = '0') then
			O_BADDR_SOURCE <= I_BADDR_SOURCE;
			O_GPR_RS <= I_GPR_RS;
			O_GPR_RT <= I_GPR_RT;
			O_OPERA_SOURCE  <= I_OPERA_SOURCE;
			O_OPERB_SOURCE <= I_OPERB_SOURCE ;
			O_BDECIDE_SOURCE <= I_BDECIDE_SOURCE;
			O_MEM_WRITE <= I_MEM_WRITE;
			O_WREG_ADDR <= I_WREG_ADDR;
			O_ALU_OP <= I_ALU_OP;
			O_MEM_READ <= I_MEM_READ;
			O_WREG_SOURCE <= I_WREG_SOURCE;
			O_WREG_WRITE <= I_WREG_WRITE;
			O_JAL <= I_JAL;
			O_INST <= I_INST;
			O_PC <= I_PC;
		end if;
	end process;

end IDEXE;
