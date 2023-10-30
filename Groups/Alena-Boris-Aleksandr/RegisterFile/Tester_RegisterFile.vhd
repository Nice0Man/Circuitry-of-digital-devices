LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Tester_RegisterFile is
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
    
end entity;

ARCHITECTURE behavior_tester OF Tester_RegisterFile IS


	SIGNAL int_clk : std_logic := '0';
	constant period : time := 10 ns;

BEGIN

---------------------------------Tactation signal settings-----------------------------------
	
	clock_gen: process
	begin
		loop                --// 	Start an infinite loop
			int_clk <= not int_clk;       --// Tactation inversion
			wait for period/2;  --// Wait for the half of the period
		end loop;           --// End an infinite loop
	end process;
		 
-----------------------------------------------------------------------------------------------
clk <= int_clk;
--------------------------------Register test-------------------------------------------------

	stim_proc: process
	begin
		reset <= '0';
		EnableWrite <= '0';
		EnableRead <= '0';
		WriteRegister <= "01000"; -- 8
		WriteData <= x"a5a5a5a5";
		ReadRegister <= std_logic_vector(to_unsigned(6,5));
		wait for 50.5 ns;
		
		reset <= '1';
		wait for 12 ns;
		


		EnableWrite <= '1';
		EnableRead <= '1';
		wait for 10 ns;

		EnableWrite <= '0';
		EnableRead <= '0';
		wait for 15 ns;
		
		reset <= '0';
		wait for 10 ns;
		
		EnableWrite <= '1';
		EnableRead <= '1';	
		wait for 10 ns;
		
		EnableWrite <= '0';
		EnableRead <= '0';
		wait for 10 ns;		
		
		WriteRegister <= "01111"; -- 15
		WriteData <= x"b4b4b4b4";
		ReadRegister <= std_logic_vector(to_unsigned(8,5));
		
		EnableRead <= '1' after 1 ns;
      wait for 10 ns;
		
		EnableRead <= '0' after 1 ns;
		wait for 10 ns;
		
		EnableWrite <= '1';
      wait for 10 ns;
		
		EnableWrite <= '0';
		wait for 10 ns;

		
		assert false
			report "End"
			severity failure;
			
	end process;
	
-----------------------------------------------------------------------------------------------
end;