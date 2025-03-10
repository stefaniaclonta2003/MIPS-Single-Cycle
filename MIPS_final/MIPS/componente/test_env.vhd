library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
component IFetch
    Port(
        jump: in std_logic;
        jumpAddr: in std_logic_vector(31 downto 0);
        PCSrc: in std_logic;
        branchAddr: in std_logic_vector(31 downto 0);
        en: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        Instruction: out std_logic_vector(31 downto 0);
        nextAddr: out std_logic_vector(31 downto 0)
    );
end component;
component MPG
    Port ( btn : in STD_LOGIC;     
           clk : in STD_LOGIC;     
           enable : out STD_LOGIC);
end component;
component SSD
    Port ( clk : in std_logic;
           digits : in std_logic_vector(31 downto 0);
           an : out std_logic_vector(7 downto 0);
           cat : out std_logic_vector(6 downto 0)
    );
end component;
component UC
    Port(
 Instr: in std_logic_vector(5 downto 0);
    RegDst: out std_logic;
    ExtOp:out std_logic;
    ALUSrc: out std_logic;
    Branch: out std_logic;
    Br_gez: out std_logic;
    Jump: out std_logic;
    MemWrite: out std_logic;
    MemToReg: out std_logic;
    RegWrite: out std_logic;
    ALUOp: out std_logic_vector(1 downto 0));
end component;
component ID
    Port(
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
end component;
component EX
    Port(
 RD1 : in std_logic_vector(31 downto 0);
    RD2: in std_logic_vector(31downto 0);
    ALUSrc : in std_logic;
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector(4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(1 downto 0);
    PC: in std_logic_vector(31 downto 0);
    gez: out std_logic;
    Zero: out std_logic;
    ALURes: out std_logic_vector(31 downto 0);
    BranchAddress: out std_logic_vector(31 downto 0)
    );
end component;
component MEM
    Port(
    MemWrite : in std_logic;                     
    ALUResin : std_logic_vector(31 downto 0);    
    RD2 : in std_logic_vector(31 downto 0);      
    clk : in std_logic;                          
    en : in std_logic;                           
    MemData : out std_logic_vector(31 downto 0); 
    ALUResout : out std_logic_vector(31 downto 0)
    );
end component;
signal enable_mpg : std_logic := '0';
signal JumpAddress : std_logic_vector(31 downto 0);
signal PcSrc : std_logic;
signal BranchAddress : std_logic_vector(31 downto 0);
signal InstructionIFetch : std_logic_vector(31 downto 0);
signal NextAddress : std_logic_vector(31 downto 0);
signal InstructionUC : std_logic_vector(5 downto 0);
signal RegDst : std_logic;
signal ExtOp : std_logic;
signal ALUSrc : std_logic;
signal Branch : std_logic;
signal Branch_gez : std_logic;
signal Jump : std_logic;--+IFetch
signal ALUOp : std_logic_vector(1 downto 0);
signal MemWrite : std_logic;
signal MemtoReg : std_logic;
signal RegWrite : std_logic;
signal InstructionID : std_logic_vector(25 downto 0);
signal RD1 : std_logic_vector(31 downto 0);--+EX
signal RD2 : std_logic_vector(31 downto 0);--+EX+MEM
signal WD : std_logic_vector(31 downto 0);
signal ExtInm : std_logic_vector(31 downto 0);--+EX
signal func : std_logic_vector(5 downto 0);--+EX
signal sa : std_logic_vector(4 downto 0);--+EX
signal zero : std_logic;
signal gez : std_logic;
signal ALURes : std_logic_vector(31 downto 0);--+MEMALUResin
signal MemData: std_logic_vector(31 downto 0);
signal ALUResout : std_logic_vector(31 downto 0);
signal output : std_logic_vector(15 downto 0);
signal mux : std_logic_vector(31 downto 0);

begin
JumpAddress<=NextAddress(31 downto 28)&InstructionIFetch(25 downto 0)&"00";
PCSrc<=(zero and Branch) or (gez and Branch_gez);
IFetch_inst:
IFetch port map(
    clk => clk,
    rst => btn(1),
    en => enable_mpg,
    branchAddr => BranchAddress,
    PCSrc => PCSrc,
    jumpAddr => JumpAddress,
    jump => Jump,
    Instruction => InstructionIFetch,
    nextAddr => NextAddress
);
MPG_inst:
MPG port map(
    clk => clk,
    enable =>enable_mpg,
    btn => btn(0)
);
UC_inst: UC port map(
    Instr => InstructionUC,
    RegDst => RegDst,
    ExtOp => ExtOp,
    ALUSrc => ALUSrc,
    Branch => Branch,
    Br_gez => Branch_gez,
    Jump => Jump,
    ALUOp => ALUOp,
    MemWrite => MemWrite,
    MemtoReg => MemtoReg,
    RegWrite => RegWrite
);
ID_inst: ID port map(
    clk => clk,
    RegWrite => RegWrite,
    Instr => InstructionID,
    RegDst => RegDst,
    EN => enable_mpg,
    ExtOp => ExtOp,
    readData1 => RD1,
    readData2 => RD2,
    writeData => WD,
    Ext_Imm => ExtInm,
    func => func,
    sa => sa
);
InstructionID <= InstructionIFetch(25 downto 0);
InstructionUC <= InstructionIFetch(31 downto 26);
EX_inst: EX port map(
    ALUSrc => ALUSrc,
    RD1=>RD1,
    RD2=>RD2,
    Ext_Imm=>ExtInm,
    func=>func,
    sa=>sa,
    ALUOp=>ALUOp,
    zero=>zero,
    gez=>gez,
    pc=>NextAddress,
    BranchAddress=>BranchAddress,
    ALURes=>ALURes
);
MEM_inst: MEM port map(
    ALUResin=>ALURes,
    EN=>enable_mpg,
    RD2=>RD2,
    clk=>clk,
    MemWrite=>MemWrite,
    ALUResout=>ALUResout,
    MemData=>MemData
);
--mux mic
process(ALUResout,MemData,MemtoReg)
begin
    if MemtoReg='0' then
        WD<=ALUResout;
    else
        WD<=MemData;
    end if;
end process;
--mux ssd
process(sw(7 downto 5),InstructionIFetch,NextAddress,RD1,RD2,ExtInm,ALURes,
MemData,WD)
begin
    case sw(7 downto 5) is
        when "000" => mux <= InstructionIFetch;
        when "001" => mux <= nextAddress;
        when "010" => mux <= RD1;
        when "011" => mux <= RD2;
        when "100" => mux <= ExtInm;
        when "101" => mux <= ALURes;
        when "110" => mux <= MemData;
        when "111" => mux <= WD;
        when others => mux <= X"11111111";
    end case;
end process;
--output<=mux(15 downto 0);
--process(sw(0))
--begin
--    if sw(0) = '0' then
--        output<=mux(15 downto 0);
--    else
--        output<=mux(31 downto 16);
--    end if;
--end process;

SSD_inst:
SSD port map(clk, mux, an, cat);
end Behavioral;