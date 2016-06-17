-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\Mux8x1.vhd
-- Generated   : Wed Nov 21 21:15:46 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\Mux8x1.bde
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


entity Mux8x1 is
  generic(
       NB: integer := 8;
       Tsel: time := 3 ns;
       Tdata: time := 2 ns
  );
  port(
       I0 : in std_logic_vector(NB - 1 downto 0);
       I1 : in std_logic_vector(NB - 1 downto 0);
       I2 : in std_logic_vector(NB - 1 downto 0);
       I3 : in std_logic_vector(NB - 1 downto 0);
       I4 : in std_logic_vector(NB - 1 downto 0);
       I5 : in std_logic_vector(NB - 1 downto 0);
       I6 : in std_logic_vector(NB - 1 downto 0);
       I7 : in std_logic_vector(NB - 1 downto 0);
       Sel : in std_logic_vector(2 downto 0);
       O : out std_logic_vector(NB - 1 downto 0)
  );
end Mux8x1;

architecture Mux8x1 of Mux8x1 is

begin

---- Processes ----

Mux8x1 :
process (I0, I1, I2, I3, I4, I5, I6, I7, Sel)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
variable Delay: time := 0 ns;
begin
	If (Sel'event) then 
		Delay := Tsel;
	else
		Delay := Tdata;
	end if;
	case Sel is
		when "000" 	=> O <= I0 				after Delay;
		when "001" 	=> O <= I1 				after Delay;
		when "010"	=> O <= I2				after Delay;
		when "011"	=> O <= I3				after Delay;
		when "100"	=> O <= I4				after Delay;
		when "101"	=> O <= I5				after Delay;
		when "110"	=> O <= I6				after Delay;
		when "111"	=> O <= I7				after Delay;
		when others => O <= (others => 'X') after Delay;
	end case;
end process;

end Mux8x1;
