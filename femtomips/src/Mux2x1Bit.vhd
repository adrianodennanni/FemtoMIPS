library IEEE;
use IEEE.std_logic_1164.all;


entity Mux2x1Bit is
  port(
       I0 : in std_logic;
       I1 : in std_logic;
       Sel : in std_logic;
       O : out std_logic
  );
end Mux2x1Bit;

architecture Mux2x1Bit of Mux2x1Bit is

begin
				   

Mux2x1Bit :
process (I0, I1, Sel)
begin
	case Sel is
		when '0' 	=> O <= I0 				;
		when '1' 	=> O <= I1 				;
		when others => O <= 'X' 			;
	end case;
end process;

end Mux2x1Bit;
