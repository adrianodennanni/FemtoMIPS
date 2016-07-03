library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
entity proc is
port(
	reset : in std_logic

);
end proc;

architecture proc of proc is

		-- Component declaration of the "CacheD(CacheD)" unit defined in
	-- file: "./../src/CacheD.vhd"
	component CacheD
	port(
		Clock : in STD_LOGIC;
		enable : in STD_LOGIC;
		readD : in STD_LOGIC;
		writeD : in STD_LOGIC;
		ender : in STD_LOGIC_VECTOR(31 downto 0);
		writeDado : in STD_LOGIC_VECTOR(31 downto 0);
		dado : out STD_LOGIC_VECTOR(31 downto 0);
		CacheD_MISS : out STD_LOGIC;
		dumpMemory : in STD_LOGIC;
		MAIN_DATA : in STD_LOGIC_VECTOR(127 downto 0);
		MAIN_RW : out STD_LOGIC;
		MAIN_END : out STD_LOGIC_VECTOR(31 downto 0);
		ENABLE_I : out STD_LOGIC;
		MAIN_PRONTO : in STD_LOGIC;
		BUFFER_BUSY : in std_logic;

		BUFFER_END : out std_logic_vector(31 DOWNTO 0);
		BUFFER_DADOS : out std_logic_vector(31 DOWNTO 0);
		BUFFER_PEDIDO : out std_logic
		);
	end component;
	for all: CacheD use entity work.CacheD(CacheDI);

	-- Cache responsável pelo Buffer de escrita
	component CacheBuffer
	port(
		Clock : in STD_LOGIC;
		ender_in : in STD_LOGIC_VECTOR(31 downto 0);
		dados_in : in STD_LOGIC_VECTOR(31 downto 0);
		pedido_in : in STD_LOGIC;
		ready_in : in STD_LOGIC;

		busy : out STD_LOGIC;
		pedido_out : out STD_LOGIC;
		dados_out : out STD_LOGIC_VECTOR(127 downto 0);
		ender_out : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: CacheBuffer use entity work.CacheBuffer(CacheBuffer);

	-- Component declaration of the "ForwardingUnit(ForwardingUnit)" unit defined in
	-- file: "./../src/ForwardingUnit.vhd"
	component ForwardingUnit
	port(
		MEM_WREG_ADDR : in STD_LOGIC_VECTOR(4 downto 0);
		WB_WREG_ADDR : in STD_LOGIC_VECTOR(4 downto 0);
		MEM_WREG_WRITE : in STD_LOGIC;
		WB_WREG_WRITE : in STD_LOGIC;
		EXE_RS : in STD_LOGIC_VECTOR(4 downto 0);
		EXE_RT : in STD_LOGIC_VECTOR(4 downto 0);
		FORWARD_RS_DECIDE : out STD_LOGIC_VECTOR(1 downto 0);
		FORWARD_RT_DECIDE : out STD_LOGIC_VECTOR(1 downto 0));
	end component;
	for all: ForwardingUnit use entity work.ForwardingUnit(ForwardingUnit);

	SIGNAL FORWARD_RS_DECIDE, FORWARD_RT_DECIDE : STD_LOGIC_VECTOR(1 downto 0);

	-- Component declaration of the "HazardUnit(HazardUnit)" unit defined in
	-- file: "./../src/HazardUnit.vhd"
	component HazardUnit
	port(
		INTERRUPT_SIGNAL : in STD_LOGIC;
		INTERRUPT_SOURCE : in STD_LOGIC;
		BDECIDE_DATA : in STD_LOGIC;
		CACHEI_MISS : in STD_LOGIC;
		CACHED_MISS : in STD_LOGIC;
		EXE_MEM_READ : in STD_LOGIC;
		IDE_INST : in STD_LOGIC_VECTOR(31 downto 0);
		EXE_INST : in STD_LOGIC_VECTOR(31 downto 0);
		FLUSH_IFID : out STD_LOGIC;
		FLUSH_IDEXE : out STD_LOGIC;
		FLUSH_EXEMEM : out STD_LOGIC;
		FLUSH_MEMWB : out STD_LOGIC;
		STALL_IFID : out STD_LOGIC;
		STALL_IDEXE : out STD_LOGIC;
		STALL_EXEMEM : out STD_LOGIC;
		STALL_MEMWB : out STD_LOGIC;
		STALL_PC : out STD_LOGIC);
	end component;
	for all: HazardUnit use entity work.HazardUnit(HazardUnit);

	SIGNAL FLUSH_IFID : STD_LOGIC;
	SIGNAL FLUSH_IDEXE : STD_LOGIC;
	SIGNAL FLUSH_EXEMEM : STD_LOGIC;
	SIGNAL FLUSH_MEMWB : STD_LOGIC;
	SIGNAL STALL_IFID : STD_LOGIC;
	SIGNAL STALL_IDEXE : STD_LOGIC;
	SIGNAL STALL_EXEMEM : STD_LOGIC;
	SIGNAL STALL_MEMWB : STD_LOGIC;
	SIGNAL STALL_PC : STD_LOGIC;



	signal IFE_PC_FEED, IFE_PC_FEEDA, IFE_PC_DATA, PC_INCR : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IFE_INST : STD_LOGIC_VECTOR(31 downto 0);

  component IFID
  port(
    clk : in STD_LOGIC;
    stall : in STD_LOGIC;
    flush : in STD_LOGIC;
    reset : in STD_LOGIC;
    I_INST : in STD_LOGIC_VECTOR(31 downto 0);
    I_PC : in STD_LOGIC_VECTOR(31 downto 0);
    O_INST : out STD_LOGIC_VECTOR(31 downto 0);
    O_PC : out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  for all: IFID use entity work.IFID(IFID);

	SIGNAL IDE_PC : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_INST : STD_LOGIC_VECTOR(31 downto 0);


	SIGNAL IDE_BADDR_SOURCE : STD_LOGIC;
	SIGNAL IDE_GPR_RS : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_GPR_RT : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_OPERA_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL IDE_OPERB_SOURCE : STD_LOGIC;
	SIGNAL IDE_BDECIDE_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL IDE_MEM_WRITE : STD_LOGIC;
	SIGNAL IDE_WREG_ADDR : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL IDE_ALU_OP : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL IDE_MEM_READ : STD_LOGIC;
	SIGNAL IDE_WREG_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL IDE_WREG_WRITE : STD_LOGIC;
	SIGNAL IDE_R0 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_R1 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_R2 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_R3 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_R4 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_R5 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_R6 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_R7 : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL IDE_JAL : STD_LOGIC;
	signal IDE_WREG_ADDR_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	signal IDE_rs, IDE_rt, IDE_rd : STD_LOGIC_VECTOR(4 downto 0);


	component IDEXE
	port(
		clk : in STD_LOGIC;
		stall : in STD_LOGIC;
		flush : in STD_LOGIC;
		reset : in STD_LOGIC;
		I_BADDR_SOURCE : in STD_LOGIC;
		I_GPR_RS : in STD_LOGIC_VECTOR(31 downto 0);
		I_GPR_RT : in STD_LOGIC_VECTOR(31 downto 0);
		I_OPERA_SOURCE : in STD_LOGIC_VECTOR(1 downto 0);
		I_OPERB_SOURCE : in STD_LOGIC;
		I_BDECIDE_SOURCE : in STD_LOGIC_VECTOR(1 downto 0);
		I_MEM_WRITE : in STD_LOGIC;
		I_WREG_ADDR : in STD_LOGIC_VECTOR(4 downto 0);
		I_ALU_OP : in STD_LOGIC_VECTOR(2 downto 0);
		I_MEM_READ : in STD_LOGIC;
		I_WREG_SOURCE : in STD_LOGIC_VECTOR(1 downto 0);
		I_WREG_WRITE : in STD_LOGIC;
		I_JAL : IN STD_LOGIC;
		I_INST : in STD_LOGIC_VECTOR(31 downto 0);
		I_PC : in STD_LOGIC_VECTOR(31 downto 0);
		O_BADDR_SOURCE : out STD_LOGIC;
		O_GPR_RS : out STD_LOGIC_VECTOR(31 downto 0);
		O_GPR_RT : out STD_LOGIC_VECTOR(31 downto 0);
		O_OPERA_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
		O_OPERB_SOURCE : out STD_LOGIC;
		O_BDECIDE_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
		O_MEM_WRITE : out STD_LOGIC;
		O_WREG_ADDR : out STD_LOGIC_VECTOR(4 downto 0);
		O_ALU_OP : out STD_LOGIC_VECTOR(2 downto 0);
		O_MEM_READ : out STD_LOGIC;
		O_WREG_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
		O_WREG_WRITE : out STD_LOGIC;
		O_JAL : OUT STD_LOGIC;
		O_INST : out STD_LOGIC_VECTOR(31 downto 0);
		O_PC : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: IDEXE use entity work.IDEXE(IDEXE);

	SIGNAL EXE_BADDR_SOURCE : STD_LOGIC;
	SIGNAL EXE_GPR_RS : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL EXE_GPR_RT : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL EXE_BDECIDE_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL EXE_MEM_WRITE : STD_LOGIC;
	SIGNAL EXE_ALU_OP : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL EXE_MEM_READ : STD_LOGIC;
	SIGNAL EXE_WREG_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL EXE_WREG_ADDR : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL EXE_WREG_WRITE : STD_LOGIC;
	SIGNAL EXE_JAL : STD_LOGIC;
	SIGNAL EXE_INST : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL EXE_PC : STD_LOGIC_VECTOR(31 downto 0);
	signal EXE_RS, EXE_RT : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL EXE_BADDR_DATA, EXE_BADDR_DATA_A : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL EXE_OPERA_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL EXE_ALU_RS, EXE_ALU_RT, EXE_OPERA_DATA, EXE_OPERB_DATA : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL EXE_ALU_RES : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL EXE_OPERB_SOURCE : STD_LOGIC;
	SIGNAL EXE_ALU_ZERO : STD_LOGIC;
	SIGNAL EXE_ALU_NEG : STD_LOGIC;
	SIGNAL EXE_ALU_OVF : STD_LOGIC;
	signal EXE_IMED_EX, EXE_IMED_DESL, EXE_SHAMT_EX, EXE_ENDER_DESL : std_logic_vector(31 downto 0);
	signal EXE_BRANCH_IMED : std_logic_vector(31 downto 0);


	-- Component declaration of the "EXEMEM(EXEMEM)" unit defined in
	-- file: "./../src/EXEMEM.vhd"
	component EXEMEM
	port(
		clk : in STD_LOGIC;
		stall : in STD_LOGIC;
		flush : in STD_LOGIC;
		reset : in STD_LOGIC;
		I_BADDR_DATA : in STD_LOGIC_VECTOR(31 downto 0);
		I_ALU_ZERO : in STD_LOGIC;
		I_ALU_NEG : in STD_LOGIC;
		I_BDECIDE_SOURCE : in STD_LOGIC_VECTOR(1 downto 0);
		I_MEM_WRITE : in STD_LOGIC;
		I_WREG_ADDR : in STD_LOGIC_VECTOR(4 downto 0);
		I_ALU_RES : in STD_LOGIC_VECTOR(31 downto 0);
		I_MEM_READ : in STD_LOGIC;
		I_WREG_SOURCE : in STD_LOGIC_VECTOR(1 downto 0);
		I_WREG_WRITE : in STD_LOGIC;
		I_ALU_OVF : in STD_LOGIC;
		I_GPR_RT : in STD_LOGIC_VECTOR(31 downto 0);
		I_JAL : in STD_LOGIC;
		I_INST : in STD_LOGIC_VECTOR(31 downto 0);
		I_PC : in STD_LOGIC_VECTOR(31 downto 0);
		O_BADDR_DATA : out STD_LOGIC_VECTOR(31 downto 0);
		O_ALU_ZERO : out STD_LOGIC;
		O_ALU_NEG : out STD_LOGIC;
		O_BDECIDE_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
		O_MEM_WRITE : out STD_LOGIC;
		O_WREG_ADDR : out STD_LOGIC_VECTOR(4 downto 0);
		O_ALU_RES : out STD_LOGIC_VECTOR(31 downto 0);
		O_MEM_READ : out STD_LOGIC;
		O_WREG_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
		O_WREG_WRITE : out STD_LOGIC;
		O_ALU_OVF : out STD_LOGIC;
		O_GPR_RT : out STD_LOGIC_VECTOR(31 downto 0);
		O_JAL : out STD_LOGIC;
		O_INST : out STD_LOGIC_VECTOR(31 downto 0);
		O_PC : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: EXEMEM use entity work.EXEMEM(EXEMEM);

	SIGNAL MEM_BADDR_DATA : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL MEM_BDECIDE_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL MEM_BDECIDE_DATA : STD_LOGIC;
	SIGNAL MEM_ALU_ZERO : STD_LOGIC;
	SIGNAL MEM_ALU_NEG : STD_LOGIC;
	SIGNAL MEM_ALU_RES : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL MEM_NALU_ZER : STD_logic;
	SIGNAL MEM_ALU_OVF : STD_LOGIC;
	SIGNAL MEM_MEM_WRITE : STD_LOGIC;
	SIGNAL MEM_MEM_READ : STD_LOGIC;
	SIGNAL MEM_WREG_ADDR : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL MEM_WREG_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL MEM_WREG_WRITE : STD_LOGIC;
	SIGNAL MEM_GPR_RT : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL MEM_JAL : STD_LOGIC;
	SIGNAL MEM_INST : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL MEM_PC : STD_LOGIC_VECTOR(31 downto 0);



	SIGNAL MEM_CACHED_DATA : STD_LOGIC_VECTOR(31 downto 0);

	-- Component defined in
	-- file: "./../src/MEMWB.vhd"
	component MEMWB
	port(
		clk : in STD_LOGIC;
		stall : in STD_LOGIC;
		flush : in STD_LOGIC;
		reset : in STD_LOGIC;
		I_WREG_ADDR : in STD_LOGIC_VECTOR(4 downto 0);
		I_ALU_DATA : in STD_LOGIC_VECTOR(31 downto 0);
		I_MEM_DATA : in STD_LOGIC_VECTOR(31 downto 0);
		I_WREG_SOURCE : in STD_LOGIC_VECTOR(1 downto 0);
		I_WREG_WRITE : in STD_LOGIC;
		I_ALU_NEG : in STD_LOGIC;
		I_JAL : IN STD_LOGIC;
		I_INST : in STD_LOGIC_VECTOR(31 downto 0);
		I_PC : in STD_LOGIC_VECTOR(31 downto 0);
		O_WREG_ADDR : out STD_LOGIC_VECTOR(4 downto 0);
		O_ALU_DATA : out STD_LOGIC_VECTOR(31 downto 0);
		O_MEM_DATA : out STD_LOGIC_VECTOR(31 downto 0);
		O_WREG_SOURCE : out STD_LOGIC_VECTOR(1 downto 0);
		O_WREG_WRITE : out STD_LOGIC;
		O_ALU_NEG : out STD_LOGIC;
		O_JAL : OUT STD_LOGIC;
		O_INST : out STD_LOGIC_VECTOR(31 downto 0);
		O_PC : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	for all: MEMWB use entity work.MEMWB(MEMWB);

	SIGNAL WB_WREG_ADDR : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL WB_WREG_DATA : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL WB_WREG_SOURCE : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL WB_WREG_WRITE : STD_LOGIC;
	SIGNAL WB_ALU_DATA : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL WB_MEM_DATA : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL WB_ALU_NEG : STD_LOGIC;
	SIGNAL WB_JAL : STD_LOGIC;
	SIGNAL WB_INST : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL WB_PC : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL WB_NEG_AUX : std_logic_vector(31 downto 0);

    	-- Component declaration of the "Mux4x1Bit(Mux4x1Bit)" unit defined in
	-- file: "./../src/Mux4x1Bit.vhd"
	component Mux4x1Bit
	port(
		I0 : in STD_LOGIC;
		I1 : in STD_LOGIC;
		I2 : in STD_LOGIC;
		I3 : in STD_LOGIC;
		Sel0 : in STD_LOGIC;
		Sel1 : in STD_LOGIC;
		O : out STD_LOGIC);
	end component;
	for all: Mux4x1Bit use entity work.Mux4x1Bit(Mux4x1Bit);






	signal INTERRUPT_SIGNAL, INTERRUPT_SOURCE : STD_LOGIC;
	signal EPC, CAUSA : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

	--memória

	-- Component declaration of the "MemoriaPrincipal(MemoriaPrincipal)" unit defined in
	-- file: "./../src/MemoriaPrincipal.vhd"
	component MemoriaPrincipal
	port(
		Clock : in STD_LOGIC;
		rw : in STD_LOGIC;
		enableI : in STD_LOGIC;
		enableD : in STD_LOGIC;
		enderI : in STD_LOGIC_VECTOR(31 downto 0);
		enderD : in STD_LOGIC_VECTOR(31 downto 0);
		dadoD_w : in STD_LOGIC_VECTOR(127 downto 0);
		dadoI : out STD_LOGIC_VECTOR(127 downto 0);
		dadoD_r : out STD_LOGIC_VECTOR(127 downto 0);
		prontoI : out STD_LOGIC;
		prontoD : out STD_LOGIC;
		memDump : in STD_LOGIC);
	end component;
	for all: MemoriaPrincipal use entity work.MemoriaPrincipal(MemoriaPrincipal);

	-- Component declaration of the "CacheI(CacheI)" unit defined in
	-- file: "./../src/CacheI.vhd"
	component CacheI
	port(
		Clock : in STD_LOGIC;
		enable : in STD_LOGIC;
		rw : in STD_LOGIC;
		ender : in STD_LOGIC_VECTOR(31 downto 0);
		dado : out STD_LOGIC_VECTOR(31 downto 0);
		CACHEI_MISS : out STD_LOGIC;
		MAIN_DATA : in STD_LOGIC_VECTOR(127 downto 0);
		MAIN_END : out STD_LOGIC_VECTOR(31 downto 0);
		ENABLE_I : out STD_LOGIC;
		MAIN_PRONTO : in STD_LOGIC);
	end component;
	for all: CacheI use entity work.CacheI(CacheI);


	SIGNAL CACHEI_MISS : STD_LOGIC := '0';
	SIGNAL CACHED_MISS : STD_LOGIC := '0';

	SIGNAL MP_enableI, MP_prontoI : STD_LOGIC;
	signal MP_dadoI : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL MP_ENDERI : STD_LOGIC_VECTOR(31 DOWNTO 0);

--

  -- Component declaration of the "PC(PC)" unit defined in
  -- file: "./../src/PC.vhd"
  component PC
  port(
  clk : in STD_LOGIC;
  stall : in STD_LOGIC;
  reset : in STD_LOGIC;
  IPC : in STD_LOGIC_VECTOR(31 downto 0);
  OPC : out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  for all: PC use entity work.PC(PC);

  --ESTAGIOS



  --utils

  -- Component declaration of the "Mux2x1(Mux2x1)" unit defined in
  -- file: "./../src/Mux2x1.vhd"
  component Mux2x1
  port(
    I0 : in STD_LOGIC_VECTOR(31 downto 0);
    I1 : in STD_LOGIC_VECTOR(31 downto 0);
    Sel : in STD_LOGIC;
    O : out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  for all: Mux2x1 use entity work.Mux2x1(Mux2x1);

  -- Component declaration of the "Mux4x1(Mux4x1)" unit defined in
  -- file: "./../src/Mux4x1.vhd"
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


  -- Component declaration of the "Somador(Somador)" unit defined in
  -- file: "./../src/Somador.vhd"
  component Somador
  port(
    in1 : in STD_LOGIC_VECTOR(31 downto 0);
    in2 : in STD_LOGIC_VECTOR(31 downto 0);
    sai : out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  for all: Somador use entity work.Somador(Somador);

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


signal PC_STALL_DEF : STD_LOGIC;

signal clk : std_logic := '0';
signal over : std_logic := '0';
SIGNAL CACHED_DM : STD_LOGIC := '0';

SIGNAL CCICLOS : INTEGER := 0;

SIGNAL CNOP : INTEGER := 0;
SIGNAL CADD : INTEGER := 0;
SIGNAL CSLT : INTEGER := 0;
SIGNAL CJR : INTEGER := 0;
SIGNAL CADDU : INTEGER := 0;
SIGNAL CSLL : INTEGER := 0;
SIGNAL CLW : INTEGER := 0;
SIGNAL CSW : INTEGER := 0;
SIGNAL CADDI : INTEGER := 0;
SIGNAL CBEQ : INTEGER := 0;
SIGNAL CBNE : INTEGER := 0;
SIGNAL CSLTI : INTEGER := 0;
SIGNAL CJ : INTEGER := 0;
SIGNAL CJAL : INTEGER := 0;

SIGNAL CBTAKEN : INTEGER := 0;
SIGNAL CBTOTAL : INTEGER := 0;

SIGNAL CCACHEIMISS : INTEGER := 0;
SIGNAL CCACHEIACC : INTEGER := 0;
SIGNAL CCACHEDMISS : INTEGER := 0;
SIGNAL CCACHEDACC : INTEGER := 0;
SIGNAL CMEMACC : INTEGER := 0;

-- SINAIS DA MEMÓRIA
SIGNAL MP_RW, MP_enableD, MP_prontoD : STD_LOGIC := '0';
SIGNAL MP_ENDERD : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
SIGNAL MP_dadoD : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');

-- SINAIS DO CACHED/BUFFER
SIGNAL B_BUSY : std_logic;
SIGNAL B_END :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B_PEDIDO : std_logic;
SIGNAL B_DADOS : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin


	clk <= not clk after 7.5 ns when over /= '1' else '0';

	process(WB_INST)
	begin
		if WB_INST = "11111111111111111111111111111111" then
			over <= '1';
			report "\a"	;
		end if;
	end process;

	process(clk, INTERRUPT_SIGNAL)
	begin
		if falling_edge(clk) and INTERRUPT_SIGNAL = '1' then
			EPC <= IFE_PC_DATA;
			IF INTERRUPT_SOURCE = '0' then
				CAUSA <= "11011110010111000000111011000001";
			ELSE
				CAUSA <= "11111111111111111111111111111111";
			END IF;
		end if;
	end process;

	MP : MemoriaPrincipal
	port map(
		Clock => ClK,
		rw => MP_RW,
		enableI => MP_enableI,
		enableD => MP_enableD,
		enderI => MP_ENDERI,
		enderD => MP_ENDERD,
		dadoD_w => (others => '0'),
		dadoI => MP_dadoI,
		dadoD_r => MP_dadoD,
		prontoI => MP_prontoI,
		prontoD => MP_prontoD,
		memDump => '0'
	);

	CI : CacheI
	port map(
		Clock => clk,
		enable => '1',
		rw => '1',
		ender => IFE_PC_DATA,
		dado => IFE_INST,
		CACHEI_MISS => CACHEI_MISS,
		MAIN_DATA => MP_dadoI,
		MAIN_END => MP_ENDERI,
		ENABLE_I => MP_enableI,
		MAIN_PRONTO => MP_prontoI
	);

	CD : CacheD
	port map(
		Clock => Clk,
		enable => '0',
		readD => MEM_MEM_READ,
		writeD => MEM_MEM_WRITE,
		ender => MEM_ALU_RES,
		writeDado => MEM_GPR_RT,
		dado => MEM_CACHED_DATA,
		CacheD_MISS => CACHED_MISS,
		dumpMemory => over,
		MAIN_DATA => MP_dadoD,
		MAIN_RW => MP_RW,
		MAIN_END => MP_ENDERD,
		ENABLE_I => MP_enableD,
		MAIN_PRONTO => MP_prontoD,
		BUFFER_BUSY => B_BUSY,
		BUFFER_END =>  B_END,
		BUFFER_DADOS => B_DADOS,
		BUFFER_PEDIDO => B_PEDIDO
	);


	CB : CacheBuffer
	port map(
		Clock => Clk,
		ender_in => B_END,
		dados_in => B_DADOS,
		pedido_in => B_PEDIDO,
		ready_in => MP_prontoD,
		busy => B_BUSY,
		pedido_out => MP_enableD,
		dados_out => MP_dadoD,
		ender_out => MP_ENDERD
	);


	--

	FU : ForwardingUnit
		port map(
			MEM_WREG_ADDR => MEM_WREG_ADDR,
			WB_WREG_ADDR => WB_WREG_ADDR,
			MEM_WREG_WRITE => MEM_WREG_WRITE,
			WB_WREG_WRITE => WB_WREG_WRITE,
			EXE_RS => EXE_RS,
			EXE_RT => EXE_RT,
			FORWARD_RS_DECIDE => FORWARD_RS_DECIDE,
			FORWARD_RT_DECIDE => FORWARD_RT_DECIDE
		);

		HU : HazardUnit
	port map(
		INTERRUPT_SIGNAL => INTERRUPT_SIGNAL,
		INTERRUPT_SOURCE => INTERRUPT_SOURCE,
		BDECIDE_DATA => MEM_BDECIDE_DATA,
		CACHEI_MISS => CACHEI_MISS,
		CACHED_MISS => CACHED_MISS,
		EXE_MEM_READ => EXE_MEM_READ,
		IDE_INST => IDE_INST,
		EXE_INST => EXE_INST,
		FLUSH_IFID => FLUSH_IFID,
		FLUSH_IDEXE => FLUSH_IDEXE,
		FLUSH_EXEMEM => FLUSH_EXEMEM,
		FLUSH_MEMWB => FLUSH_MEMWB,
		STALL_IFID => STALL_IFID,
		STALL_IDEXE => STALL_IDEXE,
		STALL_EXEMEM => STALL_EXEMEM,
		STALL_MEMWB => STALL_MEMWB,
		STALL_PC => STALL_PC
	);

--

	PC_STALL_DEF <= STALL_PC AND (NOT MEM_BDECIDE_DATA);

  R_PC : PC
	port map(
		clk => clk,
		stall => PC_STALL_DEF,
		reset => reset,
		IPC => IFE_PC_FEED,
		OPC => IFE_PC_DATA
	);

  ife_Soma4 : Somador
	port map(
		in1 => IFE_PC_DATA,
		in2 => "00000000000000000000000000000100",
		sai => PC_INCR
	);

  IFE_PCFeed : Mux4x1
	port map(
		I0 => PC_INCR,
		I1 => MEM_BADDR_DATA,
		I2 => "00000000000000000000000000000000", --COLOCAR ENDERE�O DA INTERRUPT
		I3 => "00000000000000000000000000000000", --COLOCAR ENDERE�O DA INTERRUPT
		Sel0 => MEM_BDECIDE_DATA,
		Sel1 => INTERRUPT_SIGNAL,
		O => IFE_PC_FEEDA
	);

	PC_INTERRUPT : Mux2x1
	port map(
		I0 => IFE_PC_FEEDA,
		I1 => "00000000000000000000000001110000",
		Sel => INTERRUPT_SIGNAL,
		O => IFE_PC_FEED
	);


	R_IFID : IFID
	port map(
		clk => clk,
		stall => STALL_IFID,
		flush => FLUSH_IFID,
		reset => reset,
		I_INST => IFE_INST,
		I_PC => IFE_PC_FEED,
		O_INST => IDE_INST,
		O_PC => IDE_PC
	);


  IDE_rs <= IDE_INST(25 downto 21);
  IDE_rt <= IDE_INST(20 downto 16);
  IDE_rd <= IDE_INST(15 downto 11);

  IDE_REGS : GPR
  port map(
    clk => clk,
    we => WB_WREG_WRITE,
    WriteData => WB_WREG_DATA,
    WriteEnd => WB_WREG_ADDR,
    Rs => IDE_rs,
    Rt => IDE_rt,
    GPRRs => IDE_GPR_RS,
    GPRRt => IDE_GPR_RT,
    R0 => IDE_R0,
    R1 => IDE_R1,
    R2 => IDE_R2,
    R3 => IDE_R3,
    R4 => IDE_R4,
    R5 => IDE_R5,
    R6 => IDE_R6,
    R7 => IDE_R7
  );

  IDE_CTRL : Controle
  port map(
    Inst => IDE_INST,
    Overflow => MEM_ALU_OVF,
    BADDR_SOURCE => IDE_BADDR_SOURCE,
    OPERA_SOURCE => IDE_OPERA_SOURCE,
    OPERB_SOURCE => IDE_OPERB_SOURCE,
    BDECIDE_SOURCE => IDE_BDECIDE_SOURCE,
    MEM_WRITE => IDE_MEM_WRITE,
    ALU_OP => IDE_ALU_OP,
    MEM_READ => IDE_MEM_READ,
    WREG_SOURCE => IDE_WREG_SOURCE,
    WREG_WRITE => IDE_WREG_WRITE,
    WREG_ADDR_SOURCE => IDE_WREG_ADDR_SOURCE,
    JAL => IDE_JAL,
    INTERRUPT_SIGNAL => INTERRUPT_SIGNAL,
    INTERRUPT_SOURCE => INTERRUPT_SOURCE
  );

  IDE_WAS : Mux4x1_5b
  port map(
    I0 =>  IDE_rd,
    I1 =>  IDE_rt,
    I2 => "00111",
    I3 => "00000",
    Sel0 => IDE_WREG_ADDR_SOURCE(0),
    Sel1 => IDE_WREG_ADDR_SOURCE(1),
    O => IDE_WREG_ADDR
  );

	R_IDEXE : IDEXE
	port map(
		clk => clk,
		stall => STALL_IDEXE,
		flush => FLUSH_IDEXE,
		reset => reset,
		I_BADDR_SOURCE => IDE_BADDR_SOURCE,
		I_GPR_RS => IDE_GPR_RS,
		I_GPR_RT => IDE_GPR_RT,
		I_OPERA_SOURCE => IDE_OPERA_SOURCE,
		I_OPERB_SOURCE => IDE_OPERB_SOURCE,
		I_BDECIDE_SOURCE => IDE_BDECIDE_SOURCE,
		I_MEM_WRITE => IDE_MEM_WRITE,
		I_WREG_ADDR => IDE_WREG_ADDR,
		I_ALU_OP => IDE_ALU_OP,
		I_MEM_READ => IDE_MEM_READ,
		I_WREG_SOURCE => IDE_WREG_SOURCE,
		I_WREG_WRITE => IDE_WREG_WRITE,
		I_JAL => IDE_JAL,
		I_INST => IDE_INST,
		I_PC => IDE_PC,
		O_BADDR_SOURCE => EXE_BADDR_SOURCE,
		O_GPR_RS => EXE_GPR_RS,
		O_GPR_RT => EXE_GPR_RT,
		O_OPERA_SOURCE => EXE_OPERA_SOURCE,
		O_OPERB_SOURCE => EXE_OPERB_SOURCE,
		O_BDECIDE_SOURCE => EXE_BDECIDE_SOURCE,
		O_MEM_WRITE => EXE_MEM_WRITE,
		O_WREG_ADDR => EXE_WREG_ADDR,
		O_ALU_OP => EXE_ALU_OP,
		O_MEM_READ => EXE_MEM_READ,
		O_WREG_SOURCE => EXE_WREG_SOURCE,
		O_WREG_WRITE => EXE_WREG_WRITE,
		O_JAL => EXE_JAL,
		O_INST => EXE_INST,
		O_PC => EXE_PC
	);


  EXE_IMED_EX <=  EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_INST(15) &
									EXE_Inst(15 downto 0);
	EXE_IMED_DESL <= EXE_IMED_EX(29 downto 0) & "00";
	EXE_SHAMT_EX <= "000000000000000000000000000" & EXE_Inst(10 downto 6);
	EXE_ENDER_DESL <= EXE_PC(31 downto 28) & EXE_Inst(25 downto 0) & "00";

	EXE_RS <= EXE_INST(25 downto 21);
	EXE_RT <= EXE_INST(20 downto 16);

	EXE_ForwRS : Mux4x1
	port map(
		I0 => EXE_GPR_RS,
		I1 => MEM_ALU_RES,
		I2 => WB_WREG_DATA,
		I3 => (others => '0'),
		Sel0 => FORWARD_RS_DECIDE(0),
		Sel1 => FORWARD_RS_DECIDE(1),
		O => EXE_ALU_RS
	);

	EXE_ForwRT : Mux4x1
	port map(
    I0 => EXE_GPR_RT,
    I1 => MEM_ALU_RES,
    I2 => WB_WREG_DATA,
    I3 => (others => '0'),
    Sel0 => FORWARD_RT_DECIDE(0),
    Sel1 => FORWARD_RT_DECIDE(1),
		O => EXE_ALU_RT
	);

	EXE_MOpa : Mux4x1
	port map(
		I0 => EXE_ALU_RS,
		I1 => EXE_IMED_EX,
		I2 => EXE_SHAMT_EX,
		I3 => (others => '0'),
		Sel0 => EXE_OPERA_SOURCE(0),
		Sel1 => EXE_OPERA_SOURCE(1),
		O => EXE_OPERA_DATA
	);

	EXE_MOpb : Mux2x1
	port map(
		I0 => EXE_ALU_RT,
		I1 => EXE_IMED_EX,
		Sel => EXE_OPERB_SOURCE,
		O => EXE_OPERB_DATA
	);

	EXE_UlaExe : ULA
	port map(
		OpA => EXE_OPERA_DATA,
		OpB => EXE_OPERB_DATA,
		Oper => EXE_ALU_OP,
		ZER => EXE_ALU_ZERO,
		NEG => EXE_ALU_NEG,
		OVF => EXE_ALU_OVF,
		Res => EXE_ALU_RES
	);


	EXE_BranchMux : Mux2x1
	port map(
		I0 => EXE_BRANCH_IMED,
		I1 => EXE_ENDER_DESL,
		Sel => EXE_BADDR_SOURCE,
		O => EXE_BADDR_DATA_A
	);

	EXE_SomadorExe : Somador
	port map(
		in1 => EXE_PC,
		in2 => EXE_IMED_DESL,
		sai => EXE_BRANCH_IMED
	);


	EXE_BRA : Mux4x1
	port map(
		I0 => EXE_BRANCH_IMED,
		I1 => EXE_ENDER_DESL,
		I2 => EXE_GPR_RS,
		I3 => EXE_GPR_RS,
		Sel0 => EXE_BADDR_SOURCE,
		Sel1 => EXE_JAL,
		O => EXE_BADDR_DATA
	);


	R_EXEMEM : EXEMEM
	port map(
		clk => clk,
		stall => STALL_EXEMEM,
		flush => FLUSH_EXEMEM,
		reset => reset,
		I_BADDR_DATA => EXE_BADDR_DATA,
		I_ALU_ZERO => EXE_ALU_ZERO,
		I_ALU_NEG => EXE_ALU_NEG,
		I_BDECIDE_SOURCE => EXE_BDECIDE_SOURCE,
		I_MEM_WRITE => EXE_MEM_WRITE,
		I_WREG_ADDR => EXE_WREG_ADDR,
		I_ALU_RES => EXE_ALU_RES,
		I_MEM_READ => EXE_MEM_READ,
		I_WREG_SOURCE => EXE_WREG_SOURCE,
		I_WREG_WRITE => EXE_WREG_WRITE,
		I_ALU_OVF => EXE_ALU_OVF,
		I_GPR_RT => EXE_GPR_RT,
		I_JAL => EXE_JAL,
		I_INST => EXE_INST,
		I_PC => EXE_PC,
		O_BADDR_DATA => MEM_BADDR_DATA,
		O_ALU_ZERO => MEM_ALU_ZERO,
		O_ALU_NEG => MEM_ALU_NEG,
		O_BDECIDE_SOURCE => MEM_BDECIDE_SOURCE,
		O_MEM_WRITE => MEM_MEM_WRITE,
		O_WREG_ADDR => MEM_WREG_ADDR,
		O_ALU_RES => MEM_ALU_RES,
		O_MEM_READ => MEM_MEM_READ,
		O_WREG_SOURCE => MEM_WREG_SOURCE,
		O_WREG_WRITE => MEM_WREG_WRITE,
		O_ALU_OVF => MEM_ALU_OVF,
		O_GPR_RT => MEM_GPR_RT,
		O_JAL => MEM_JAL,
		O_INST => MEM_INST,
		O_PC => MEM_PC
	);


	MEM_NALU_ZER <= NOT MEM_ALU_ZERO;

	MEM_FEED_BDECIDE : Mux4x1Bit
	port map(
		I0 => '0',
		I1 => '1',
		I2 => MEM_ALU_ZERO,
		I3 => MEM_NALU_ZER,
		Sel0 => MEM_BDECIDE_SOURCE(0),
		Sel1 => MEM_BDECIDE_SOURCE(1),
		O => MEM_BDECIDE_DATA
	);


	R_MEMWB : MEMWB
	port map(
		clk => clk,
		stall => STALL_MEMWB,
		flush => FLUSH_MEMWB,
		reset => reset,
		I_WREG_ADDR => MEM_WREG_ADDR,
		I_ALU_DATA => MEM_ALU_RES,
		I_MEM_DATA => MEM_CACHED_DATA,
		I_WREG_SOURCE => MEM_WREG_SOURCE,
		I_WREG_WRITE => MEM_WREG_WRITE,
		I_ALU_NEG => MEM_ALU_NEG,
		I_JAL => MEM_JAL,
		I_INST => MEM_INST,
		I_PC => MEM_PC,
		O_WREG_ADDR => WB_WREG_ADDR,
		O_ALU_DATA => WB_ALU_DATA,
		O_MEM_DATA => WB_MEM_DATA,
		O_WREG_SOURCE => WB_WREG_SOURCE,
		O_WREG_WRITE => WB_WREG_WRITE,
		O_ALU_NEG => WB_ALU_NEG,
		O_JAL => WB_JAL,
		O_INST => WB_INST,
		O_PC => WB_PC
	);

	WB_NEG_AUX <= "0000000000000000000000000000000" & WB_ALU_NEG;

	WBA_WR : Mux4x1
	port map(
		I0 => WB_ALU_DATA,
		I1 => WB_MEM_DATA,
		I2 => WB_NEG_AUX,
		I3 => WB_PC,
		Sel0 => WB_WREG_SOURCE(0),
		Sel1 => WB_WREG_SOURCE(1),
		O => WB_WREG_DATA
	);


	statsA: process(clk)
	begin
		if clk'event and clk = '0' and STALL_MEMWB = '0' then
			CCICLOS <= CCICLOS + 1;
			CASE WB_INST(31 downto 26) is
				WHEN "000000" =>
					CASE WB_INST(5 downto 0) IS
						WHEN "100000" => CADD <= CADD + 1;
						WHEN "011010" => CSLT <= CSLT + 1;
						WHEN "001000" => CJR <= CJR + 1;
						WHEN "100001" => CADDU <= CADDU + 1;
						WHEN "000000" =>
							IF WB_INST = "00000000000000000000000000000000" then
								CNOP <= CNOP + 1;
							ELSE
								CSLL <= CSLL + 1;
							END IF;
						WHEN OTHERS => NULL;
					END CASE;
				WHEN "100011" => CLW <= CLW + 1;
				WHEN "101011" => CSW <= CSW + 1;
				WHEN "001000" => CADDI <= CADDI + 1;
				WHEN "000100" => CBEQ <= CBEQ + 1;
				WHEN "000101" => CBNE <= CBNE + 1;
				WHEN "001010" => CSLTI <= CSLTI + 1;
				WHEN "000010" => CJ <= CJ + 1;
				WHEN "000011" => CJAL <= CJAL + 1;
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END process;

	statsB: process(clk)
	begin
		if clk'event and clk = '0' then
			if NOT (MEM_BDECIDE_SOURCE = "00") THEN
				CBTOTAL <= CBTOTAL + 1;
			END IF;
			if (MEM_BDECIDE_DATA = '1') THEN
				CBTAKEN <= CBTAKEN + 1;
			END IF;
		END IF;
	end process;

	statsC : process(clk,CACHEI_MISS,CacheD_MISS,MP_enableI,MP_enableD)
	variable aux, cv, cv2 : std_logic := '0';
	begin
		if rising_edge(CacheI_MISS) then
			CCACHEIMISS <= CCACHEIMISS + 1;
		end if;
		if rising_edge(clk) then
			if CacheD_MISS = '1' and cv ='0' then
				CCACHEDMISS <= CCACHEDMISS + 1;
			end if;
			cv := CacheD_MISS;
		end if;
		if clk'event and clk = '0' and (MEM_MEM_READ = '1' or MEM_MEM_WRITE = '1') and CacheD_MISS = '0' then
			CCACHEDACC <= CCACHEDACC + 1;
		end if;
		if clk'event and clk = '0' and CacheI_MISS = '0' then
			CCACHEIACC <= CCACHEIACC + 1;
		end if;
		if rising_edge(clk) then
			if (MP_enableI = '1' or MP_enableD = '1') and cv2 = '0' then
				CMEMACC <= CMEMACC + 1;
			end if;
			cv2 := MP_enableI or MP_enableD;
		end if;
	end process;

	printStats : process(over)
	variable l : line;
	file outfile : text open write_mode is "stats.txt";
	begin
		if over = '1' then
			write(l,"CICLOS TOTAIS:");
			write(l,CCICLOS);
			writeline(outfile, l);
			write(l,"BOLHAS:");
			write(l,CNOP);
			writeline(outfile, l);
			write(l,"OPERACOES ADD:");
			write(l,CADD);
			writeline(outfile, l);
			write(l,"OPERACOES SLT:");
			write(l,CSLT);
			writeline(outfile, l);
			write(l,"OPERACOES JR:");
			write(l,CJR);
			writeline(outfile, l);
			write(l,"OPERACOES ADDU:");
			write(l,CADDU);
			writeline(outfile, l);
			write(l,"OPERACOES SLL:");
			write(l,CSLL);
			writeline(outfile, l);
			write(l,"OPERACOES LW:");
			write(l,CLW);
			writeline(outfile, l);
			write(l,"OPERACOES SW:");
			write(l,CSW);
			writeline(outfile, l);
			write(l,"OPERACOES ADDI:");
			write(l,CADDI);
			writeline(outfile, l);
			write(l,"OPERACOES BEQ:");
			write(l,CBEQ);
			writeline(outfile, l);
			write(l,"OPERACOES BNE:");
			write(l,CBNE);
			writeline(outfile, l);
			write(l,"OPERACOES SLTI:");
			write(l,CSLTI);
			writeline(outfile, l);
			write(l,"OPERACOES J:");
			write(l,CJ);
			writeline(outfile, l);
			write(l,"OPERACOES JAL:");
			write(l,CJAL);
			writeline(outfile, l);
			write(l,"BRANCHES TOMADOS:");
			write(l,CBTAKEN);
			writeline(outfile, l);
			write(l,"TOTAL DE BRANCHES:");
			write(l,CBTOTAL);
			writeline(outfile, l);
			write(l,"ACESSOS AO CACHE I:");
			write(l,CCACHEIACC);
			writeline(outfile, l);
			write(l,"MISSES DO CACHE I:");
			write(l,CCACHEIMISS);
			writeline(outfile, l);
			write(l,"MISSES DO CACHE D:");
			write(l,CCACHEDMISS);
			writeline(outfile, l);
			write(l,"ACESSOS AO CACHE D:");
			write(l,CCACHEDACC);
			writeline(outfile, l);
			write(l,"ACESSOS A MEMORIA PRINCIPAL:");
			write(l,CMEMACC);
			writeline(outfile, l);
		end if;
	end process;

end proc;
