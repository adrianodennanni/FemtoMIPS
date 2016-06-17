-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Pedro
-- Company     : LARC
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\teste.vhd
-- Generated   : Mon Nov 28 16:46:34 2011
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\teste.bde
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
library BIBLIOTECA_DE_COMPONENTES;

entity teste is
  port(
       BusInput0 : in STD_LOGIC_VECTOR(7 downto 0);
       Output0 : out STD_LOGIC
  );
end teste;

architecture teste of teste is

---- Component declarations -----

component Ou_NP
  generic(
       NP : integer := 4
  );
  port (
       Ss : in STD_LOGIC_VECTOR(NP - 1 downto 0);
       S : out STD_LOGIC
  );
end component;
component rom
  generic(
       BE : integer := 8;
       BP : integer := 16;
       NA : string := "mrom.txt";
       Tacesso : time := 5 ns
  );
  port (
       ender : in STD_LOGIC_VECTOR(BE - 1 downto 0);
       dado : out STD_LOGIC_VECTOR(BP - 1 downto 0)
  );
end component;

---- Signal declarations used on the diagram ----

signal dado : std_logic_vector (51 downto 0);
signal endereco : std_logic_vector (7 downto 0);

begin

----  Component instantiations  ----

U1 : rom
  generic map (
       BE => 8,
       BP => 52,
       NA => "mrom_test.txt"
  )
  port map(
       dado => dado( 51 downto 0 ),
       ender => endereco( 7 downto 0 )
  );

U2 : Ou_NP
  generic map (
       NP => 52
  )
  port map(
       S => Output0,
       Ss => dado( 51 downto 0 )
  );


---- Terminal assignment ----

    -- Inputs terminals
	endereco <= BusInput0;


end teste;
