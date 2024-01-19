LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
entity tb_control_unit_DMA Is
end tb_control_unit_DMA;

architecture mashup of tb_control_unit_DMA IS 

signal clk 			         : std_logic;
signal rst			         : std_logic;
signal ready			      : std_logic;

signal AXI_address_in		: std_logic_vector (31 downto 0);
signal AXI_data_in			: std_logic_vector (31 downto 0);
signal AXI_cmd_in          : std_logic_vector (1 downto 0);
signal AXI_data_out			: std_logic_vector (31 downto 0);
signal AXI_flag_out        : std_logic;

signal RAM_data_in         : std_logic_vector (31 downto 0);
signal RAM_data_out        : std_logic_vector (31 downto 0);
signal RAM_address_out     : std_logic_vector (31 downto 0);
signal RAM_cmd_out         : std_logic_vector (1 downto 0);

signal APB_address_out     : std_logic_vector (7 downto 0);
signal APB_data_out 	      : std_logic_vector (31 downto 0);

signal AXI_state_out		   : std_logic_vector (2 downto 0);
signal RAM_state_out		   : std_logic_vector (2 downto 0);
signal APB_state_out		   : std_logic_vector (2 downto 0);

--signal r_data_DMA_RAM		: std_logic_vector (0 to 63);
--signal r_command_DMA_RAM	: std_logic_vector (0 to 1);
--signal r_address_DMA_RAM	: std_logic_vector (0 to 15);
--signal r_cs_DMA_RAM		: std_logic;


component control_unit_DMA is 
port ( 						  
	clk				         : in 	std_logic; 
	ready 			         : in	std_logic;
	rst				         : in 	std_logic;
	
	AXI_address_in 		: in	std_logic_vector (31 downto 0); 
	AXI_data_in			      : in	std_logic_vector (31 downto 0);
	AXI_cmd_in        : IN std_logic_vector (1 downto 0);
	AXI_data_out      :OUT std_logic_vector (31 downto 0);
	AXI_flag_out        : OUT std_logic; 

	APB_address_out			   : out std_logic_vector (7 downto 0); 
	APB_data_out			      : out	std_logic_vector (31 downto 0); 
	
	RAM_data_out           : out std_logic_vector (31 downto 0);
	RAM_address_out       : out std_logic_vector (31 downto 0);
	RAM_cmd_out : OUT std_logic_vector (1 downto 0);
	RAM_data_in : IN std_logic_vector (31 downto 0);
	
	AXI_state_out			         : out	std_logic_vector (2 downto 0);
	RAM_state_out		:OUT	std_logic_vector (2 downto 0);
	APB_state_out		:OUT	std_logic_vector (2 downto 0)
	); 
end component;



component RAM is 
port (
	rst				         : in std_logic; 
	ready				      : in std_logic; 
	clk				         : in std_logic; 
	RAM_cmd_out			      : in std_logic_vector (1 downto 0);
	
	RAM_data_out		 	   : in std_logic_vector (31 downto 0); 
	RAM_address_out			   : in std_logic_vector (31 downto 0); 
--	r_DMA_cs			         : in std_logic; 
--	r_DMA_data_in	 		   : in std_logic_vector (0 to 63); 
--	r_DMA_command			   : in std_logic_vector (0 to 1); 
--	r_DMA_address			   : in std_logic_vector (0 to 15);
	RAM_data_in			   : out std_logic_vector (31 downto 0)
	); 
end component;




component Tester is 
Port (
	
	AXI_data_in		  			: out std_logic_vector (31 downto 0); 
	AXI_address_in		  		: out	std_logic_vector (31 downto 0); 
	AXI_flag_out            : IN std_logic;
	AXI_data_out            : IN  std_logic_vector (31 downto 0);
	AXI_state_out		  	   : in	std_logic_vector (2 downto 0); 
	AXI_cmd_in              :OUT  std_logic_vector (1 downto 0);
	RAM_state_out		      : IN	std_logic_vector (2 downto 0);
	APB_state_out		      : IN	std_logic_vector (2 downto 0);
	ready 			         : out	std_logic;
	clk				         : out	std_logic; 
	rst				         : out	std_logic
	); 
END component; 

begin 
inst_control_unit_DMA : control_unit_DMA PORT MAP (
   clk 							=> clk,
   ready						=> ready,
   rst						=> rst,
		  
	AXI_address_in			=> AXI_address_in,
   AXI_data_in					=> AXI_data_in,
	AXI_cmd_in           => AXI_cmd_in,
	AXI_data_out             =>  AXI_data_out,
	AXI_flag_out         =>   AXI_flag_out,
		  
   APB_address_out				=> APB_address_out,
   APB_data_out					=> APB_data_out,
   AXI_state_out						=> AXI_state_out,
	RAM_state_out			   		=> RAM_state_out,
	APB_state_out			   		=> APB_state_out,
	
	RAM_data_out     		=>RAM_data_out,
	RAM_address_out  		=>RAM_address_out,
	RAM_cmd_out          =>RAM_cmd_out,
	RAM_data_in          =>RAM_data_in
	);

inst_RAM : RAM PORT MAP (
   clk 							=> clk,
   rst 							=> rst,
   ready 						=> ready,
	
   RAM_cmd_out	            => RAM_cmd_out,
   RAM_data_out				=> RAM_data_out,	
   RAM_address_out				=> RAM_address_out,
-- r_DMA_cs			  			=> r_cs_DMA_RAM,
-- r_DMA_data_in				=> r_data_DMA_RAM,
-- r_DMA_command				=> r_command_DMA_RAM,
-- r_DMA_address				=> r_address_DMA_RAM,
	RAM_data_in				=> RAM_data_in --
	);

inst_Tester : Tester PORT MAP (
	ready 			  			=> ready,
	clk				      	=> clk,
	rst				  			=> rst,
	
	AXI_flag_out            => AXI_flag_out,
	AXI_data_in             =>  AXI_data_in,
	AXI_address_in			=> AXI_address_in,
	AXI_cmd_in              => AXI_cmd_in,
	AXI_data_out            => AXI_data_out,
	
	
	AXI_state_out			   		=> AXI_state_out,
	RAM_state_out			   		=> RAM_state_out,
	APB_state_out			   		=> APB_state_out
	);
end mashup;
