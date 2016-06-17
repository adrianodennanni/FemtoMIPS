-------------------------------------------------------------------------------
--
-- Title       : Unidade Funcional Subtrator - Projeto Raiz Quadrada
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\subtrator.vhd
-- Generated   : Wed Nov 21 21:17:24 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\subtrator.bde
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

entity subtrator is
  generic(
       NumeroBits : integer := 8;
       Tsub : time := 3 ns
  );
  port(
       In1 : in std_logic_vector(numeroBits - 1 downto 0);
       In2 : in std_logic_vector(numeroBits - 1 downto 0);
       Out1 : out std_logic_vector(numeroBits - 1 downto 0)
  );
end subtrator;

architecture subtrator of subtrator is

begin

---- User Signal Assignments ----
Out1 <= (In1 - In2) after Tsub;

end subtrator;
