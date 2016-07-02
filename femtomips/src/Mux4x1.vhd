library IEEE;
use IEEE.std_logic_1164.all;


entity Mux4x1 is
  port(
       I0 : in std_logic_vector(31 downto 0);
       I1 : in std_logic_vector(31 downto 0);
	     I2 : in std_logic_vector(31 downto 0);
       I3 : in std_logic_vector(31 downto 0);
       Sel0 : in std_logic;
	     Sel1 : in std_logic;
       O : out std_logic_vector(31 downto 0)
  );
end Mux4x1;

architecture Mux4x1 of Mux4x1 is
signal sel : std_logic_vector(0 to 1);
begin

sel <= Sel1 & Sel0;

Mux4x1 :
process (I0, I1, Sel)
begin
	case Sel is
		when "00" 	=> O <= I0 				;
		when "01" 	=> O <= I1 				;
		when "10" 	=> O <= I2 				;
		when "11" 	=> O <= I3 				;
		when others => O <= (others => 'X') ;
	end case;
end process;

end Mux4x1;
