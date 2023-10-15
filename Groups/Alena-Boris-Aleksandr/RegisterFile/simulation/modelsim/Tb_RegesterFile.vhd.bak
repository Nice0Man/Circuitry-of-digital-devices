LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Tb_RegesterFile IS
END Tb_RegesterFile;

ARCHITECTURE behavior OF Tb_RegesterFile IS

	--Inputs

	signal tb_ReadRegisterl : std_logic_vector(4 downto 0) := (others => '0');
	signal tb_ReadRegister2 : std_logic_vector(4 downto 0) := (others => '0');
	signal tb_WriteRegister : std_logic_vector(4 downto 0) := (others => '0');
	signal tb_WriteData : std_logic_vector(31 downto 0) := (others => '0');
	signal tb_RegWrite : std_logic := '0';

	--Outputs

signal tb_ReadDatal : std_logic_wector (31 downto 0);
signal tb_ReadData2 : std_logic_vector (31 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	Ul_Reg: entity work.RegisterFile (Behavioral)
		PORT MAP (
			ReadRegister1 => tb_ReadRegister1,
			ReadRegister2 => tb_ReadRegister2,
			WriteRegister => tb_WriteRegister,
			WriteData => tb_WriteData,
			RegWrite => tb_RegWrite,
			ReadData1 => tb_ReadData1,
			ReadData2 => tb_ReadData2
		);

	-- Stimulus proce
	stim_proc: process
	begin

		-- Reading all 32 register
		
		for I in 0 to 30 loop
			tb_ReadRegister1 <= std_logic_vector(to_unsigned(I,5));
			tb_ReadRegister2 <= std_logic_vector(to_unsigned(I+1,5));
			wait for 25 ns;
		end loop;
		
		assert false
			report "End"
			severity failure;
			
	end process;
