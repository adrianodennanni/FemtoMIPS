-------------------------------------------------------------------------------
--
-- Title       : Deslocador à Direita de 1 bit - Raiz Quadrada
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\deslocad1.vhd
-- Generated   : Wed Nov 21 21:15:47 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\deslocad1.bde
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity DeslocaD1 is
  generic(
       NumeroBits: integer := 8;
       Tdesl1 : time := 1 ns
  );
  port(
       In1 : in std_logic_vector(numeroBits - 1 downto 0);
       Out1 : out std_logic_vector(numeroBits - 1 downto 0)
  );
end DeslocaD1;

architecture DeslocaD1 of DeslocaD1 is

begin

---- User Signal Assignments ----
Out1  <= '0' & In1(NumeroBits - 1 downto 1) after Tdesl1;

end DeslocaD1;
