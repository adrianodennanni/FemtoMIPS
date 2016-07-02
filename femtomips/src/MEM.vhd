library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity MEM is
port(
	clk : in std_logic;
	Inst : in std_logic_vector(31 downto 0);

	ALU_ZERO : IN STD_LOGIC;
	ALU_NEG : IN STD_LOGIC;
	BDECIDE_SOURCE : IN STD_LOGIC_VECTOR(1 downto 0);
	BDECIDE_DATA : OUT STD_LOGIC
);
end MEM;

architecture MEM of MEM is


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


	signal NOT_ZERO : STD_LOGIC;

begin

	NOT_ZERO <= not ALU_ZERO;

	Label1 : Mux4x1Bit
	port map(
		I0 => '0',
		I1 => '1',
		I2 => ALU_ZERO,
		I3 => NOT_ZERO,
		Sel0 => BDECIDE_SOURCE(0),
		Sel1 => BDECIDE_SOURCE(1),
		O => BDECIDE_DATA
	);

end MEM;
