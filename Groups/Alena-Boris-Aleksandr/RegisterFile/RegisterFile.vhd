library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
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
    
end entity;

architecture Behavioral of RegisterFile is

------------------------------Register file initialization---------------------------------

  type reg_file_type is array(0 to 2**lnum_reg-1) of
			std_logic_vector(reg_width-1 downto 0);
    
  signal array_reg : reg_file_type := (others => (others => '1')); -- Регистровый файл

                 
-----------------------------------------------------------------------------------------------
  signal ReadData_r : std_logic_vector(reg_width-1 downto 0);
  signal ReadData_s : std_logic_vector(reg_width-1 downto 0);
  signal TimerCountRegister_r : std_logic_vector(25 downto 13);
  signal AccumulatorRegister_r : std_logic_vector(31 downto 0);
  signal BaseRegister_r : std_logic_vector(4 downto 0);
  signal DataRegister_r : std_logic_vector(31 downto 16);
            
begin

TimerCountRegister <= TimerCountRegister_r;
AccumulatorRegister <= AccumulatorRegister_r;
BaseRegister <= BaseRegister_r;
DataRegister <= DataRegister_r;


ReadData_s <= array_reg(to_integer(unsigned(ReadRegister)));
ReadData <= ReadData_r;

-----------------------------------Read and write process------------------------------------
  process(clk, reset)
  begin
		if (reset = '1') then
			array_reg <= (others => (others => '0')); -- Reset of register file
			TimerCountRegister_r <= (others => '0');
			AccumulatorRegister_r <= (others => '0');
			BaseRegister_r <= (others => '0');
			DataRegister_r <= (others => '0');
			ReadData_r <= (others => '0');
		elsif (rising_edge(clk)) then
			TimerCountRegister_r <= array_reg(3)(25 downto 13);
			AccumulatorRegister_r <= array_reg(0);
			BaseRegister_r <= array_reg(2)(4 downto 0);
			DataRegister_r <= array_reg(1)(31 downto 16);
			if( EnableWrite = '1' ) then
					array_reg(to_integer(unsigned(WriteRegister))) <= WriteData;
			end if;	
			if( EnableRead = '1' ) then
					-----
				ReadData_r <= ReadData_s;
					-----
			end if;	
		end if;
  end process;

-----------------------------------------------------------------------------------------------



  
end architecture Behavioral;