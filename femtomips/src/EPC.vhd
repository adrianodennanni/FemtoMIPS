library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity EPC is
port(
	clk : in std_logic;
	stall : in std_logic;
	IEPC : in std_logic_vector(31 downto 0);
	OEPC : out std_logic_vector(31 downto 0)
);
end EPC;
architecture EPC of EPC is
	signal SEPC : std_logic_vector(31 downto 0) := (others => '0');
begin
		process(clk)
			begin
				if (clk'event and clk = '1' and stall = '0') then
					SEPC <= IEPC;
				end if;
		end process;
		OEPC <= SEPC;
end EPC;