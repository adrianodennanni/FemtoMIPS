library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity MEMWB is
port(
	clk : in std_logic;
	stall : in std_logic;
	flush : in std_logic;
	reset : in std_logic;

	I_WREG_ADDR : IN std_logic_vector(4 downto 0);
	I_ALU_DATA : IN std_logic_vector(31 downto 0);
	I_MEM_DATA : IN std_logic_vector(31 downto 0);
	I_WREG_SOURCE : IN std_logic_vector(1 downto 0);
	I_WREG_WRITE : IN std_logic;
	I_ALU_NEG : IN std_logic;
	I_JAL : IN STD_LOGIC;
	I_INST : IN std_logic_vector(31 downto 0);
	I_PC : IN std_logic_vector(31 downto 0);

	O_WREG_ADDR : OUT std_logic_vector(4 downto 0) := (OTHERS => '0');
	O_ALU_DATA : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_MEM_DATA : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_WREG_SOURCE : OUT std_logic_vector(1 downto 0) := (OTHERS => '0');
	O_WREG_WRITE : OUT std_logic := '0';
	O_ALU_NEG : OUT std_logic;
	O_JAL : OUT STD_LOGIC;
	O_INST : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_PC : OUT std_logic_vector(31 downto 0) := (OTHERS => '0')


);
end MEMWB;

architecture MEMWB of MEMWB is
begin

	process(clk,reset)
	begin
		if (reset = '1' or (clk'event and clk = '1' and flush = '1')) then
			O_WREG_ADDR  <= (OTHERS => '0');
			O_ALU_DATA  <= (OTHERS => '0');
			O_MEM_DATA  <= (OTHERS => '0');
			O_WREG_SOURCE <= (OTHERS => '0');
			O_WREG_WRITE  <= '0';
			O_ALU_NEG <= '0';
			O_JAL <= '0';
			O_INST <= (OTHERS => '0');
			O_PC  <= (OTHERS => '0');
		elsif (clk'event and clk = '1' and stall = '0') then
			O_WREG_ADDR <= I_WREG_ADDR;
			O_ALU_DATA <= I_ALU_DATA;
			O_MEM_DATA <= I_MEM_DATA;
			O_WREG_SOURCE <= I_WREG_SOURCE;
			O_WREG_WRITE <= I_WREG_WRITE;
			O_ALU_NEG <= I_ALU_NEG;
			O_JAL <= I_JAL;
			O_INST <= I_INST;
			O_PC <= I_PC;
		end if;
	end process;

end MEMWB;
