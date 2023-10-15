library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
  Generic (
    reg_width : integer := 32; --ширина регистра(ширина шины данных)
    lnum_reg : integer := 5    --логарифм от количества регистров(ширина шины адреса)
  );
  Port ( clk : in std_logic; -- Сигнал тактирования
         reset : in std_logic; -- Сигнал сброса
			ReadRegister : in STD_LOGIC_VECTOR (lnum_reg-1 downto 0);
			WriteRegister : in STD_LOGIC_VECTOR (lnum_reg-1 downto 0);
			WriteData : in STD_LOGIC_VECTOR (reg_width-1 downto 0);
			RegWrite : in STD_LOGIC;
			ReadData : out STD_LOGIC_VECTOR (reg_width-1 downto 0);
			TimerCountRegister: out STD_LOGIC_VECTOR(25 downto 13);
			AccumulatorRegister: out STD_LOGIC_VECTOR(31 downto 0);
			BaseRegister: out STD_LOGIC_VECTOR(4 downto 0);
			DataRegister: out STD_LOGIC_VECTOR(31 downto 16)
			);
    
end entity;

architecture Behavioral of RegisterFile is


  type reg_file_type is array(0 to 2**lnum_reg-1) of
			std_logic_vector(reg_width-1 downto 0);
    
  signal array_reg : reg_file_type := (others => (others => '0')); -- Регистровый файл
--													( x"00000000",
--													 x"11111111",
--													 x"22222222",
--													 x"33333333",
--													 x"44444444",
--													 x"55555555",
--													 x"66666666",
--													 x"77777777",
--													 x"88888888",
--													 x"99999999",
--													 x"aaaaaaaa",
--													 x"bbbbbbbb",
--													 x"cccccccc",
--													 x"dddddddd",
--													 x"eeeeeeee",
--													 x"ffffffff",
--													 x"00000000",
--													 x"11111111",
--													 x"22222222",
--													 x"33333333",
--													 x"44444444",
--													 x"55555555",
--													 x"66666666",
--													 x"77777777",
--													 x"88888888",
--													 x"99999999",
--													 x"aaaaaaaa",
--													 x"bbbbbbbb",
--													 x"12093292",
--													 x"032ef0d3",
--													 x"23423444",
--													 x"ffffffff"
--											);
--                 

            
begin
------------------------------------------
	TimerCountRegister <= array_reg(3)(25 downto 13);
	AccumulatorRegister <= array_reg(0);
	BaseRegister <= array_reg(2)(4 downto 0);
	DataRegister <= array_reg(1)(31 downto 16);

	ReadData <= array_reg(to_integer(unsigned(ReadRegister)));
------------------------------------------
-----------------------------------------------------------------------------
  process(clk, reset)
  begin
		if (reset = '1') then
			array_reg <= (others => (others => '0')); -- Сброс регистрового файла
      elsif (rising_edge(clk)) then
		   --
			if( RegWrite = '1' ) then
				array_reg(to_integer(unsigned(WriteRegister))) <= WriteData;
			end if;
			--
		end if;
  end process;
---------------------------------------------------------------------------------

  
end architecture Behavioral;