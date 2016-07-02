
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity GPR is
  port(
       clk : in std_logic;
       we : in std_logic;
       WriteData : in std_logic_vector(31 downto 0);
	     WriteEnd : in std_logic_vector(4 downto 0);
       Rs : in std_logic_vector(4 downto 0);
       Rt : in std_logic_vector(4 downto 0);
       GPRRs : out std_logic_vector(31 downto 0);
       GPRRt : out std_logic_vector(31 downto 0);
       R0, R1, R2, R3, R4, R5, R6, R7 : OUT std_logic_vector(31 downto 0)
  );
end GPR;

architecture GPR of GPR is

type ram_type is array (0 to 7)
        of std_logic_vector (31 downto 0);
signal ram: ram_type := (others => (others => '0'));



signal EndRs : std_logic_vector (4 downto 0);
signal EndRt : std_logic_vector (4 downto 0);

begin

R0 <= ram(0);
R1 <= ram(1);
R2 <= ram(2);
R3 <= ram(3);
R4 <= ram(4);
R5 <= ram(5);
R6 <= ram(6);
R7 <= ram(7);

RegisterMemory :
process (clk)
begin
	 if (clk'event and clk = '0' and we = '1' and not (WriteEnd = "00000")) then
          ram(to_integer(unsigned(WriteEnd))) <= WriteData;
    end if;
end process;


	GPRRs <= ram(to_integer(unsigned(Rs(2 downto 0))));
	GPRRt <= ram(to_integer(unsigned(Rt(2 downto 0))));


end GPR;
