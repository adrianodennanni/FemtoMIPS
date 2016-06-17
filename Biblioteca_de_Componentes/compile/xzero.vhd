-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\xzero.vhd
-- Generated   : Wed Nov 21 21:15:42 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\xzero.bde
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


entity xzero is
  generic(
       NBE: integer := 8;
       NBS: integer := 16
  );
  port(
       I : in std_logic_vector(NBE - 1 downto 0);
       O : out std_logic_vector(NBS - 1 downto 0)
  );
end xzero;

architecture xzero of xzero is

begin

---- User Signal Assignments ----
O(NBE - 1 downto 0) <= I(NBE - 1 downto 0);
O(NBS - 1 downto NBE) <= (others => '0');

end xzero;
