-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\CSA.vhd
-- Generated   : Wed Nov 21 21:15:53 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\CSA.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;


entity CSA is
  generic(
       NB: integer := 8
  );
  port(
       Cin : in std_logic;
       X : in std_logic_vector(NB - 1 downto 0);
       Y : in std_logic_vector(NB - 1 downto 0);
       Z : in std_logic_vector(NB - 1 downto 0);
       Cout : out std_logic;
       C : out std_logic_vector(NB - 1 downto 0);
       S : out std_logic_vector(NB - 1 downto 0)
  );
end CSA;

architecture CSA of CSA is

---- Architecture declarations -----
component FA
	Port(
       ci : in std_logic;
       x : in std_logic;
       y : in std_logic;
       co : out std_logic;
       s : out std_logic
	);
end component;


begin

---- User Signal Assignments ----
CSA : for I in 0 to (NB - 2) generate
	FAx : FA
		Port Map(
			ci => Z(I),
			x => X(I),
			y => Y(I),
			s => S(I),
			co => C(I+1)
		);
end generate;

FA_NB : FA		
	Port Map(
		ci => Z(NB - 1),
		x => X(NB - 1),
		y => Y(NB - 1),
		s => S(NB - 1),
		co => Cout
	);

c(0) <= Cin;

end CSA;
