-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\fuse_ou.vhd
-- Generated   : Wed Nov 21 21:15:52 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\fuse_ou.bde
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


entity fuse_ou is
  port(
       Fp : in std_logic;
       P : in std_logic;
       Ss : out std_logic
  );
end fuse_ou;

architecture fuse_ou of fuse_ou is

begin

---- User Signal Assignments ----
Ss <= P and Fp;

end fuse_ou;
