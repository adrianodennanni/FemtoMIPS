-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\Stack.vhd
-- Generated   : Wed Nov 21 21:15:44 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\Stack.bde
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

entity Stack is
  generic(
       NBdado: integer := 8;
       NBend: integer := 4;
       Tpush: time := 5 ns;
       Tpop: time := 5 ns
  );
  port(
       Reset : in std_logic;
       clk : in std_logic;
       push_pop : in std_logic;
       din : in std_logic_vector(NBdado - 1 downto 0);
       dout : out std_logic_vector(NBdado - 1 downto 0)
  );
end Stack;

architecture Stack of Stack is

---- Architecture declarations -----
type ram_type is array (0 to 2**NBend - 1)
        of std_logic_vector (NBdado - 1 downto 0);
signal stack: ram_type;
signal tos: std_logic_vector(NBend - 1 downto 0) := (others => '0');


begin

---- Processes ----

StackMemory :
process (clk, Reset)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
-- declarations	
begin
	if Reset = '1' then
		tos <= (others => '0');
	elsif clk'event and clk = '1' then
		case push_pop is
			when '0' => -- Operação de Push
				tos <= std_logic_vector((unsigned(tos) + 1));
				stack(to_integer(unsigned(tos))) <= din after Tpush;
			when '1' => -- Operação Pop
				dout <= stack(to_integer(unsigned(tos))) after Tpop;
				tos <= std_logic_vector((unsigned(tos) - 1));
			when others => -- Operação nula
				null;
		end case;
	end if;
end process;

end Stack;
