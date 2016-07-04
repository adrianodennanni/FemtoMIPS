library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity CacheI is
  port(
       Clock : in std_logic;
       enable : in STD_LOGIC;
       rw : out std_logic := '1';
       ender : in std_logic_vector(31 downto 0);
       dado : out std_logic_vector(31 downto 0);
       CACHEI_MISS : out std_logic := '0'; -- sinal indicando ao processsador que ocorreu um miss
       MAIN_DATA : in std_logic_vector(127 downto 0);
       MAIN_END : OUT std_logic_vector(31 DOWNTO 0);
       ENABLE_I : OUT STD_LOGIC;
       MAIN_PRONTO : IN std_logic
  );
end CacheI;

architecture CacheI of CacheI is

-- endereços de 32 bits
-- 2 bits inuteis
-- 16 palavras no bloco --> 4 bits para word no bloco
-- 256 blocos --> 8 bits para definir a frame
-- tag := 32 - 14 = 18 bits
type bloco_type is array(15 downto 0) of std_logic_vector(31 downto 0);
type mem_type is array (255 downto 0) of bloco_type;
signal mem : mem_type := (others => (others => (others => 'X')));

type tags_type is array(255 downto 0) of std_logic_vector(17 downto 0);
signal tags : tags_type := (others => (others => '0'));
signal valids : std_logic_vector(255 downto 0) := (others => '0');

type stateType is (ready, le0, b0, le1, b1, le2, b2, le3, b3);
signal current_s, next_s : stateType;

begin

outs : process(current_s, ender, MAIN_PRONTO)
variable aux, aux_b, aux_c : integer;

variable enderc : std_logic_vector(31 downto 0) := (others => '0');
begin
  aux := to_integer(unsigned(ender(13 downto 6)));
  aux_c := to_integer(unsigned(enderc(13 downto 6)));
  CACHEI_MISS <= '0';
  ENABLE_I <= '0';
  MAIN_END <= (OTHERS => '0');
  case current_s is
    when ready =>
      MAIN_END <= (others =>'U');
      if valids(aux) = '1' and tags(aux) = ender(31 downto 14) then
        aux_b := to_integer(unsigned(ender(5 downto 2)));
        dado <= mem(aux)(aux_b);
      else
        CACHEI_MISS <= '1';
        enderc := ender(31 downto 6) & "000000";
      end if;
    when le0 =>
        MAIN_END <= enderc;
        CACHEI_MISS <= '1';
        ENABLE_I <= '1';
        if MAIN_PRONTO = '1' then
          mem(aux_c)(0) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(1) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(2) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(3) <= MAIN_DATA(31 DOWNTO 0);
        END IF;
    when le1 =>
        ENABLE_I <= '1';
        MAIN_END <= enderc + 16;
        CACHEI_MISS <= '1';
        if MAIN_PRONTO = '1' then
          mem(aux_c)(4) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(5) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(6) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(7) <= MAIN_DATA(31 DOWNTO 0);
        END IF;
    when le2 =>
        MAIN_END <= enderc + 32;
        CACHEI_MISS <= '1';
        ENABLE_I <= '1';
        if MAIN_PRONTO = '1' then
          mem(aux_c)(8) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(9) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(10) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(11) <= MAIN_DATA(31 DOWNTO 0);
        END IF;
    when le3 =>
        MAIN_END <= enderc + 48;
        CACHEI_MISS <= '1';
        ENABLE_I <= '1';
        if MAIN_PRONTO = '1' then
          mem(aux_c)(12) <= MAIN_DATA(127 DOWNTO 96);
          mem(aux_c)(13) <= MAIN_DATA(95 DOWNTO 64);
          mem(aux_c)(14) <= MAIN_DATA(63 DOWNTO 32);
          mem(aux_c)(15) <= MAIN_DATA(31 DOWNTO 0);

      END IF;
    when b0 =>
        MAIN_END <= (OTHERS => '0');
        CACHEI_MISS <= '1';
    when b1 =>
        MAIN_END <= (OTHERS => '0');
        CACHEI_MISS <= '1';
    when b2 =>
        MAIN_END <= (OTHERS => '0');
        CACHEI_MISS <= '1';
    when b3 =>
        MAIN_END <= (OTHERS => 'X');
        CACHEI_MISS <= '1';

        valids(aux_c) <= '1';
  		  tags(aux_c) <= enderc(31 downto 14);

    when others =>
      null;
    end case;
end process;

maintainStates : process(clock, next_s, current_s, ender, MAIN_PRONTO)
variable aux : integer;
begin
  if clock'event and clock = '1' then
    current_s <= next_s;
  end if;
  --next_s <= current_s;
  aux := to_integer(unsigned(ender(13 downto 6)));
  case current_s is
    when ready =>
      if valids(aux) = '1' and tags(aux) = ender(31 downto 14) then
        next_s <= ready;
      else
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
    when others =>
      null;
  end case;
end process;



end CacheI;
