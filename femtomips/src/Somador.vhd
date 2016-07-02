library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity Somador is
port(
	in1 : in std_logic_vector(31 downto 0);
	in2 : in std_logic_vector(31 downto 0);
	sai : out std_logic_vector(31 downto 0)
);
end Somador;
architecture Somador of Somador is
begin
	sai <= std_logic_vector(signed(in1)+signed(in2));
end Somador;