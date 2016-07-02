library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity IFE is
port(
	clk : in std_logic;
	reset : in std_logic;

	PC_STALL : in std_logic;
	BDECIDE_DATA : IN STD_LOGIC;
	BADDR_DATA : IN STD_LOGIC_VECTOR(31 downto 0);


	PC_DATA : OUT STD_LOGIC_VECTOR(31 downto 0);
	INTERRUPT_SIGNAL : IN STD_LOGIC;
	WREG_DATA : IN STD_LOGIC_VECTOR(31 downto 0);
	JAL : IN STD_LOGIC

);
end IFE;

architecture IFE of IFE is

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

	--SINAIS
	signal PC_INCREMENTADO : std_logic_vector(31 downto 0);
	signal PC_IN, PC_OUT : std_logic_vector(31 downto 0);

begin

	--L�GICA DO PC

	PC_DATA <= PC_OUT;

	PCFeed : Mux4x1
	port map(
		I0 => PC_INCREMENTADO,
		I1 => BADDR_DATA,
		I2 => WREG_DATA, --COLOCAR ENDERE�O DA INTERRUPT
		I3 => WREG_DATA, --COLOCAR ENDERE�O DA INTERRUPT
		Sel0 => BDECIDE_DATA,
		Sel1 => JAL,
		O => PC_IN
	);

	PCfemtomips : PC
	port map(
		clk => clk,
		stall => PC_STALL,
		reset => reset,
		IPC => PC_IN,
		OPC => PC_OUT
	);

	Soma4 : Somador
	port map(
		in1 => PC_OUT,
		in2 => "00000000000000000000000000000100",
		sai => PC_INCREMENTADO
	);

	--FIM

end IFE;
