
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity WBA is
port(
	clk : in std_logic;
	Inst : in std_logic_vector(31 downto 0);

  ALU_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  MEM_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  WREG_SOURCE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
  ALU_NEG : IN STD_LOGIC;
  PC : IN STD_LOGIC_VECTOR(31 downto 0);

  WREG_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end WBA;

architecture WBA of WBA is

  SIGNAL SLT : STD_LOGIC_VECTOR(31 downto 0);

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


begin

	SLT <= "0000000000000000000000000000000" & ALU_NEG;

  M : Mux4x1
	port map(
		I0 => ALU_DATA,
		I1 => MEM_DATA,
		I2 => SLT,
		I3 => PC,
		Sel0 => WREG_SOURCE(0),
		Sel1 => WREG_SOURCE(1),
		O => WREG_DATA
	);

end WBA;
