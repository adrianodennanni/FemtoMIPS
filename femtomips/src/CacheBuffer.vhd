library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity CacheBuffer is
  port(
       Clock : in std_logic; -- Clock do processador
       ender_in : in std_logic_vector(31 downto 0); -- Endereço de entrada do buffer
       dados_in : in std_logic_vector(31 downto 0); -- Dados de entrada do buffer
       pedido_in : in std_logic; -- Recebimento de pedido do cache de dados (Um bit)
       ready : in std_logic; -- Bit que a memória avisa que está pronta para ser gravada

       busy : out std_logic; -- Informação do estado atual, se está ocupado ou não (1 - ocupado, 0 - disponível)
       pedido_out : out std_logic; -- Realizar pedido de escrita para a memória principal
       dados_out : out std_logic_vector(31 downto 0); -- Dados que irão para a memória
       ender_out : out std_logic_vector(31 downto 0) -- Dados que irão para a memória
  );
end CacheBuffer;
