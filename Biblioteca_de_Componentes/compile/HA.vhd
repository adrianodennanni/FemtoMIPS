-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\HA.vhd
-- Generated   : Wed Nov 21 21:15:51 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\HA.bde
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


entity HA is
  generic(
       Tgate: time := 1 ns
  );
  port(
       x : in std_logic;
       y : in std_logic;
       g : out std_logic;
       p : out std_logic
  );
end HA;

architecture HA of HA is

begin

---- User Signal Assignments ----
p <= x xor y after 2*Tgate;
g <= x and y after Tgate;

end HA;
