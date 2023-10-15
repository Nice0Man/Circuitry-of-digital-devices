LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Tb_RegesterFile IS
END Tb_RegesterFile;

ARCHITECTURE behavior OF Tb_RegesterFile IS

	constant reg_width : integer := 32;
	constant num_reg : integer := 5;
	
	constant period : time := 10 ns;

	--Inputs
   signal tb_clk : std_logic := '1'; -- Сигнал тактирования
   signal tb_reset : std_logic := '0'; -- Сигнал сброса
	signal tb_ReadRegister : std_logic_vector(num_reg-1 downto 0) := (others => '0');
	signal tb_WriteRegister : std_logic_vector(num_reg-1 downto 0) := (others => '0');
	signal tb_WriteData : std_logic_vector(reg_width-1 downto 0) := (others => '0');
	signal tb_RegWrite : std_logic := '0';

	--Outputs

	signal tb_ReadData : std_logic_vector (reg_width-1 downto 0);
	signal tb_TimerCountRegister: std_logic_vector (25 downto 13);
	signal tb_AccumulatorRegister: std_logic_vector (31 downto 0);
	signal tb_BaseRegister: std_logic_vector (4 downto 0);
	signal tb_DataRegister: std_logic_vector (31 downto 16);

BEGIN


	Ul_Reg: entity work.RegisterFile (Behavioral)
		PORT MAP (
		   clk => tb_clk,
		   reset => tb_reset,
			ReadRegister => tb_ReadRegister,
			WriteRegister => tb_WriteRegister,
			WriteData => tb_WriteData,
			RegWrite => tb_RegWrite,
			ReadData => tb_ReadData,
			TimerCountRegister => tb_TimerCountRegister,
			AccumulatorRegister => tb_AccumulatorRegister,
			BaseRegister => tb_BaseRegister,
			DataRegister => tb_DataRegister
		);

	clock_gen: process
	begin
		loop                --// начало беcконечного цикла 
			tb_clk <= not tb_clk;       --// инверсия тактирования
			wait for period/2;  --// ожидание времени
		end loop;           --// конец беcконечного цикла
	end process;
		 
	-- Stimulus proce
	stim_proc: process
	begin

--		-- Reading all 32 register
--		
--		for I in 0 to 30 loop
--			tb_ReadRegister1 <= std_logic_vector(to_unsigned(I,5));
--			tb_ReadRegister2 <= std_logic_vector(to_unsigned(I+1,5));
--			wait for 25 ns;
--		end loop;
		
		-- Writing a register
		
		tb_WriteRegister <= "01000"; -- 8
		tb_WriteData <= x"a5a5a5a5";
		wait for 50 ns;


		tb_RegWrite <= '1';
		wait for 10 ns;

		tb_RegWrite <= '0';
		wait for 15 ns;
		
		tb_reset <= '1';
		wait for 10 ns;
		
		tb_reset <= '0';
		wait for 10 ns;		
		

		assert false
			report "End"
			severity failure;
			
	end process;
end;