-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\contador.vhd
-- Generated   : Wed Nov 21 21:15:50 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\contador.bde
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity contador is
  generic(
       NB: integer := 8;
       Tsetup: time := 2 ns;
       Tcarga: time := 5 ns;
       Tcount: time := 3 ns
  );
  port(
       C : in std_logic;
       LC : in std_logic;
       R : in std_logic;
       UD : in std_logic;
       D : in std_logic_vector(NB - 1 downto 0);
       U : out std_logic;
       Z : out std_logic;
       Q : out std_logic_vector(NB - 1 downto 0)
  );
end contador;

architecture contador of contador is

---- Architecture declarations -----
constant Zero: std_logic_vector(NB - 1 downto 0) := (others => '0');
constant TudoUm : std_logic_vector(NB - 1 downto 0) := (others => '1');


---- Signal declarations used on the diagram ----

signal Qi : std_logic_vector (NB - 1 downto 0);

begin

---- Processes ----

count :
process (C, R)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
begin 
	if R = '1' then
		Qi <= (others => '0') after Tcarga; -- Reset do contador
	elsif c'event and c = '1' then	-- Atua na borda de subida
		
		case LC is
			when '0' => -- Carrega
				if D'last_event < Tsetup then -- Violação de Set-up time
					Qi <= (others => 'X') after Tcarga;
				else
					Qi <= D after Tcarga;
				end if;
			when '1' => -- Conta
				case UD is
					when '0' => -- Conta para cima
						Qi <= (Qi + 1) after Tcount;
					when '1' => -- Conta para baixo
						Qi <= (Qi - 1) after Tcount;
					when others => -- Situação de erro
						Qi <= Qi;
				end case;
			when others => -- Situação de eroo
				Qi <= Qi;
		end case;
	end if;	
end process;

---- User Signal Assignments ----
Q <= Qi;
Z <= '1' after  Tcount when Qi = Zero else
			'0' after Tcount;
U <= '1' after Tcount when Qi = TudoUm   else
			'0' after Tcount;

end contador;
