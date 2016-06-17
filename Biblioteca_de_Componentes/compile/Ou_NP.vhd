-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\Ou_NP.vhd
-- Generated   : Wed Nov 21 21:15:46 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\Ou_NP.bde
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


entity Ou_NP is
  generic(
       NP: integer := 4
  );
  port(
       Ss : in std_logic_vector(NP - 1  downto 0);
       S : out std_logic
  );
end Ou_NP;

architecture Ou_NP of Ou_NP is

begin

---- Processes ----

Ou_NP :
process (Ss)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
-- declarations	
variable temp: std_logic := '0';
begin
-- statements
temp := '0';
for j in 0 to NP - 1 loop
	temp := temp or Ss(j);
end loop;
S <= temp;
end process;

end Ou_NP;
