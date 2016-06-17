-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Biblioteca_de_Componentes\Biblioteca_de_Componentes\compile\RingCnt.vhd
-- Generated   : Tue Nov 25 18:38:05 2008
-- From        : c:\My_Designs\Biblioteca_de_Componentes\Biblioteca_de_Componentes\src\RingCnt.bde
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


-- other libraries declarations
library Biblioteca_de_Componentes;

entity RingCnt is
  generic(
       Ciclo: time := 100 ns; 
       NB: integer := 4; 
       Nums:  integer := 1 
  );
  port(
       R : in std_logic
  );
end RingCnt;

architecture RingCnt of RingCnt is

---- Component declarations -----

component registrador
  generic(
       NumeroBits : INTEGER := 8;
       Tprop : time := 5 ns;
       Tsetup : time := 2 ns
  );
  port (
       C : in STD_LOGIC;
       D : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
       R : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(NumeroBits - 1 downto 0)
  );
end component;

---- Architecture declarations -----
signal DB: std_logic_vector(NB - 1 downto 0);
signal QB: std_logic_vector(NB - 1 downto 0);


---- Signal declarations used on the diagram ----

signal Clk : std_logic;
signal BUS591 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS597 : STD_LOGIC_VECTOR (7 downto 0);

begin

---- Processes ----

Gerador :
process
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
-- declarations
begin
Clk <= not Clk;
wait for Ciclo/2;
end process;

---- User Signal Assignments ----
Q(NumeroBits - 1)(U1_array_index) <= DB(U1_array_index + 1 mod NB);
D(NUmeroBits - 1)(U1_array_index) <= QB(U1_array_index - 1 mod NB);

----  Component array-instantiations  ----

U1_array: for U1_array_index in 0 to (NB - 1) generate
	U1_array : registrador
		generic map(
		NumeroBits => 1
		)
		port map(
		R => R,
		C => Clk,
		Q => BUS591(0 - (NumeroBits - 1 - 0 + 1) * U1_array_index downto (0 + 1) - (NumeroBits - 1 - 0 + 1) * (U1_array_index + 1)),
		D => BUS597(0 - (NumeroBits - 1 - 0 + 1) * U1_array_index downto (0 + 1) - (NumeroBits - 1 - 0 + 1) * (U1_array_index + 1))
		);
end generate;



end RingCnt;
