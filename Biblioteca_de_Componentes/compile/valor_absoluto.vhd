-------------------------------------------------------------------------------
--
-- Title       : Unidade Funcional: Valor Absoluto - Raiz Quadrada
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\valor_absoluto.vhd
-- Generated   : Wed Nov 21 21:15:42 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\valor_absoluto.bde
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

entity valor_absoluto is
  generic(
       numeroBits : integer := 8;
       Tabs : time := 2 ns
  );
  port(
       In1 : in std_logic_vector(numeroBits - 1 downto 0);
       Out1 : out std_logic_vector(numeroBits - 1 downto 0)
  );
end valor_absoluto;

architecture valor_absoluto of valor_absoluto is

begin

---- User Signal Assignments ----
Out1 <= In1 			after Tabs when In1(NumeroBits - 1) = '0' else
					(not In1) + '1'	 after Tabs;

end valor_absoluto;
