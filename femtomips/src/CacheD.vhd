library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity CacheD is
  port(
       Clock : in std_logic; -- Clock de entrada
       enable : in STD_LOGIC;
       readD, writeD : in std_logic;
       ender : in std_logic_vector(31 downto 0); -- Endereço de memória que entra no cache a partir do processador
       writeDado : in std_logic_vector(31 downto 0);
       dumpMemory : in std_logic; -- Responsável por definir quando será feito um dump da memória
       MAIN_PRONTO : IN std_logic; -- É para a memória avisar que 4 words pedidas a partir do endereço MAIN_END estão disponíveis no MAIN_DATA
       MAIN_DATA : in std_logic_vector(127 downto 0); -- Onde a memória manda os dados
       BUFFER_BUSY : in std_logic; -- Recebe estado de disponível ou ocupado do Buffer de Escrita

       BUFFER_END : out std_logic_vector(31 DOWNTO 0); -- Endereço que o cache quer acessar na memória que irá para o Buffer de Escrita
       BUFFER_DADOS : out std_logic_vector(31 DOWNTO 0); -- Dados que queremos gravar na memória através do Buffer de Escrita
       BUFFER_PEDIDO : out std_logic; -- Pedido para o Buffer
       dado : out std_logic_vector(31 downto 0) := (others => '0');
       CacheD_MISS : out std_logic := '0';
       MAIN_RW : out std_logic := '0';
       MAIN_END : out std_logic_vector(31 DOWNTO 0); -- Endereço que o cache quer acessar na memória
       ENABLE_I : out STD_LOGIC := '0'-- Serve para o cache avisar a memória que quer acessá-la
  );
end CacheD;


architecture CacheDI of CacheD is

-- endereços de 32 bits
-- 2 bits inuteis (Menos significativos)
-- 16 palavras no bloco --> 4 bits para word no bloco
-- 128 pares de blocos --> 7 bits para definir a frame
-- TAG := 32 - 13 = 19 bits
type bloco_type is array(15 downto 0) of std_logic_vector(31 downto 0);
type mem_type is array (255 downto 0) of bloco_type;
signal mem : mem_type := (others => (others => (others => 'X')));

type tags_type is array(255 downto 0) of std_logic_vector(18 downto 0);
signal tags : tags_type := (others => (others => '0'));
signal valids : std_logic_vector(255 downto 0) := (others => '0'); -- Quando vale 0 significa que está limpo, quando vale 1 está sujo
signal LRU : std_logic_vector(127 downto 0) := (others => '0');

type stateType is (ready, le0, b0, le1, b1, le2, b2, le3, b3, bf0, bf1);
signal current_s, next_s : stateType;

signal BUFFER_CONTADOR : integer := 0;

signal auxe : std_logic_vector(7 downto 0) := "00000000";

begin

translate : process(ender)
variable a, ea, eb : integer;
variable va, vb : std_logic_vector(7 downto 0);
begin
  a := to_integer(unsigned(ender(12 downto 6)));
  va := ender(12 downto 6) & LRU(a);
  vb := ender(12 downto 6) & NOT LRU(a);
  ea := to_integer(unsigned(va));
  eb := to_integer(unsigned(vb));
  if (valids(eb) = '1' and tags(eb) = ender(31 downto 13) ) then
    auxe <= vb;
  else
    auxe <= va;
  end if;
end process;

outs : process(clock, next_s, current_s, ender, MAIN_PRONTO,auxe,writeD,readD)
variable aux, aux_b, aux_c : integer;

variable enderc : std_logic_vector(31 downto 0) := (others => '0');
begin
  aux := to_integer(unsigned(auxe));
  --aux_c := to_integer(unsigned(enderc(13 downto 6)));
  CACHED_MISS <= '0';
  MAIN_END <= (OTHERS => '0');
  --MAIN_RW <= '0';
  case current_s is
    when ready =>
      MAIN_END <= (others =>'U');
      if valids(aux) = '1' and tags(aux) = ender(31 downto 13) and readD = '1'  and clock'event and clock = '0' then
        aux_b := to_integer(unsigned(ender(5 downto 2)));
        dado <= mem(aux)(aux_b);
        LRU(aux) <= not (auxe(0));
      elsif valids(aux) = '1' and tags(aux) = ender(31 downto 13) and writeD = '1' and clock'event and clock = '0' then -- Este é o caso que vai ser necessário substituir um bloco
        aux_b := to_integer(unsigned(ender(5 downto 2)));
        BUFFER_CONTADOR <= 15;
        mem(aux)(aux_b) <= writeDado;
        LRU(aux) <= not (auxe(0));
      elsif (readD = '1' or writeD = '1') and clock'event and clock = '0' then
        CACHED_MISS <= '1';
        enderc := ender(31 downto 6) & "000000" ;
        aux_c := aux;
      else
        null;
      end if;
    when le0 =>
        MAIN_END <= enderc;
        CACHED_MISS <= '1';
        ENABLE_I <= '1';
        MAIN_RW <= '1';
        if MAIN_PRONTO = '1' and clock'event and clock = '0' then
          mem(aux_c)(0) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(1) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(2) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(3) <= MAIN_DATA(31 DOWNTO 0);
        END IF;
    when le1 =>
        ENABLE_I <= '1';
        MAIN_END <= enderc + 16;
        CACHED_MISS <= '1';
        MAIN_RW <= '1';
        if MAIN_PRONTO = '1' and clock'event and clock = '0' then
          mem(aux_c)(4) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(5) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(6) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(7) <= MAIN_DATA(31 DOWNTO 0);
        END IF;
    when le2 =>
        MAIN_END <= enderc + 32;
        CACHED_MISS <= '1';
        ENABLE_I <= '1';
        MAIN_RW <= '1';
        if MAIN_PRONTO = '1' and clock'event and clock = '0' then
          mem(aux_c)(8) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(9) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(10) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(11) <= MAIN_DATA(31 DOWNTO 0);
        END IF;
    when le3 =>
        MAIN_END <= enderc + 48;
        CACHED_MISS <= '1';
        ENABLE_I <= '1';
        MAIN_RW <= '1';
        if MAIN_PRONTO = '1' and clock'event and clock = '0' then
          mem(aux_c)(12) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(13) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(14) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(15) <= MAIN_DATA(31 DOWNTO 0);
      END IF;
    when b0 =>
        MAIN_END <= (OTHERS => '0');
        CACHED_MISS <= '1';
        -- ENABLE_I <= 'Z';
    when b1 =>
        MAIN_END <= (OTHERS => '0');
        CACHED_MISS <= '1';
    when b2 =>
        MAIN_END <= (OTHERS => '0');
        CACHED_MISS <= '1';
    when b3 =>
        MAIN_END <= (OTHERS => 'X');
        CACHED_MISS <= '1';

        valids(aux_c) <= '1';
  		  tags(aux_c) <= enderc(31 downto 13);
    when bf0 =>
      if BUFFER_BUSY = '0' then
        BUFFER_PEDIDO <= '1';
        BUFFER_DADOS <= mem(aux_c)(BUFFER_CONTADOR);
        BUFFER_END <= ender(31 downto 4) & std_logic_vector(to_unsigned(BUFFER_CONTADOR, 4));
        BUFFER_CONTADOR <= BUFFER_CONTADOR - 1;
        MAIN_RW <= 'Z';
      end if;

    when others =>
      null;
    end case;
end process;

maintainStates : process(clock, next_s, current_s, ender, MAIN_PRONTO,auxe,writeD,readD)
variable aux : integer;
begin
  if clock'event and clock = '1' then
    current_s <= next_s;
  end if;
  aux := to_integer(unsigned(auxe));
  case current_s is
    when ready =>
		  if valids(aux) = '1' and tags(aux) = ender(31 downto 13) and readD = '1' then
        next_s <= ready;
      elsif valids(aux) = '1' and tags(aux) = ender(31 downto 13) and writeD = '1' then
        next_s <= bf0;
      elsif writeD = '1' or readD = '1' then
        next_s <= le0;
      end if;
    when le0 =>
      if MAIN_PRONTO'event and MAIN_PRONTO ='1' then
        next_s <= b0;
      end if;
    when le1 =>
      if MAIN_PRONTO'event and MAIN_PRONTO ='1' then
        next_s <= b1;
      end if;
    when le2 =>
      if MAIN_PRONTO'event and MAIN_PRONTO ='1' then
        next_s <= b2;
      end if;
    when le3 =>
      if MAIN_PRONTO'event and MAIN_PRONTO ='1' then
        next_s <= b3;
      end if;
    when b0 =>
      next_s <= le1;
    when b1 =>
      next_s <= le2;
    when b2 =>
      next_s <= le3;
    when b3 =>
      next_s <= ready;
    when bf0 =>
      if BUFFER_CONTADOR = 0 then
        next_s <= bf1;
      end if;
    when bf1 =>
      next_s <= ready;
    when others =>
      null;
  end case;
end process;


memoryDump : process(dumpMemory)
variable l : line;
variable xx: std_logic_vector(7 downto 0);
variable yy: std_logic_vector(3 downto 0);
file outfile : text open write_mode is "cdd.txt";
begin
  if (dumpMemory'event and dumpMemory = '1') then

    for i in 1 to 255 loop

      if valids(i) = '1' then
        write(l,"Bloco ");
        write(l,i);
        write(l," válido");
        writeline(outfile, l);

        write(l,"Endereço do bloco: ");
        write(l,  to_bitvector(tags(i))  );
        --write(l,i/2);
        write(l, to_bitvector(std_logic_vector(to_unsigned(i/2, 7)))  );
        write(l,"000000");
        writeline(outfile, l);
        for j in 0 to 15 loop
          write(l,j);
          write(l," ");
          write(l,to_bitvector(mem(i)(j)));
          write(l," ");
  				write(l,to_integer(signed(mem(i)(j))));
          writeline(outfile, l);
        end loop;
      end if;
      --write(l,4*i);
      --write(l," ");
      --write(l,to_bitvector(Mram(4*i)));
      --if 4*i > 124 then
        --write(l," ");
        --write(l,to_integer(signed(Mram(4*i))));
      --end if;
      --writeline(outfile, l);
    end loop;
  end if;
end process;

end CacheDI;







architecture CacheD of CacheD is

  -- Architecture declarations --
  type tipo_memoria  is array (0 to 2**14 - 1) of std_logic_vector(31 downto 0);
  signal Mram: tipo_memoria := ( others  => (others => '0')) ;

  begin

  ---- Processes ----

  Carga_Inicial_e_Ram_Memoria :process (clock, readD, writeD, ender, writeDado)
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

    if writeD = '1' then
      Mram(to_integer(unsigned(ender))) <= writeDado(31 downto 0);
    elsif readD = '1' then
      dado <= Mram(to_integer(unsigned(ender)))	 ;
    end if;
  end process;


  memoryDump : process(dumpMemory)
  variable l : line;
  file outfile : text open write_mode is "cdd.txt";
  begin
  	if (dumpMemory'event and dumpMemory = '1') then

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

end CacheD;
