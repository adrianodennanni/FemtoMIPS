-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\buffertristate.vhd
-- Generated   : Wed Nov 21 21:15:50 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\buffertristate.bde
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


entity bufferTristate is
  generic(
       NumeroBits : integer := 8;
       Tenable : time := 1 ns;
       Tdisable : time := 2 ns
  );
  port(
       Oe : in std_logic;
       I : in std_logic_vector(NumeroBits - 1 downto 0);
       O : out std_logic_vector(NumeroBits - 1 downto 0)
  );
end bufferTristate;

architecture bufferTristate of bufferTristate is

begin

---- User Signal Assignments ----
O <= I 			      			after Tenable when Oe = '1' else		-- Porta aberta
		   (others => 'Z') 	after Tdisable;		    								-- Porta em alta impedância

end bufferTristate;
