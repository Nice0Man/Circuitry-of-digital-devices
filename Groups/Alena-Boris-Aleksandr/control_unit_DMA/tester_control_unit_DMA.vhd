LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all; 
Entity Tester is 
Port (
	ready 		:OUT	std_logic;
	clk			:OUT	std_logic;
	rst			:OUT	std_logic;
	
	AXI_data_in			:OUT 	std_logic_vector (31 downto 0);
	AXI_address_in		:OUT	std_logic_vector (31 downto 0);
	AXI_cmd_in        :OUT  std_logic_vector (1 downto 0);
	AXI_flag_out      :IN std_logic;
	AXI_data_out       :IN  std_logic_vector (31 downto 0);
	
	AXI_state_out		:IN	std_logic_vector (2 downto 0);
	RAM_state_out		:IN	std_logic_vector (2 downto 0);
	APB_state_out		:IN	std_logic_vector (2 downto 0)
	);

END Tester; 

Architecture Test of Tester IS 
CONSTANT second 	: TIME := 10 ns;
CONSTANT second_2 	: TIME := 20 ns;
CONSTANT second_3 	: TIME := 30 ns;
CONSTANT second_10 	: TIME := 100 ns;
Begin

synchronizer : PROCESS 
BEGIN
	clk <= '0';
	WAIT FOR second;
	clk <= '1';
	WAIT FOR second;
END PROCESS;

work: 
Process
Begin
wait for second;
ready <= '0';
rst<= '1';
wait for second_2;
rst <= '0';
wait for second_2;
--r_CPU_cs <= '0';
--wait for second_2;
AXI_address_in <= x"00000003";
AXI_data_in <= x"F00F01AF";
AXI_cmd_in <= "11";
wait until AXI_flag_out = '0';

--AXI_address_in <= x"00000002";
AXI_cmd_in <= "00";
AXI_data_in <= x"F12C01FF";
wait until AXI_flag_out = '0';
AXI_data_in <= x"FBCD012A";
wait until AXI_flag_out = '0';
AXI_data_in <= x"FAABBB0A";
wait until AXI_flag_out = '0';
AXI_data_in <= x"FFFFFFFF";
wait until AXI_flag_out = '0';
AXI_data_in <= x"F5555555";
wait until AXI_flag_out = '0';
AXI_data_in <= x"F2222222";
wait until AXI_flag_out = '0';
AXI_data_in <= x"F1111111";
wait until AXI_flag_out = '0';
--r_CPU_cs <= '1';
--AXI_address_in <= x"0000";
AXI_data_in <= x"006800F0";
wait until AXI_flag_out = '0';
wait until AXI_state_out = "000";
wait for second_2;
AXI_address_in <= x"00000006";
AXI_data_in <= x"00000000";
AXI_cmd_in <= "10";
wait for second_2;
wait for second_2;
AXI_cmd_in <= "00";
wait until AXI_state_out = "000";
wait for second_2;
wait for second_2;
AXI_address_in <= x"00000009";
AXI_cmd_in <= "10";
wait for second_2;
wait for second_2;
AXI_cmd_in <= "00";
wait until AXI_state_out = "000";
wait for second_2;
wait for second_2;
--r_request <= '1';
--r_address_DMA_in	<= x"0064";
--wait for second_2;
--r_address_DMA_in <= x"0000";
wait for second_10;
ready <= '1';
wait for second_3;
ready<= '0';
wait for second_10;
wait for second_10;
wait for second_10;
wait for second_10;
end process;

end Test;
