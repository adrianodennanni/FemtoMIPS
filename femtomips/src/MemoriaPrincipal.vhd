library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity MemoriaPrincipal is
  port(
       Clock : in std_logic;
       rw : in std_logic;

       enableI, enableD : in std_logic;
	   enderI, enderD : in std_logic_vector(31 downto 0);
       dadoD_w : in std_logic_vector(127 downto 0);
       dadoI, dadoD_r : out std_logic_vector(127 downto 0);
	   prontoI, prontoD : out std_logic;


	   memDump : in std_logic
  );
end MemoriaPrincipal;

architecture MemoriaPrincipal of MemoriaPrincipal is

-- Architecture declarations --
type tipo_memoria  is array (0 to 2**14 - 1) of std_logic_vector(31 downto 0);
signal Mram: tipo_memoria := ( others  => (others => '0')) ;

type state_type is (liv, esp_I, pro_I, esp_DR, pro_DR, esp_DW, pro_DW);

signal cstate : state_type := liv;
signal nstate : state_type := liv;
signal cnt : integer := 7;

begin

---- Processes ----

Carga_Inicial_e_Ram_Memoria :process (clock)
variable endereco: integer range 0 to (2**14 - 1);
variable inicio: std_logic := '1';

function fill_memory return tipo_memoria is
	type HexTable is array (character range <>) of integer;
	constant lookup: HexTable ('0' to '1') :=
		(0, 1);
	file infile: text open read_mode is "prog.txt"; -- Abre o arquivo para leitura
	variable buff : line;
	variable Mem: tipo_memoria := ( others  => (others => '0')) ;

	variable ind_s, dat_s : bit_vector(31 downto 0);
	variable bchar : character;
	variable dat : std_logic_vector(31 downto 0);
	variable ind : integer;

	begin
		while (not endfile(infile)) loop
			readline(infile,buff);
			read(buff,ind_s);
			read(buff,bchar);
			read(buff,dat_s);
      ind := to_integer(unsigned(To_StdLogicVector(ind_s)));
      dat := To_StdLogicVector(dat_s);
      Mem(ind) := dat;
		end loop;
	return Mem;
end fill_memory;

begin

  if inicio = '1' then
	Mram <= fill_memory;
	inicio := '0';
  end if;

  if clock'event and clock = '1' and cstate = pro_DW then
    Mram(to_integer(unsigned(enderD))) <= dadoD_w(31 downto 0);
  end if;
end process;

maintainStates : process(cnt, enableI, enableD, clock)
begin
	if (clock'event and clock = '1') then
		cstate <= nstate;
		if cstate = esp_I or cstate = esp_DW or cstate = esp_DR then
			cnt <= cnt - 1;
		end if;
	end if;
	case cstate is
		when liv =>
			if enableI = '1' then
				nstate <= esp_I;
			end if;
			if enableD = '1' then
				nstate <= esp_DR;
			end if;
			if enableD = '1' and rw = '0' then
				nstate <= esp_DW;
			end if;
		when esp_I =>
			if cnt = 0 then
				nstate <= pro_I;
			end if;
		when esp_DR =>
			if cnt = 0 then
				nstate <= pro_DR;
			end if;
		when esp_DW =>
			if cnt = 0 then
				nstate <= pro_DW;
			end if;
		when pro_I =>
			if enableI = '0' or enderI'event then
				nstate <= liv;
				cnt <= 7;
			end if;
		when pro_DR =>
			if enableD = '0' or enderD'event then
				nstate <= liv;
				cnt <= 7;
			end if;
		when pro_DW =>
			if enableD = '0' or enderD'event then
				nstate <= liv;
				cnt <= 7;
			end if;
		end case;
end process;

outputs : process(cstate)

	variable ai : integer;
begin
	 dadoI <= (others => '0');
	 dadoD_r <= (others => '0');
	 prontoI <= '0';
	 prontoD <= '0';
	 case cstate is
		when pro_I =>
			prontoI <= '1';
      ai := to_integer(unsigned(enderI));
			dadoI <= Mram(ai) & Mram(ai+4) & Mram(ai+8) & Mram(ai+12);
		when pro_DR =>
	      prontoD <= '1';
	      ai := to_integer(unsigned(enderD));
        --report "aaa" ;
	      dadoD_r <= Mram(ai) & Mram(ai+4) & Mram(ai+8) & Mram(ai+12);
		when pro_DW =>
			prontoD <= '1';
      ai := to_integer(unsigned(enderD));
    when others =>
      null;
	end case;
end process;


memoryDump : process(memDump)
variable l : line;
file outfile : text open write_mode is "md.txt";
begin
	if (memDump'event and memDump = '1') then

		for i in 0 to 2**12-1 loop
			write(l,4*i);
			write(l," ");
			write(l,to_bitvector(Mram(4*i)));
			if 4*i > 124 then
				write(l," ");
				write(l,to_integer(signed(Mram(4*i))));
			end if;
			writeline(outfile, l);
		end loop;
	end if;
end process;

end MemoriaPrincipal;
