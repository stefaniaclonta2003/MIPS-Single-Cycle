library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity IFetch is
  Port(
  PCSrc: in std_logic;
  branchAddr: in std_logic_vector(31 downto 0);
  jumpAddr: in std_logic_vector(31 downto 0);
  jump :in std_logic;
  en: in std_logic;
  clk: in std_logic;
  rst: in std_logic;
  Instruction : out std_logic_vector(31 downto 0);
  nextAddr : out std_logic_vector(31 downto 0)
  );
  
end IFetch;

architecture Behavioral of IFetch is

signal q:  std_logic_vector(31 downto 0);
signal sum : std_logic_vector(31 downto 0);
signal mux1 : std_logic_vector(31 downto 0);
signal mux2 : std_logic_vector(31 downto 0);
type memorie_rom is array (0 to 31) of std_logic_vector(31 downto 0);
signal rom : memorie_rom := (
b"001000_00000_00001_0000000000000000",--X"2001_0000"-00--addi $1, $0, 0 #initializam i=0
b"000000_00000_00000_00010_00000_100000",--X"0000_1020"--01--add $2, $0, $0 #intializam rezultat=0(numarul de numere impare din vector
b"100011_00000_00011_0000000000000000",--X"8C03_0000"--02--lw $3, 0($0) #citim de la adresa numarul de elemente ale vectorului N
b"001000_00000_00100_0000000000000100",--X"2004_0004"--03--addi $4,$0,4 #vectorul incepe de la adresa 4, indexul locatiei de memorie
b"000100_00001_00011_0000000000001000",--X"1023_0008"--04--beq $1, $3, 8 # daca i=N se termina bucla
b"100011_00100_00101_0000000000000000",--X"8C85_0000"--05--lw $5, 0($4) #incarcam elementul curent din vector
b"001000_00000_00110_0000000000000001",--X"2006_0001"--06--addi $6,$0,1
b"000000_00101_00110_00111_00000_100100",--X"00A6_3824"--07--and $7, $5, $6 #facem and intre elementul curent si 1 pt a verifica paritatea
b"000100_00111_00000_0000000000000001",--X"10E0_0001"--08--beq $7, $0, 1
b"001000_00010_00010_0000000000000001",--X"2042_0001"-09--addi $2, $2, 1 #marim contorul de elemente impare
b"001000_00001_00001_0000000000000001",--X"2021_0001"--10--addi $1, $1, 1 #i++
b"001000_00100_00100_0000000000000100",--X"2084_0004"--11--addi $4, $4, 4 #trecem la adresa urmatoare
b"000010_00000000000000000000000100",--X"0800_0004"--12--j 4
b"101011_00000_00010_0000000000011000",--X"AC08_0018"--13--sw $2, 24($0) # scriem la adresa 24 rezultatul(indicele 6)
others => X"00000000"
      
); 
begin

--registrul PC
process(clk, rst)
begin
if rst = '1' then
  q <= (others => '0');
elsif rising_edge(clk) then
  if en = '1' then 
     q <= mux1;
  end if;
end if;

end process;

--mux 1
process(jump, jumpAddr, mux2)
    begin
        if jump = '1' then
            mux1 <= jumpAddr;
        else
            mux1 <= mux2;
        end if;
    end process;
    
 --mux2
process(sum, branchAddr, PCSrc)
    begin
        if PCSrc = '1' then
            mux2 <= branchAddr;
        else 
            mux2 <= sum;
        end if;
end process;

sum <= q + 4;
nextAddr <= sum;
Instruction <= rom(conv_integer(q(6 downto 2)));

end Behavioral;