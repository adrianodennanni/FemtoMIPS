-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Arquivos de programas\Aldec\Active-HDL 8.2\Vlib\Biblioteca_de_Componentes\compile\pla.vhd
-- Generated   : Thu Aug 26 16:19:59 2010
-- From        : c:\Arquivos de programas\Aldec\Active-HDL 8.2\Vlib\Biblioteca_de_Componentes\src\pla.bde
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


-- active library clause
library Biblioteca_de_Componentes;

entity PLA is
  generic(
       NE: integer := 4; 
       NS: integer := 4; 
       NP: integer := 4; 
       Tprop: time := 3 ns 
  );
  port(
       Ent : in std_logic_vector(0 downto NE - 1);
       Sai : out std_logic_vector(0 downto NS - 1)
  );
end PLA;

architecture PLA of PLA is

---- Component declarations -----

component Fuse_and
  port (
       FI : in STD_LOGIC;
       FIL : in STD_LOGIC;
       I : in STD_LOGIC;
       S : out STD_LOGIC
  );
end component;

---- Architecture declarations -----
type Fuse_in is array (0 to NP - 1) of std_logic_vector (0 to NE - 1);
type Fuse_prod is array (0 to NS - 1) of std_logic_vector ( 0 to NP - 1);
signal Fin: Fuse_in;
signal FinL: Fuse_in;
signal Fprod: Fuse_prod;
signal Sp: Fuse_in;
signal Ss: Fuse_prod;
signal Prod: std_logic_vector(0 to NP - 1);


----     Constants     -----
constant DANGLING_INPUT_CONSTANT : STD_LOGIC := 'Z';

---- Declaration for Dangling input ----
signal Dangling_Input_Signal : STD_LOGIC;

---- Declarations for Dangling outputs ----
signal DANGLING_U1_S : STD_LOGIC;

begin

----  Component array-instantiations  ----

U1_array: for U1_array_index in 0 to (NP - 1) generate
	U1_array : Fuse_and
		port map(
		I => Dangling_Input_Signal,
		FI => Dangling_Input_Signal,
		S => DANGLING_U1_S,
		FIL => Dangling_Input_Signal
		);
end generate;



---- Dangling input signal assignment ----

Dangling_Input_Signal <= DANGLING_INPUT_CONSTANT;

end PLA;
