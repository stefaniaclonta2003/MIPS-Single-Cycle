library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;


entity ID is
    Port (
        writeData : in  std_logic_vector(31 downto 0);
        regWrite : in std_logic;
        regDst : in std_logic;
        ExtOp : in std_logic;
        Instr : in std_logic_vector(25 downto 0);
        clk : in std_logic;
        en : in std_logic;
        readData1 : out std_logic_vector(31 downto 0);
        readData2 : out std_logic_vector(31 downto 0);
        Ext_Imm : out std_logic_vector(31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa: out std_logic_vector(4 downto 0)
    );
end ID;

architecture Behavioral of ID is
    type Register_File is array (0 to 31) of std_logic_vector(31 downto 0);
    signal RF : Register_File := (others => (others => '0'));
    signal  writeAddr : std_logic_vector(4 downto 0);
    signal  instr_20_16 :  std_logic_vector(4 downto 0);
    signal  instr_15_11 :  std_logic_vector(4 downto 0);
    signal mux1 : std_logic_vector(4 downto 0);
    
component reg_file 
    port ( 
    clk : in std_logic;
    ra1 : in std_logic_vector(4 downto 0);
    ra2 : in std_logic_vector(4 downto 0);
    wa : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    regwr : in std_logic;
    rd1 : out std_logic_vector(31 downto 0);
    rd2 : out std_logic_vector(31 downto 0)
    );

end component;
    
begin

   process(regDst, Instr)
   
    begin
      instr_20_16 <= Instr(20 downto 16);
      instr_15_11 <= Instr(15 downto 11);
        if regDst = '1' then
            mux1 <= instr_15_11;
        else
            mux1 <= instr_20_16;
        end if;
    end process;

writeAddr <= mux1;
Ext_Imm(15 downto 0) <= Instr(15 downto 0);
Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else(others => '0');

    
    func <= instr(5 downto 0);
    sa <= instr(10 downto 6);
process(regWrite,Instr,mux1,WriteData,en,clk)
begin
    if rising_edge(clk) then
        if en='1' and RegWrite='1' then
            RF(conv_integer(mux1))<=WriteData;
        end if;
    end if;
end process;
readData1<=RF(conv_integer(Instr(25 downto 21)));
readData2<=RF(conv_integer(Instr(20 downto 16)));
end Behavioral;