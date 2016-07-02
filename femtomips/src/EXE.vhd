library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity EXE is
port(
	clk : in std_logic;
	reset : in std_logic;

	FORWARD_MEM : IN STD_LOGIC_VECTOR(31 downto 0);
	FORWARD_WB : IN STD_LOGIC_VECTOR(31 downto 0);
	FORWARD_RS_DECIDE : IN STD_LOGIC_VECTOR(1 downto 0);
	FORWARD_RT_DECIDE : IN STD_LOGIC_VECTOR(1 downto 0);

	BADDR_SOURCE : IN STD_LOGIC;
	GPR_RS : IN STD_LOGIC_VECTOR(31 downto 0);
	GPR_RT : IN STD_LOGIC_VECTOR(31 downto 0);
	OPERA_SOURCE : IN STD_LOGIC_VECTOR(1 downto 0);
	OPERB_SOURCE : IN STD_LOGIC;
	ALU_OP : IN STD_LOGIC_VECTOR(2 downto 0);
	INST : IN STD_LOGIC_VECTOR(31 downto 0);
	PC : IN STD_LOGIC_VECTOR(31 downto 0);

	ALU_RES : OUT STD_LOGIC_VECTOR(31 downto 0);
	ALU_NEG : OUT STD_LOGIC;
	ALU_ZERO : OUT STD_LOGIC;
	BADDR_DATA : OUT STD_LOGIC_VECTOR(31 downto 0);
	ALU_OVF : OUT STD_LOGIC

);
end EXE;

architecture EXE of EXE is


	component ULA
	port(
	OpA : in STD_LOGIC_VECTOR(31 downto 0);
	OpB : in STD_LOGIC_VECTOR(31 downto 0);
	Oper : in STD_LOGIC_VECTOR(2 downto 0);
	ZER : out STD_LOGIC;
	NEG : out STD_LOGIC;
	OVF : out STD_LOGIC;
	Res : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: ULA use entity work.ULA(ULA);


	component Mux4x1
	port(
		I0 : in STD_LOGIC_VECTOR(31 downto 0);
		I1 : in STD_LOGIC_VECTOR(31 downto 0);
		I2 : in STD_LOGIC_VECTOR(31 downto 0);
		I3 : in STD_LOGIC_VECTOR(31 downto 0);
		Sel0 : in STD_LOGIC;
		Sel1 : in STD_LOGIC;
		O : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: Mux4x1 use entity work.Mux4x1(Mux4x1);


	component Mux2x1
	port(
		I0 : in STD_LOGIC_VECTOR(31 downto 0);
		I1 : in STD_LOGIC_VECTOR(31 downto 0);
		Sel : in STD_LOGIC;
		O : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: Mux2x1 use entity work.Mux2x1(Mux2x1);


	component Somador
	port(
		in1 : in STD_LOGIC_VECTOR(31 downto 0);
		in2 : in STD_LOGIC_VECTOR(31 downto 0);
		sai : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: Somador use entity work.Somador(Somador);



	signal IMED_EX, IMED_DESL, SHAMT_EX, ENDER_DESL : std_logic_vector(31 downto 0);
	signal BRANCH_IMED : std_logic_vector(31 downto 0);

	SIGNAL ALU_RS, ALU_RT, OPERA_DATA, OPERB_DATA : STD_LOGIC_VECTOR(31 downto 0);

begin


	IMED_EX <=  "0000000000000000" & Inst(15 downto 0);
	IMED_DESL <= "00000000000000" & IMED_EX(15 downto 0) & "00";
	SHAMT_EX <= "000000000000000000000000000" & Inst(10 downto 6);
	ENDER_DESL <= PC(31 downto 28) & Inst(25 downto 0) & "00";


	ForwRS : Mux4x1
	port map(
		I0 => GPR_RS,
		I1 => FORWARD_MEM,
		I2 => FORWARD_WB,
		I3 => (others => '0'),
		Sel0 => FORWARD_RS_DECIDE(0),
		Sel1 => FORWARD_RS_DECIDE(1),
		O => ALU_RS
	);

	ForwRT : Mux4x1
	port map(
		I0 => GPR_RT,
		I1 => FORWARD_MEM,
		I2 => FORWARD_WB,
		I3 => (others => '0'),
		Sel0 => FORWARD_RT_DECIDE(0),
		Sel1 => FORWARD_RT_DECIDE(1),
		O => ALU_RT
	);

	MOpa : Mux4x1
	port map(
		I0 => ALU_RS,
		I1 => IMED_EX,
		I2 => SHAMT_EX,
		I3 => (others => '0'),
		Sel0 => OPERA_SOURCE(0),
		Sel1 => OPERA_SOURCE(1),
		O => OPERA_DATA
	);

	MOpb : Mux2x1
	port map(
		I0 => ALU_RT,
		I1 => IMED_EX,
		Sel => OPERB_SOURCE,
		O => OPERB_DATA
	);

	UlaExe : ULA
	port map(
		OpA => OPERA_DATA,
		OpB => OPERA_DATA,
		Oper => ALU_OP,
		ZER => ALU_ZERO,
		NEG => ALU_NEG,
		OVF => ALU_OVF,
		Res => ALU_RES
	);

	BranchMux : Mux2x1
	port map(
		I0 => BRANCH_IMED,
		I1 => ENDER_DESL,
		Sel => BADDR_SOURCE,
		O => BADDR_DATA
	);

	SomadorExe : Somador
	port map(
		in1 => PC,
		in2 => IMED_DESL,
		sai => BRANCH_IMED
	);

end EXE;
