-------------------------------------------------------------------------------
--
-- Title       : Fusivel
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\Fuse_and.vhd
-- Generated   : Wed Nov 21 21:15:47 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\Fuse_and.bde
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


entity Fuse is
  port(
       FI : in std_logic;
       FIL : in std_logic;
       I : in std_logic;
       S : out std_logic
  );
end Fuse;

architecture Fuse of Fuse is

---- Signal declarations used on the diagram ----

signal IL : std_logic;
signal IL_F : std_logic;
signal I_F : std_logic;

begin

----  Component instantiations  ----

IL <= not(I);

IL_F <= not(FIL) or IL;

S <= I_F and IL_F;

I_F <= not(FI) or I;


end Fuse;
