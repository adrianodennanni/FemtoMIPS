-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\RegFile.vhd
-- Generated   : Wed Nov 21 21:15:45 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\RegFile.bde
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
use ieee.numeric_std.all;

entity RegFile is
  generic(
       NBend: integer := 4;
       NBdado: integer := 8;
       Tread: time := 5 ns;
       Twrite: time := 5 ns
  );
  port(
       clk : in std_logic;
       we : in std_logic;
       dadoina : in std_logic_vector(NBdado - 1 downto 0);
       enda : in std_logic_vector(NBend - 1 downto 0);
       dadoouta : out std_logic_vector(NBdado - 1 downto 0)
  );
end RegFile;

architecture RegFile of RegFile is

---- Architecture declarations -----
type ram_type is array (0 to 2**NBend - 1)
        of std_logic_vector (NBdado - 1 downto 0);
signal ram: ram_type;


---- Signal declarations used on the diagram ----

signal enda_reg : std_logic_vector (NBend - 1 downto 0);

begin

---- Processes ----

RegisterMemory :
process (clk)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
-- declarations
begin
	 if (clk'event and clk = '1') then
        if (we = '1') then
           ram(to_integer(unsigned(enda))) <= dadoina after Twrite;
        end if;
        enda_reg <= enda;
     end if;
end process;

---- User Signal Assignments ----
dadoouta <= ram(to_integer(unsigned
								(enda_reg))) after Tread;

end RegFile;
