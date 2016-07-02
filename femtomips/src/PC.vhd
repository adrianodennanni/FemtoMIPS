library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity PC is
port(
	clk : in std_logic;
	stall : in std_logic;
	reset : in std_logic;

	IPC : in std_logic_vector(31 downto 0);
	OPC : out std_logic_vector(31 downto 0) := (OTHERS => '0')
);
end PC;
architecture PC of PC is


begin
		process(clk, reset)
		begin
			if (reset = '1') then
				OPC <= (others => '0');
			elsif (clk'event and clk = '1' and stall = '0') then
				OPC <= IPC;
			end if;
		end process;
end PC;
