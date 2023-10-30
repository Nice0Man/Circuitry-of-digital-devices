LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Tb_RegesterFile IS
END Tb_RegesterFile;

ARCHITECTURE behavior OF Tb_RegesterFile IS

	constant reg_width : integer := 32;
	constant lnum_reg : integer := 5;
	


	--Inputs
   signal tb_clk : std_logic; -- Tactation singal
   signal tb_reset : std_logic; -- Reset signal
	signal tb_ReadRegister : std_logic_vector(lnum_reg-1 downto 0);
	signal tb_WriteRegister : std_logic_vector(lnum_reg-1 downto 0);
	signal tb_WriteData : std_logic_vector(reg_width-1 downto 0);
	signal tb_EnableWrite : std_logic;
	signal tb_EnableRead : std_logic;

	--Outputs

	signal tb_ReadData : std_logic_vector (reg_width-1 downto 0);
	signal tb_TimerCountRegister: std_logic_vector (25 downto 13);
	signal tb_AccumulatorRegister: std_logic_vector (31 downto 0);
	signal tb_BaseRegister: std_logic_vector (4 downto 0);
	signal tb_DataRegister: std_logic_vector (31 downto 16);
	
	
	COMPONENT RegisterFile 
	Generic (
		reg_width : integer := 32; -- Register tire width
		lnum_reg : integer := 5    -- Addres tire width
	);
	Port ( 
			clk : in std_logic; -- Tactation signal
         reset : in std_logic; -- Reset signal
			ReadRegister : in STD_LOGIC_VECTOR (lnum_reg-1 downto 0);
			WriteRegister : in STD_LOGIC_VECTOR (lnum_reg-1 downto 0);
			WriteData : in STD_LOGIC_VECTOR (reg_width-1 downto 0);
			EnableWrite : in STD_LOGIC;
			EnableRead : in STD_LOGIC;
			ReadData : out STD_LOGIC_VECTOR (reg_width-1 downto 0);
			TimerCountRegister: out STD_LOGIC_VECTOR(25 downto 13);
			AccumulatorRegister: out STD_LOGIC_VECTOR(31 downto 0);
			BaseRegister: out STD_LOGIC_VECTOR(4 downto 0);
			DataRegister: out STD_LOGIC_VECTOR(31 downto 16)
			);
	END COMPONENT;
	
	
	COMPONENT Tester_RegisterFile 
   Generic (
		reg_width : integer := 32; -- Register tire width
		lnum_reg : integer := 5    -- Addres tire width
   );
   Port ( 
			clk : out std_logic; -- Tactation signal
         reset : out std_logic; -- Reset signal
			ReadRegister : out STD_LOGIC_VECTOR (lnum_reg-1 downto 0);
			WriteRegister : out STD_LOGIC_VECTOR (lnum_reg-1 downto 0);
			WriteData : out STD_LOGIC_VECTOR (reg_width-1 downto 0);
			EnableWrite : out STD_LOGIC;
			EnableRead : out STD_LOGIC
			);
	 END COMPONENT;

	
	
	
BEGIN

--------------------------------Testing device image----------------------------------

	U1_Reg: entity work.RegisterFile 
		PORT MAP (
		   clk => tb_clk,
		   reset => tb_reset,
			ReadRegister => tb_ReadRegister,
			WriteRegister => tb_WriteRegister,
			WriteData => tb_WriteData,
			EnableWrite => tb_EnableWrite,
			EnableRead => tb_EnableRead,
			ReadData => tb_ReadData,
			TimerCountRegister => tb_TimerCountRegister,
			AccumulatorRegister => tb_AccumulatorRegister,
			BaseRegister => tb_BaseRegister,
			DataRegister => tb_DataRegister
		);
	U2_Reg: Tester_RegisterFile
		PORT MAP (
		   clk => tb_clk,
		   reset => tb_reset,
			ReadRegister => tb_ReadRegister,
			WriteRegister => tb_WriteRegister,
			WriteData => tb_WriteData,
			EnableWrite => tb_EnableWrite,
			EnableRead => tb_EnableRead
		);		
-----------------------------------------------------------------------------------------------		


end; 