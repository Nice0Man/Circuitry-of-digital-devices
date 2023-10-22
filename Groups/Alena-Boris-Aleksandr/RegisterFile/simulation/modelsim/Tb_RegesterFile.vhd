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
   signal tb_clk : std_logic := '1'; -- Tactation singal
   signal tb_reset : std_logic := '0'; -- Reset signal
	signal tb_ReadRegister : std_logic_vector(num_reg-1 downto 0) := (others => '0');
	signal tb_WriteRegister : std_logic_vector(num_reg-1 downto 0) := (others => '0');
	signal tb_WriteData : std_logic_vector(reg_width-1 downto 0) := (others => '0');
	signal tb_EnableWrite : std_logic := '0';
	signal tb_EnableRead : std_logic := '0';

	--Outputs

	signal tb_ReadData : std_logic_vector (reg_width-1 downto 0);
	signal tb_TimerCountRegister: std_logic_vector (25 downto 13);
	signal tb_AccumulatorRegister: std_logic_vector (31 downto 0);
	signal tb_BaseRegister: std_logic_vector (4 downto 0);
	signal tb_DataRegister: std_logic_vector (31 downto 16);

BEGIN

--------------------------------Testing device image----------------------------------

	Ul_Reg: entity work.RegisterFile (Behavioral)
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
		
-----------------------------------------------------------------------------------------------		

---------------------------------Tactation signal settings-----------------------------------
	
	clock_gen: process
	begin
		loop                --// 	Start an infinite loop
			tb_clk <= not tb_clk;       --// Tactation inversion
			wait for period/2;  --// Wait for the half of the period
		end loop;           --// End an infinite loop
	end process;
		 
    --тесты
	stim_proc: process
	begin

-----------------------------------------------------------------------------------------------
	
		
---------------------------------Write in register test-----------------------------------------

		
		tb_WriteRegister <= "01000"; -- 8
		tb_WriteData <= x"a5a5a5a5";
		tb_ReadRegister <= std_logic_vector(to_unsigned(6,5));
		wait for 50 ns;
		
		tb_reset <= '1';
		wait for 10 ns;
		
		tb_reset <= '0';
		wait for 10 ns;


		tb_EnableWrite <= '1';
		tb_EnableRead <= '1';
		tb_reset <= '1';
		wait for 10 ns;

		tb_EnableWrite <= '0';
		tb_EnableRead <= '0';
		tb_reset <= '0';
		wait for 15 ns;
		
		tb_EnableWrite <= '1';
		tb_EnableRead <= '1';	
		wait for 10 ns;
		
		tb_EnableWrite <= '0';
		tb_EnableRead <= '0';
		wait for 10 ns;		
		
		tb_WriteRegister <= "01111"; -- 15
		tb_WriteData <= x"b4b4b4b4";
		tb_ReadRegister <= std_logic_vector(to_unsigned(8,5));
		
		tb_EnableRead <= '1';
      wait for 10 ns;
		
		tb_EnableRead <= '0';
		wait for 10 ns;
		
		tb_EnableWrite <= '1';
      wait for 10 ns;
		
		tb_EnableWrite <= '0';
		wait for 10 ns;
		
-----------------------------------------------------------------------------------------------

		assert false
			report "End"
			severity failure;
			
	end process;
end;