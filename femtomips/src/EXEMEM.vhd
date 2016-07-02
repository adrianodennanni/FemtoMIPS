library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity EXEMEM is
port(
	clk : in std_logic;
	stall : in std_logic;
	flush : in std_logic;
	reset : in std_logic;

	I_BADDR_DATA : IN std_logic_vector(31 downto 0);
	I_ALU_ZERO : IN std_logic;
	I_ALU_NEG : IN std_logic;
	I_BDECIDE_SOURCE : IN std_logic_vector(1 downto 0);
	I_MEM_WRITE : IN std_logic;
	I_WREG_ADDR : IN std_logic_vector(4 downto 0);
	I_ALU_RES : IN std_logic_vector(31 downto 0);
	I_MEM_READ : IN std_logic;
	I_WREG_SOURCE : IN std_logic_vector(1 downto 0);
	I_WREG_WRITE : IN std_logic;
	I_ALU_OVF : IN std_logic;
	I_GPR_RT : IN std_logic_vector(31 downto 0);
	I_JAL : in std_logic;
	I_INST : IN std_logic_vector(31 downto 0);
	I_PC : IN std_logic_vector(31 downto 0);

	O_BADDR_DATA : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_ALU_ZERO : OUT std_logic := '0';
	O_ALU_NEG : OUT std_logic := '0';
	O_BDECIDE_SOURCE : OUT std_logic_vector(1 downto 0) := (OTHERS => '0');
	O_MEM_WRITE : OUT std_logic := '0';
	O_WREG_ADDR : OUT std_logic_vector(4 downto 0) := (OTHERS => '0');
	O_ALU_RES : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_MEM_READ : OUT std_logic := '0';
	O_WREG_SOURCE : OUT std_logic_vector(1 downto 0) := (OTHERS => '0');
	O_WREG_WRITE : OUT std_logic := '0';
	O_ALU_OVF : OUT std_logic := '0';
	O_GPR_RT : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_JAL : out std_logic;
	O_INST : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_PC : OUT std_logic_vector(31 downto 0) := (OTHERS => '0')

);
end EXEMEM;

architecture EXEMEM of EXEMEM is
begin

	process(clk,reset)
	begin
		if (reset = '1' or (clk'event and clk = '1' and flush = '1')) then
			O_BADDR_DATA  <= (OTHERS => '0');
			O_ALU_ZERO  <= '0';
			O_ALU_NEG  <= '0';
			O_BDECIDE_SOURCE <= (OTHERS => '0');
			O_MEM_WRITE  <= '0';
			O_WREG_ADDR <= (OTHERS => '0');
			O_ALU_RES  <= (OTHERS => '0');
			O_MEM_READ  <= '0';
			O_WREG_SOURCE <= (OTHERS => '0');
			O_WREG_WRITE  <= '0';
			O_ALU_OVF <= '0';
			O_GPR_RT <= (OTHERS => '0');
			O_JAL <= '0';
			O_INST  <= (OTHERS => '0');
			O_PC  <= (OTHERS => '0');
		elsif (clk'event and clk = '1' and stall = '0') then
			O_BADDR_DATA  <= I_BADDR_DATA;
			O_ALU_ZERO  <=	I_ALU_ZERO;
			O_ALU_NEG  <= I_ALU_NEG;
			O_BDECIDE_SOURCE <= I_BDECIDE_SOURCE;
			O_MEM_WRITE  <= I_MEM_WRITE;
			O_ALU_OVF <= I_ALU_OVF;
			O_GPR_RT <= I_GPR_RT;
			O_WREG_ADDR <= I_WREG_ADDR;
			O_ALU_RES  <= I_ALU_RES;
			O_MEM_READ  <= 	I_MEM_READ ;
			O_WREG_SOURCE <= 	I_WREG_SOURCE;
			O_WREG_WRITE  <= I_WREG_WRITE;
			O_JAL <= I_JAL;
			O_INST  <= I_INST;
			O_PC  <= I_PC;
		end if;
	end process;

end EXEMEM;
