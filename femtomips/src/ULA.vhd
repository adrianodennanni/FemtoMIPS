library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
   port
   (
      OpA, OpB : in std_logic_vector(31 downto 0);
      Oper : in std_logic_vector(2 downto 0);

      ZER : out std_logic;
      NEG : out std_logic;
	    OVF : out std_logic;
      Res : out std_logic_vector(31 downto 0)
   );
end entity ULA;

architecture ULA of ULA is

	signal SomaS: std_logic_vector(31 downto 0);
	signal SomaU: std_logic_vector(31 downto 0);
	signal Sub: std_logic_vector(31 downto 0);
	signal Desl: std_logic_vector(31 downto 0);
  signal Sig: std_logic_vector(31 downto 0);

  signal OpBA, OpBB, OpBC, OpBD, OpBdesl : std_logic_vector(31 downto 0);
  signal OpBAD, OpBBD, OpBCD, OpBDD : std_logic_vector(31 downto 0);

  -- Component declaration of the "Mux2x1(Mux2x1)" unit defined in
-- file: "./../src/Mux2x1.vhd"
component Mux2x1
port(
  I0 : in STD_LOGIC_VECTOR(31 downto 0);
  I1 : in STD_LOGIC_VECTOR(31 downto 0);
  Sel : in STD_LOGIC;
  O : out STD_LOGIC_VECTOR(31 downto 0));
end component;
for all: Mux2x1 use entity work.Mux2x1(Mux2x1);



begin

   SomaS <= std_logic_vector(signed(OpA) + signed(OpB));
   SomaU <= std_logic_vector(unsigned(OpA) + unsigned(OpB));
   Sub <= std_logic_vector(signed(OpA) - signed(OpB));

   Sig <= "0000000000000000000000000000000" & Sub(31);

   OpBdesl <= OpB(30 downto 0) & "0";

   m1 : Mux2x1
	port map(
		I0 => OpB,
		I1 => OpBdesl,
		Sel => OpA(0),
		O => OpBA
	);

  OpBAD <= OpBA(29 downto 0) & "00";

  m2 : Mux2x1
	port map(
		I0 => OpBA,
		I1 => OpBAD,
		Sel => OpA(1),
		O => OpBB
	);

  OpBBD <= OpBB(27 downto 0) & "0000";

  m3 : Mux2x1
	port map(
		I0 => OpBB,
		I1 => OpBBD,
		Sel => OpA(2),
		O => OpBC
	);

  OpBCD <= OpBC(23 downto 0) & "00000000";

  m4 : Mux2x1
	port map(
		I0 => OpBC,
		I1 => OpBCD,
		Sel => OpA(3),
		O => OpBD
	);

  OpBDD <= OpBD(15 downto 0) & "0000000000000000";

  m5 : Mux2x1
	port map(
		I0 => OpBD,
		I1 => OpBDD,
		Sel => OpA(4),
		O => Desl
	);

   process(OpA, OpB, Oper, SomaS, SomaU, Sub, Desl) is
    variable IRes: std_logic_vector(31 downto 0) := (others => '0');
   begin
      ZER <= '0';
	  NEG <= '0';
	  OVF <= '0';
      case Oper is
 	  when "000" => -- soma S ( OpA + OpB )
	   IRes := SomaS;
	   OVF <= (IRes(31) xor OpA(31)) and (IRes(31) xor OpB(31));
 	  when "010" => -- soma U ( OpA + OpB )
	   IRes := SomaU;
 	  when "001" =>  -- sub	( OpA - OpB )
	   IRes := Sub;
	   OVF <= (IRes(31) xor OpA(31)) and (IRes(31) xor (not OpB(31)));
 	  when "011" =>	-- desl	( OpB << OpA )
	   IRes := Desl;
 	  when "100" => -- signal ( OpA )
	   IRes := "0000000000000000000000000000000" & Sub(31);
    when others =>
      null	   ;
      end case;

	  if (IRes = (31 downto 0 => '0')) then
		  ZER <= '1';
	  end if;

    NEG <= IRes(31);
    Res <= IRes;
   end process;




end architecture ULA;
