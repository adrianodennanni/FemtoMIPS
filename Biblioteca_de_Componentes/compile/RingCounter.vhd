-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\RingCounter.vhd
-- Generated   : Mon Dec  3 15:31:38 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\RingCounter.bde
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


-- active library clause
library Biblioteca_de_Componentes;

entity RingCounter is
  generic(
       NB : integer := 1
  );
  port(
       Clk : in std_logic;
       R : in std_logic;
       T0 : out std_logic;
       T1 : out std_logic
  );
end RingCounter;

architecture RingCounter of RingCounter is

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
       S : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(NumeroBits - 1 downto 0)
  );
end component;

----     Constants     -----
constant GND_CONSTANT   : STD_LOGIC := '0';

---- Signal declarations used on the diagram ----

signal GND : STD_LOGIC;
signal sQ1 : std_logic_vector (NB - 1 downto 0);
signal sQ2 : std_logic_vector (NB - 1 downto 0);
signal sQ3 : std_logic_vector (NB - 1 downto 0);
signal sQ4 : std_logic_vector (NB - 1 downto 0);

begin

----  Component instantiations  ----

Q1 : registrador
  generic map (
       NumeroBits => NB,
       Tprop => 3 ns,
       Tsetup => 1 ns
  )
  port map(
       C => Clk,
       D => sQ4( NB - 1 downto 0 ),
       Q => sQ1( NB - 1 downto 0 ),
       R => GND,
       S => R
  );

Q2 : registrador
  generic map (
       NumeroBits => NB,
       Tprop => 3 ns,
       Tsetup => 1 ns
  )
  port map(
       C => Clk,
       D => sQ1( NB - 1 downto 0 ),
       Q => sQ2( NB - 1 downto 0 ),
       R => GND,
       S => R
  );

Q3 : registrador
  generic map (
       NumeroBits => NB,
       Tprop => 3 ns,
       Tsetup => 1 ns
  )
  port map(
       C => Clk,
       D => sQ2( NB - 1 downto 0 ),
       Q => sQ3( NB - 1 downto 0 ),
       R => R,
       S => GND
  );

Q4 : registrador
  generic map (
       NumeroBits => NB,
       Tprop => 3 ns
  )
  port map(
       C => Clk,
       D => sQ3( NB - 1 downto 0 ),
       Q => sQ4( NB - 1 downto 0 ),
       R => R,
       S => GND
  );


---- Power , ground assignment ----

GND <= GND_CONSTANT;

---- Terminal assignment ----

    -- Output\buffer terminals
	T0 <= sQ2(0);
	T1 <= sQ3(0);


end RingCounter;
