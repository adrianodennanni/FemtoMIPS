-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\compile\Ram.vhd
-- Generated   : Mon Dec  3 15:29:34 2012
-- From        : D:\Projetos_VHDL\Projetos_Student\Biblioteca_de_Componentes\src\Ram.bde
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
use std.textio.all;

entity Ram is
  generic(
       BE : integer := 8;
       BP : integer := 16;
       NA : string := "mram.txt";
       Tz : time := 2 ns;
       Twrite : time := 5 ns;
       Tsetup : time := 2 ns;
       Tread : time := 5 ns
  );
  port(
       Clock : in std_logic;
       enable : in STD_LOGIC;
       rw : in std_logic;
       ender : in std_logic_vector(BE - 1 downto 0);
       pronto : out std_logic;
       dado : inout std_logic_vector(BP - 1 downto 0)
  );
end Ram;

architecture Ram of Ram is

---- Architecture declarations -----
type 	tipo_memoria  is array (0 to 2**BE - 1) of std_logic_vector(BP - 1 downto 0);
signal Mram: tipo_memoria := ( others  => (others => '0')) ;


begin

---- Processes ----

Carga_Inicial_e_Ram_Memoria :process (Clock, dado, enable, rw) 
variable endereco: integer range 0 to (2**BE - 1);
variable inicio: std_logic := '1';
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
if inicio = '1' then
	-- Roda somente uma vez na inicialização
	Mram <= fill_memory;
	-- Insere o conteúdo na memória
	inicio := '0';
end if;
if Clock'event and Clock = '1' and enable = '1' then
	if (ender'last_event < Tsetup) or (dado'last_event < Tsetup) then
			dado <= (others => 'X');
	else
		endereco := to_integer(unsigned(ender));
		case rw is
			when '0' => -- Ciclo de Leitura
				dado <= Mram(endereco) after Tread;
				pronto <= '1' after Tread;				 
			when '1' => --Ciclo de Escrita
				Mram(endereco) <= dado after Twrite;
				pronto <= '1' after Twrite;
			when others => -- Ciclo inválido
				Null;
		end case;
	end if;
end if;	
if Clock'event and Clock = '1' and enable = '0' then
--if Clock'event and Clock = '0' then
	pronto <= '0';
	dado <= (others => 'Z') after Tz;
end if;
end process;

end Ram;
