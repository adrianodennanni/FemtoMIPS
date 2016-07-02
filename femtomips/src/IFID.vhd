library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity IFID is
port(
	clk : in std_logic;
	stall : in std_logic;
	flush : in std_logic;
	reset : in std_logic;


	I_INST : IN std_logic_vector(31 downto 0);
	I_PC : IN std_logic_vector(31 downto 0);


	O_INST : OUT std_logic_vector(31 downto 0) := (OTHERS => '0');
	O_PC : OUT std_logic_vector(31 downto 0) := (OTHERS => '0')


);
end IFID;

architecture IFID of IFID is
begin

	process(clk,reset)
	begin
		if (reset = '1' or (clk'event and clk = '1' and flush = '1')) then

			O_INST <= (OTHERS => '0');
			O_PC  <= (OTHERS => '0');
		elsif (clk'event and clk = '1' and stall = '0') then

			O_INST <= I_INST;
			O_PC <= I_PC;
		end if;
	end process;

end IFID;
