library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity HazardUnit is
port(
  INTERRUPT_SIGNAL, INTERRUPT_SOURCE, BDECIDE_DATA : IN STD_LOGIC;
  CACHEI_MISS, CACHED_MISS : IN STD_LOGIC;
  EXE_MEM_READ : IN STD_LOGIC;
  IDE_INST, EXE_INST : IN STD_LOGIC_VECTOR(31 downto 0);

  FLUSH_IFID : OUT STD_LOGIC := '0';
  FLUSH_IDEXE : OUT STD_LOGIC := '0';
  FLUSH_EXEMEM : OUT STD_LOGIC := '0';
  FLUSH_MEMWB : OUT STD_LOGIC := '0';
  STALL_IFID : OUT STD_LOGIC := '0';
  STALL_IDEXE : OUT STD_LOGIC := '0';
  STALL_EXEMEM : OUT STD_LOGIC := '0';
  STALL_MEMWB : OUT STD_LOGIC := '0';
  STALL_PC : OUT STD_LOGIC := '0'

);
end HazardUnit;

architecture HazardUnit of HazardUnit is
begin

	process(INTERRUPT_SIGNAL, BDECIDE_DATA, CACHEI_MISS, CACHED_MISS,EXE_MEM_READ, IDE_INST, EXE_INST)
	begin
    FLUSH_IFID <= '0';
    FLUSH_IDEXE <= '0';
    FLUSH_EXEMEM <= '0';
    FLUSH_MEMWB <= '0';
    STALL_IFID <= '0';
    STALL_IDEXE <= '0';
    STALL_EXEMEM <= '0';
    STALL_MEMWB <= '0';
    STALL_PC <= '0';

	IF CACHEI_MISS = '1' then
    STALL_PC <= '1';
    FLUSH_IFID <= '1';
  END IF;

  IF CACHED_MISS = '1' then
    STALL_PC <= '1';
    STALL_IFID <= '1';
    STALL_IDEXE <= '1';
    STALL_EXEMEM <= '1';
    STALL_MEMWB <= '1';
  END IF;

  IF EXE_MEM_READ = '1' AND (EXE_INST(20 downto 16) = IDE_INST(20 downto 16) OR EXE_INST(20 downto 16) = IDE_INST(25 downto 21)) AND CACHED_MISS = '0' then
    STALL_PC <= '1';
    STALL_IFID <= '1';
    FLUSH_IDEXE <= '1';
  END IF;

  IF INTERRUPT_SIGNAL = '1' then
    IF INTERRUPT_SOURCE = '0' then
      FLUSH_IDEXE <= '1';
    ELSE
      FLUSH_IDEXE <= '1';
      FLUSH_EXEMEM <= '1';
    END IF;
  END IF;

  IF BDECIDE_DATA = '1' then
    FLUSH_IFID <= '1';
    FLUSH_IDEXE <= '1';
    FLUSH_EXEMEM <= '1';
  end if;

	end process;

end HazardUnit;
