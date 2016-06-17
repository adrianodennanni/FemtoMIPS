-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Arquivos de programas\Aldec\Active-HDL 8.2\Vlib\Biblioteca_de_Componentes\compile\syncent.vhd
-- Generated   : Thu Aug 26 16:19:58 2010
-- From        : c:\Arquivos de programas\Aldec\Active-HDL 8.2\Vlib\Biblioteca_de_Componentes\src\syncent.bde
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

entity SyncEnt is
  generic(
       NB: integer := 8 
  );
  port(
       R : in std_logic;
       T : in std_logic;
       Ent : in std_logic_vector(NB - 1 downto 0);
       Ents : out std_logic_vector(NB - 1 downto 0)
  );
end SyncEnt;

architecture SyncEnt of SyncEnt is

---- Component declarations -----

component registrador
  generic(
       NumeroBits : INTEGER := 8;
       Tprop : time := 5 ns;
       Tsetup : time := 2 ns
  );
  port (
       C : in STD_LOGIC;
       D : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
       R : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(NumeroBits - 1 downto 0)
  );
end component;

begin

----  Component instantiations  ----

Rsync : registrador
  generic map (
       NumeroBits => NB
  )
  port map(
       C => T,
       D => Ent( NB - 1 downto 0 ),
       Q => Ents( NB - 1 downto 0 ),
       R => R
  );


end SyncEnt;
