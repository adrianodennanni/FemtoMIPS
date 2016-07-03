library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity CacheBuffer is
  port(
       Clock : in std_logic; -- Clock do processador
       ender_in : in std_logic_vector(31 downto 0); -- Endereço de entrada do buffer (do cache para o buffer)
       dados_in : in std_logic_vector(31 downto 0); -- Dados de entrada do buffer
       pedido_in : in std_logic; -- Recebimento de pedido do cache de dados (Um bit)
       ready_in : in std_logic; -- Bit que a memória avisa que está os dados foram gravados

       busy : out std_logic; -- Informação do estado atual, se está ocupado ou não (1 - ocupado, 0 - disponível)
       pedido_out : out std_logic; -- Realizar pedido de escrita para a memória principal
       dados_out : out std_logic_vector(127 downto 0) := (others => '0'); -- Dados que irão para a memória
       ender_out : out std_logic_vector(31 downto 0) -- Dados que irão para a memória
  );
end CacheBuffer;

architecture CacheBuffer of CacheBuffer is

  signal palavra : std_logic_vector(31 downto 0) := (others => '0'); -- Sinal utilizado para armazenar a palavra que está presente no Buffer
  signal endereco : std_logic_vector(31 downto 0) := (others => '0'); -- Sinal utilizado para armazenar o endereço da memória que o dado pertence
  type stateType is (e0, e1, e2); -- Definição dos tipos de estado
  signal current_s, next_s : stateType; -- Estado atual, próximo estado

begin

  Carregar_Dado_Buffer :process (current_s, Clock, ender_in)
  begin
    case current_s is
      when e0 =>
        busy <= '0';
        pedido_out <= 'Z';
      when e1 => -- Nesse estado, salvamos no Buffer os valores recebidos em dado_in e ender_in
        if pedido_in = '1' and Clock'event and Clock = '0' then
          endereco <= ender_in;
          palavra <= dados_in;
          busy <= '1';
        end if;
      when e2 =>
        if ready_in = '1' and Clock'event and Clock = '0' then
          dados_out(31 downto 0) <= palavra;
          ender_out <= endereco;
          pedido_out <= '1';
        end if;
    end case;

  end process;


  maintainStates : process(Clock, next_s, current_s)
  variable aux : integer;
  begin
    if Clock'event and Clock = '1' then
      current_s <= next_s;
    end if;

    case current_s is
      when e0 =>
        next_s <= e1;
      when e1 =>
        if pedido_in'event and pedido_in = '1' then
          next_s <= e2;
        end if;
      when e2 =>
        if ready_in'event and ready_in = '1' then
          next_s <= e0;
        end if;
      when others =>
        null;
    end case;
  end process;

end CacheBuffer;
