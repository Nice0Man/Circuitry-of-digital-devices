LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all; 
Entity Tester is 
Port (
	ready 		:OUT	std_logic;
	ACLK			:OUT	std_logic;
	ARESETn			:OUT	std_logic;
	
	AXI_AWADDR			:OUT	std_logic_vector (31 downto 0);
	AXI_ARADDR			:OUT	std_logic_vector (31 downto 0);
	AXI_WDATA			:OUT 	std_logic_vector (31 downto 0);
	AXI_RDATA         :IN  std_logic_vector (31 downto 0);
	AXI_WLAST  			:OUT std_logic;
	AXI_AWLEN         :OUT std_logic_vector(3 downto 0);
	AXI_WVALID   		:OUT std_logic;
	AXI_WREADY   	 	:IN std_logic;
	AXI_RVALID   		:IN std_logic;
	AXI_RREADY   	 	:OUT std_logic;
	AXI_AWVALID     	:OUT std_logic;
	AXI_AWREADY     	:IN std_logic;
	AXI_ARVALID     	:OUT std_logic;
	AXI_ARREADY     	:IN std_logic;
	AXI_BRESP      	:IN std_logic_vector(1 downto 0);
	AXI_BVALID     	:IN std_logic;
	AXI_BREADY     	:OUT std_logic;
	AXI_RRESP         :IN std_logic_vector(1 downto 0);
	
	APB_PRDATA			:OUT	std_logic_vector (31 downto 0);
	APB_PREADY    		:OUT  std_logic;
	
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
	ACLK <= '0';
	WAIT FOR second;
	ACLK <= '1';
	WAIT FOR second;
END PROCESS;

work: 
Process
Begin
wait for second;
AXI_AWADDR <= x"00000000";
AXI_ARADDR <= x"00000000";
AXI_WDATA <= x"00000000";
AXI_WLAST <= '0';
AXI_AWLEN <= "0000";
AXI_WVALID <= '0';
AXI_AWVALID <= '0';
AXI_ARVALID <= '0';
AXI_BREADY <= '0';
AXI_RREADY <= '0';

ready <= '0';
ARESETn<= '0';
wait for second_2;
ARESETn <= '1';
wait for second_2;
AXI_AWADDR <= x"00000003";
AXI_WDATA <= x"F00F01AF";
AXI_WLAST <= '0';
AXI_AWLEN <= "1001";
wait for 5 ns;
AXI_WVALID <= '1';
AXI_AWVALID <= '1';
wait until AXI_WREADY = '1';
AXI_AWLEN <= "0000";
AXI_AWVALID <= '0';
AXI_WVALID <= '0';
AXI_WDATA <= x"F12C01FF";
AXI_WVALID <= '1';
wait until AXI_WREADY = '1';
AXI_WLAST <= '1';
AXI_WVALID <= '0';
AXI_WDATA <= x"FBCD012A";
AXI_WVALID <= '1';
wait until AXI_WREADY = '1';
AXI_WLAST <= '0';
AXI_WVALID <= '0';
AXI_WDATA <= x"FAABBB0A";
AXI_WVALID <= '1';
wait until AXI_WREADY = '1';
AXI_WVALID <= '0';
AXI_WDATA <= x"FFFFFFFF";
AXI_WVALID <= '1';
wait until AXI_WREADY = '1';
AXI_WLAST <= '1';
AXI_WVALID <= '0';
AXI_WDATA <= x"F5555555";
AXI_WVALID <= '1';
wait until AXI_WREADY = '1';
AXI_WLAST <= '0';
AXI_WVALID <= '0';
AXI_WDATA <= x"F2222222";
AXI_WVALID <= '1';
wait until AXI_WREADY = '1';
AXI_WVALID <= '0';
AXI_WDATA <= x"F1111111";
AXI_WVALID <= '1';
wait until AXI_WREADY = '1';
AXI_WLAST <= '1';
AXI_WVALID <= '0';
AXI_WDATA <= x"006800F0";
AXI_WVALID <= '1';
wait until AXI_state_out = "000";
AXI_WLAST <= '0';
AXI_WVALID <= '0';
AXI_BREADY <= '1';
APB_PREADY <= '1';
wait until APB_state_out = "000";
APB_PREADY <= '0';
wait for second_2;
AXI_BREADY <= '0';
AXI_ARADDR <= x"00000006";
AXI_WDATA <= x"00000000";
AXI_ARVALID <= '1';
AXI_RREADY <= '1';
wait for second_2;
wait for second_2;
AXI_ARVALID <= '0';
wait until AXI_state_out = "000";
wait for second_2;
wait for second_2;
AXI_ARADDR <= x"00000009";
AXI_ARVALID <= '1';
wait for second_2;
wait for second_2;
AXI_ARVALID <= '0';
wait until AXI_state_out = "000";
wait for second_2;
wait for second_2;
AXI_RREADY <= '0';
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
