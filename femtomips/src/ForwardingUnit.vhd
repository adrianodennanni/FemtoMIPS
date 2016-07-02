library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity ForwardingUnit is
port(

  MEM_WREG_ADDR, WB_WREG_ADDR : IN STD_LOGIC_VECTOR(4 downto 0);
  MEM_WREG_WRITE, WB_WREG_WRITE : IN STD_LOGIC;
  EXE_RS, EXE_RT : IN STD_LOGIC_VECTOR(4 downto 0);

  FORWARD_RS_DECIDE : OUT STD_LOGIC_VECTOR(1 downto 0) := "00";
	FORWARD_RT_DECIDE : OUT STD_LOGIC_VECTOR(1 downto 0) := "00"

);
end ForwardingUnit;

architecture ForwardingUnit of ForwardingUnit is

begin

	process(MEM_WREG_ADDR, WB_WREG_ADDR, MEM_WREG_WRITE, WB_WREG_WRITE, EXE_RS, EXE_RT)
	begin

    FORWARD_RS_DECIDE <= "00";
    FORWARD_RT_DECIDE <= "00";

    IF WB_WREG_WRITE = '1' AND (WB_WREG_ADDR = EXE_RS) AND (NOT (WB_WREG_ADDR = "00000")) then
      FORWARD_RS_DECIDE <= "10";
    END IF;

    IF MEM_WREG_WRITE = '1' AND (MEM_WREG_ADDR = EXE_RS) AND (NOT (MEM_WREG_ADDR = "00000")) then
      FORWARD_RS_DECIDE <= "01";
    END IF;

    IF WB_WREG_WRITE = '1' AND (WB_WREG_ADDR = EXE_RT) AND (NOT (WB_WREG_ADDR = "00000")) then
      FORWARD_RT_DECIDE <= "10";
    END IF;

    IF MEM_WREG_WRITE = '1' AND (MEM_WREG_ADDR = EXE_RT) AND (NOT (MEM_WREG_ADDR = "00000")) then
      FORWARD_RT_DECIDE <= "01";
    END IF;

	end process;

end ForwardingUnit;
