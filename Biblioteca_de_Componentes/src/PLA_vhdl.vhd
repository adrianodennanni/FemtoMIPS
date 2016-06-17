------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Biblioteca_de_Componentes\Biblioteca_de_Componentes\compile\PLA.vhd
-- Generated   : Sun Nov 23 11:57:13 2008
-- From        : c:\My_Designs\Biblioteca_de_Componentes\Biblioteca_de_Componentes\src\PLA.bde
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


-- other libraries declarations
library Biblioteca_de_Componentes;

entity PLA is
  generic(
       NE: integer := 4; 
       NS: integer := 4; 
       NP: integer := 4; 
	   Tprop: time := 3 ns
  );
  port(
       Ent 	: in  std_logic_vector(NE - 1 downto 0);
       Sai 	: out std_logic_vector(NS - 1 downto 0)
  );
end PLA;

architecture PLA of PLA is

---- Component declarations -----

component fuse_and
  port (
       FI  : in  STD_LOGIC;
       FIL : in  STD_LOGIC;
       I   : in  STD_LOGIC;
       S   : out STD_LOGIC
  );
end component;
component fuse_ou
	port (
		Fp: in  std_logic;
		P : in  std_logic;
		Ss: out std_logic
	);
end component;
component And_NE
	port (
		Sp: in  std_logic_vector (0 to NE - 1);
		P : out std_logic
	);
end component;
component Ou_NP
	port (
		Ss: in  std_logic_vector( 0 to NP - 1);
		S:	out std_logic
	);
end component;

type   Fuse_in   is array (0 to NP - 1) of std_logic_vector(0 to NE - 1);
type   Fuse_prod is array (0 to NS - 1) of std_logic_vector(0 to NP - 1);
signal Fin  : Fuse_in;
signal FinL : Fuse_in;
signal Fprod: Fuse_prod;
signal Sp	: Fuse_in;
signal Prod	: std_logic_vector( 0 to NP - 1);
signal Ss	: Fuse_prod;

begin
----  Component array-instantiations  ---- 
-- Geração da Matriz AND de fusíveis para programação
ME_coluna: For i in 0 to NE - 1 generate
	ME_linha: For j in 0 to NP - 1 generate
				F_and_array:Fuse_and
				port map (
					I		=> Ent (i),
					Fi 		=> Fin(j)(i),
					FiL 	=> FinL(j)(i),
					S		=> Sp(j)(i)
				);
	end generate;
end generate;
-- Geração dos ANDs com NE entradas da Matriz AND 
Ve_Prod: For j in 0 to NP - 1 generate
	 	And_NE_array: And_NE
		port map (
			Sp	=> Sp(j),
			p	=> Prod(j)
		);
end generate;
-- Geração da Matriz OU com os fusíveis para programação
Mou_coluna:For k in 0 to NS - 1 generate
	Mou_linha: For j in 0 to NP - 1 generate
				F_prod_array: Fuse_ou
				port map (
					Fp	=> Fprod(j)(k),
					P	=> Prod(j),
					Ss	=> Ss(j)(k)
				);
	end generate;
end generate;
-- Geração do OU_NP para produzir as saídas S da PLA
Ve_saida: For k in 0 to NS - 1 generate
			Ou_NP_array: OU_NP
			port map (
				Ss	=> Ss(k),
				S	=> Sai(k)
			);
end generate;

end PLA;
		
	