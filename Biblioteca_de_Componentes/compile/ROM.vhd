-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\ROM.vhd
-- Generated   : Mon Dec  3 15:29:34 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\ROM.bde
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
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use ieee.math_real.all;
use std.textio.all;

entity ROM is
  generic(
       BE : integer := 8;
       BP : integer := 16;
       Tacesso : time := 5 ns;
       NA : string := "mrom.txt"
  );
  port(
       ender : in std_logic_vector(BE - 1 downto 0);
       dado : out std_logic_vector(BP - 1 downto 0)
  );
end ROM;

architecture ROM of ROM is

---- Architecture declarations -----
type tipo_memoria  is array (0 to 2**BE - 1) of std_logic_vector(BP - 1 downto 0);
signal mrom: tipo_memoria := (others => (others => '0'));
signal endereco: integer := 0;


begin

---- Processes ----

Carga_inicial :process -- Roda somente uma vez na inicialização
function fill_memory return tipo_memoria is
	type HexTable is array (character range <>) of integer;
	-- Caracteres HEX válidos: o, 1, 2 , 3, 4, 5, 6, 6, 7, 8, 9, A, B, C, D, E, F  (somente caracteres maiúsculos)
	constant lookup: HexTable ('0' to 'F') :=
		(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -1, -1, -1, -1, -1, -1, -1, 10, 11, 12, 13, 14, 15);
	file infile: text open read_mode is NA; -- Abre o arquivo para leitura
	variable buff: line; 
	variable addr_s: string ((BE/4 + 1) downto 1); -- Digitos de endereço mais um espaço
	variable data_s: string ((BP/4 + 1) downto 1); -- ùltimo byte sempre tem um espaço separador
	variable addr_1, pal_cnt: integer;
	variable data: std_logic_vector((BP - 1) downto 0);
	variable Mem: tipo_memoria := ( others  => (others => '0')) ;
	begin
		while (not endfile(infile)) loop
			readline(infile,buff); -- Lê um linha do infile e coloca no buff
			read(buff, addr_s); -- Leia o conteudo de buff até encontrar um espaço e atribui à addr_s, ou seja, leio o endereço
			read(buff, pal_cnT); -- Leia o número de bytes da próxima linha
			-- addr_1 := lookup(addr_s(4)) * 4096 + lookup(addr_s(3)) * 256 + lookup(addr_s(2)) * 16 + lookup(addr_s(1));
			addr_1 := 0;
			for i in (BE/4 + 1) downto 2 loop
				addr_1 := addr_1 + lookup(addr_s(i))*16**(i - 2);
			end loop;
			readline(infile, buff);
			for i in 1 to pal_cnt loop
				read(buff, data_s); -- Leia dois dígitos Hex e o espaço separador
				-- data := lookup(data_s(3)) * 16 + lookup(data_s(2)); -- Converte o valor lido em Hex para inteiro
				data := (others => '0');
				report data_s;
				for i in (BP/4 + 1) downto 2 loop
					data := data + lookup(data_s(i))*16**(i-2);
				end loop;
				Mem(addr_1) := data; -- Converte o conteúdo da palavra para std_logic_vector
				addr_1 := addr_1 + 1;	-- Endereça a próxima palavra a ser carregada
			end loop;
		end loop;
	return Mem;
end fill_memory;
begin
	mrom <= fill_memory;
	-- Insere o conteúdo na memória
	wait;
end process;

---- User Signal Assignments ----
dado <= mrom(to_integer(unsigned(ender))) after Tacesso;

end ROM;
