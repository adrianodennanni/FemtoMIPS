library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity IDE is
port(
	clk : in std_logic;
	INST : in std_logic_vector(31 downto 0);
	ALU_OVF : IN std_logic;

	WREG_WRITE_WB : in std_logic;
	WREG_ADDR_WB : in std_logic_vector(4 downto 0);
	WREG_DATA : in std_logic_vector(31 downto 0);

	BADDR_SOURCE : out std_logic := '0';
	GPR_RS : out std_logic_vector(31 downto 0) := (others => '0');
	GPR_RT : out std_logic_vector(31 downto 0) := (others => '0');
	OPERA_SOURCE  : out std_logic_vector(1 downto 0) := (others => '0');
	OPERB_SOURCE : out std_logic := '0';
	BDECIDE_SOURCE : out std_logic_vector(1 downto 0) := (others => '0');
	MEM_WRITE : out std_logic := '0';
	WREG_ADDR : out std_logic_vector(4 downto 0) := (others => '0');
	ALU_OP : out std_logic_vector(2 downto 0) := (others => '0');
	MEM_READ : out std_logic := '0';
	WREG_SOURCE : out std_logic_vector(1 downto 0) := (others => '0');
	WREG_WRITE : out std_logic := '0';

	INTERRUPT_SIGNAL : OUT STD_LOGIC;
	INTERRUPT_SOURCE : OUT STD_LOGIC;

	R0, R1, R2, R3, R4, R5, R6, R7 : OUT std_logic_vector(31 downto 0);
	JAL : OUT STD_LOGIC

);
end IDE;

architecture IDE of IDE is

	-- Component declaration of the "GPR(GPR)" unit defined in
	-- file: "./../src/GPR.vhd"
component GPR
	port(
	clk : in STD_LOGIC;
	we : in STD_LOGIC;
	WriteData : in STD_LOGIC_VECTOR(31 downto 0);
	WriteEnd : in STD_LOGIC_VECTOR(4 downto 0);
	Rs : in STD_LOGIC_VECTOR(4 downto 0);
	Rt : in STD_LOGIC_VECTOR(4 downto 0);
	GPRRs : out STD_LOGIC_VECTOR(31 downto 0);
	GPRRt : out STD_LOGIC_VECTOR(31 downto 0);
	R0 : out STD_LOGIC_VECTOR(31 downto 0);
	R1 : out STD_LOGIC_VECTOR(31 downto 0);
	R2 : out STD_LOGIC_VECTOR(31 downto 0);
	R3 : out STD_LOGIC_VECTOR(31 downto 0);
	R4 : out STD_LOGIC_VECTOR(31 downto 0);
	R5 : out STD_LOGIC_VECTOR(31 downto 0);
	R6 : out STD_LOGIC_VECTOR(31 downto 0);
	R7 : out STD_LOGIC_VECTOR(31 downto 0));
end component;
for all: GPR use entity work.GPR(GPR);

-- Component declaration of the "Controle(Controle)" unit defined in
-- file: "./../src/Controle.vhd"
component Controle
port(
	Inst : in STD_LOGIC_VECTOR(31 downto 0);
	Overflow : in STD_LOGIC;
	BADDR_SOURCE : out STD_LOGIC;
	OPERA_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
	OPERB_SOURCE : out STD_LOGIC;
	BDECIDE_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
	MEM_WRITE : out STD_LOGIC;
	ALU_OP : out STD_LOGIC_VECTOR(2 downto 0);
	MEM_READ : out STD_LOGIC;
	WREG_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
	WREG_WRITE : out STD_LOGIC;
	WREG_ADDR_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
	JAL : out std_logic;
	INTERRUPT_SIGNAL : out STD_LOGIC;
	INTERRUPT_SOURCE : out STD_LOGIC);
end component;
for all: Controle use entity work.Controle(Controle);

-- Component declaration of the "Mux4x1_5b(Mux4x1_5b)" unit defined in
-- file: "./../src/Mux4x1_5b.vhd"
component Mux4x1_5b
port(
	I0 : in STD_LOGIC_VECTOR(4 downto 0);
	I1 : in STD_LOGIC_VECTOR(4 downto 0);
	I2 : in STD_LOGIC_VECTOR(4 downto 0);
	I3 : in STD_LOGIC_VECTOR(4 downto 0);
	Sel0 : in STD_LOGIC;
	Sel1 : in STD_LOGIC;
	O : out STD_LOGIC_VECTOR(4 downto 0));
end component;
for all: Mux4x1_5b use entity work.Mux4x1_5b(Mux4x1_5b);


signal WREG_ADDR_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
signal rs, rt, rd : STD_LOGIC_VECTOR(4 downto 0);

begin

	rs <= INST(25 downto 21);
	rt <= INST(20 downto 16);
	rd <= INST(15 downto 11);

	REGS : GPR
	port map(
		clk => clk,
		we => WREG_WRITE_WB,
		WriteData => WREG_DATA,
		WriteEnd => WREG_ADDR_WB,
		Rs => rs,
		Rt => rt,
		GPRRs => GPR_RS,
		GPRRt => GPR_RT,
		R0 => R0,
		R1 => R1,
		R2 => R2,
		R3 => R3,
		R4 => R4,
		R5 => R5,
		R6 => R6,
		R7 => R7
	);

	CTRL : Controle
	port map(
		Inst => INST,
		Overflow => ALU_OVF,
		BADDR_SOURCE => BADDR_SOURCE,
		OPERA_SOURCE => OPERA_SOURCE,
		OPERB_SOURCE => OPERB_SOURCE,
		BDECIDE_SOURCE => BDECIDE_SOURCE,
		MEM_WRITE => MEM_WRITE,
		ALU_OP => ALU_OP,
		MEM_READ => MEM_READ,
		WREG_SOURCE => WREG_SOURCE,
		WREG_WRITE => WREG_WRITE,
		WREG_ADDR_SOURCE => WREG_ADDR_SOURCE,
		JAL => JAL,
		INTERRUPT_SIGNAL => INTERRUPT_SIGNAL,
		INTERRUPT_SOURCE => INTERRUPT_SOURCE
	);

	WAS : Mux4x1_5b
	port map(
		I0 =>  rd,
		I1 =>  rt,
		I2 => "00111",
		I3 => "00000",
		Sel0 => WREG_ADDR_SOURCE(0),
		Sel1 => WREG_ADDR_SOURCE(1),
		O => WREG_ADDR
	);

end IDE;
