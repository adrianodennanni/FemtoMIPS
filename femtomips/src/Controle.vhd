library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity Controle is
port(
	Inst : in std_logic_vector(31 downto 0);
	Overflow : in std_logic;

	BADDR_SOURCE : out std_logic := '0';
	OPERA_SOURCE  : out std_logic_vector(1 downto 0) := (others => '0');
	OPERB_SOURCE : out std_logic := '0';
	BDECIDE_SOURCE : out std_logic_vector(1 downto 0) := (others => '0');
	MEM_WRITE : out std_logic := '0';
	ALU_OP : out std_logic_vector(2 downto 0) := (others => '0');
	MEM_READ : out std_logic := '0';
	WREG_SOURCE : out std_logic_vector(1 downto 0) := (others => '0');
	WREG_WRITE : out std_logic := '0';
	WREG_ADDR_SOURCE : out std_logic_vector(1 downto 0) := (others => '0');
	JAL : out std_logic := '0';

	INTERRUPT_SIGNAL : out std_logic := '0';
	INTERRUPT_SOURCE : out std_logic := '0'

);
end Controle;

architecture Controle of Controle is
	signal Invalid : std_logic := '0';
begin
	process(Inst)
	variable op : std_logic_vector(5 downto 0) := Inst(31 downto 26);
	variable func : std_logic_vector(5 downto 0) := Inst(5 downto 0);
	begin
		op :=  Inst(31 downto 26);
		func :=  Inst(5 downto 0);
		BADDR_SOURCE <= '0';
		OPERA_SOURCE  <= (others => '0');
		OPERB_SOURCE <= '0';
		BDECIDE_SOURCE <= (others => '0');
		MEM_WRITE <= '0';
		ALU_OP <= (others => '0');
		MEM_READ <= '0';
		WREG_SOURCE <= (others => '0');
		WREG_WRITE <= '0';
		WREG_ADDR_SOURCE <= (others => '0');
		JAL <= '0';
		Invalid <= '0';
		case op is
			when "000000" =>
				case func is
					when "100000" => --add
						BADDR_SOURCE <= '0';--
						OPERA_SOURCE  <= "00";--
						OPERB_SOURCE <= '0';--
						BDECIDE_SOURCE <= "00";
						MEM_WRITE <= '0';--
						ALU_OP <= "000";--
						MEM_READ <= '0';--
						WREG_SOURCE <= "00";--
						WREG_WRITE <= '1';--
						WREG_ADDR_SOURCE <= "00";--
					when "011010" => --slt
						BADDR_SOURCE <= '0';--
						OPERA_SOURCE  <= "00";--
						OPERB_SOURCE <= '0';--
						BDECIDE_SOURCE <= "00";
						MEM_WRITE <= '0';--
						ALU_OP <= "100";--
						MEM_READ <= '0';--
						WREG_SOURCE <= "00";--
						WREG_WRITE <= '1';--
						WREG_ADDR_SOURCE <= "00";--
					when "001000" => --jr
						BADDR_SOURCE <= '0';--
						OPERA_SOURCE  <= "00";--
						OPERB_SOURCE <= '0';--
						BDECIDE_SOURCE <= "01";
						MEM_WRITE <= '0';--
						ALU_OP <= "100";--
						MEM_READ <= '0';--
						WREG_SOURCE <= "00";--
						WREG_WRITE <= '0';--
						WREG_ADDR_SOURCE <= "00";--
						JAL <= '1';
					when "100001" => --addu
						BADDR_SOURCE <= '0';--
						OPERA_SOURCE  <= "00";--
						OPERB_SOURCE <= '0';--
						BDECIDE_SOURCE <= "00";
						MEM_WRITE <= '0';--
						ALU_OP <= "010";--
						MEM_READ <= '0';--
						WREG_SOURCE <= "00";--
						WREG_WRITE <= '1';--
						WREG_ADDR_SOURCE <= "00";--
					when "000000" => --sll
						BADDR_SOURCE <= '0';--
						OPERA_SOURCE  <= "10";--
						OPERB_SOURCE <= '0';--
						BDECIDE_SOURCE <= "00";
						MEM_WRITE <= '0';--
						ALU_OP <= "011";--
						MEM_READ <= '0';--
						WREG_SOURCE <= "00";--
						WREG_WRITE <= '1';--
						WREG_ADDR_SOURCE <= "00";--
					when others =>
						Invalid <= '1';
				end case;
			when "100011" => --lw
				BADDR_SOURCE <= '0';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '1';--
				BDECIDE_SOURCE <= "00";
				MEM_WRITE <= '0';--
				ALU_OP <= "000";--
				MEM_READ <= '1';--
				WREG_SOURCE <= "01";--
				WREG_WRITE <= '1';--
				WREG_ADDR_SOURCE <= "01";--
			when "101011" => --sw
				BADDR_SOURCE <= '0';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '1';--
				BDECIDE_SOURCE <= "00";
				MEM_WRITE <= '1';--
				ALU_OP <= "000";--
				MEM_READ <= '0';--
				WREG_SOURCE <= "00";--
				WREG_WRITE <= '0';--
				WREG_ADDR_SOURCE <= "00";--
			when "001000" => --addi
				BADDR_SOURCE <= '0';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '1';--
				BDECIDE_SOURCE <= "00";
				MEM_WRITE <= '0';--
				ALU_OP <= "000";--
				MEM_READ <= '0';--
				WREG_SOURCE <= "00";--
				WREG_WRITE <= '1';--
				WREG_ADDR_SOURCE <= "01";--
			when "000100" => --beq
				BADDR_SOURCE <= '0';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '0';--
				BDECIDE_SOURCE <= "10";
				MEM_WRITE <= '0';--
				ALU_OP <= "001";--
				MEM_READ <= '0';--
				WREG_SOURCE <= "00";--
				WREG_WRITE <= '0';--
				WREG_ADDR_SOURCE <= "00";--
			when "000101" => --bne
				BADDR_SOURCE <= '0';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '0';--
				BDECIDE_SOURCE <= "11";
				MEM_WRITE <= '0';--
				ALU_OP <= "001";--
				MEM_READ <= '0';--
				WREG_SOURCE <= "00";--
				WREG_WRITE <= '0';--
				WREG_ADDR_SOURCE <= "00";--
			when "001010" => --slti
				BADDR_SOURCE <= '0';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '1';--
				BDECIDE_SOURCE <= "00";
				MEM_WRITE <= '0';--
				ALU_OP <= "100";--
				MEM_READ <= '0';--
				WREG_SOURCE <= "00";--
				WREG_WRITE <= '1';--
				WREG_ADDR_SOURCE <= "01";--
			when "000010" => --j
				BADDR_SOURCE <= '1';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '0';--
				BDECIDE_SOURCE <= "01";
				MEM_WRITE <= '0';--
				ALU_OP <= "000";--
				MEM_READ <= '0';--
				WREG_SOURCE <= "00";--
				WREG_WRITE <= '0';--
				WREG_ADDR_SOURCE <= "00";--
			when "000011" => --jal
				BADDR_SOURCE <= '1';--
				OPERA_SOURCE  <= "00";--
				OPERB_SOURCE <= '0';--
				BDECIDE_SOURCE <= "01";
				MEM_WRITE <= '0';--
				ALU_OP <= "000";--
				MEM_READ <= '0';--
				WREG_SOURCE <= "11";--
				WREG_WRITE <= '1';--
				WREG_ADDR_SOURCE <= "10";--
			when "111111" =>
				null;
			when others =>
				Invalid <= '1';
		end case;
	end process;

	process(Invalid, Overflow)
	begin
		INTERRUPT_SIGNAL <= '0';
		INTERRUPT_SOURCE <= '0';
		if (Invalid = '1') then
			INTERRUPT_SIGNAL <= '1';
		end if;
		if (Overflow = '1') then
			INTERRUPT_SIGNAL <= '1';
			INTERRUPT_SOURCE <= '1';
		end if;
	end process;

end Controle;
