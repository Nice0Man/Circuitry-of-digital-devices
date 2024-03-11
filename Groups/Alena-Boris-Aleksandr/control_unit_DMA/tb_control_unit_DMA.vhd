LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
entity tb_control_unit_DMA Is
end tb_control_unit_DMA;

architecture mashup of tb_control_unit_DMA IS 

signal ACLK 			         : std_logic;
signal ARESETn			         : std_logic;
signal ready			      : std_logic;

signal AXI_AWADDR		: std_logic_vector (31 downto 0);
signal AXI_ARADDR		: std_logic_vector (31 downto 0);
signal AXI_WDATA			: std_logic_vector (31 downto 0);
signal AXI_RDATA			: std_logic_vector (31 downto 0);
signal AXI_WLAST           : std_logic;
signal AXI_AWLEN           : std_logic_vector (3 downto 0);
signal AXI_WVALID         : std_logic;
signal AXI_WREADY         : std_logic;
signal AXI_RVALID         : std_logic;
signal AXI_RREADY         : std_logic;
signal AXI_AWVALID         : std_logic;
signal AXI_AWREADY         : std_logic;
signal AXI_ARVALID         : std_logic;
signal AXI_ARREADY         : std_logic;
signal AXI_BRESP      		: std_logic_vector(1 downto 0);
signal AXI_BVALID     		: std_logic;
signal AXI_BREADY     		: std_logic;
signal AXI_RRESP      		: std_logic_vector(1 downto 0);

signal RAM_data_in         : std_logic_vector (31 downto 0);
signal RAM_data_out        : std_logic_vector (31 downto 0);
signal RAM_address_out     : std_logic_vector (31 downto 0);
signal RAM_cmd_out         : std_logic_vector (1 downto 0);

signal RAM_data_in_fedya         : std_logic_vector (31 downto 0);
signal RAM_data_out_fedya        : std_logic_vector (31 downto 0);
signal RAM_address_out_fedya     : std_logic_vector (31 downto 0);
signal RAM_cmd_out_fedya         : std_logic_vector (1 downto 0);

signal APB_PADDR     		: std_logic_vector (7 downto 0);
signal APB_PWDATA 	      : std_logic_vector (31 downto 0);
signal APB_PRDATA				: std_logic_vector (31 downto 0);
signal APB_PWRITE    		: std_logic;
signal APB_PENABLE    		: std_logic;
signal APB_PSELx     		: std_logic;
signal APB_PREADY    		: std_logic;

signal AXI_state_out		   : std_logic_vector (2 downto 0);
signal RAM_state_out		   : std_logic_vector (2 downto 0);
signal APB_state_out		   : std_logic_vector (2 downto 0);



component control_unit_DMA is 
port ( 						  
	ACLK				         : in 	std_logic; 
	ready 			         : in	std_logic;
	ARESETn				         : in 	std_logic;
	
	AXI_AWADDR 		: in	std_logic_vector (31 downto 0); 
	AXI_ARADDR 		: in	std_logic_vector (31 downto 0); 
	AXI_WDATA			      : in	std_logic_vector (31 downto 0);
	AXI_RDATA      :OUT std_logic_vector (31 downto 0);
	AXI_WLAST         :IN std_logic;
	AXI_AWLEN         :IN std_logic_vector (3 downto 0);
	AXI_WVALID   		:IN std_logic;
	AXI_WREADY   	 	:OUT std_logic;
	AXI_RVALID   		:OUT std_logic;
	AXI_RREADY   	 	:IN std_logic;
	AXI_AWVALID    	:IN std_logic;
	AXI_AWREADY    	:OUT std_logic;
	AXI_ARVALID    	:IN std_logic;
	AXI_ARREADY    	:OUT std_logic;
	AXI_BRESP      	:OUT std_logic_vector(1 downto 0);
	AXI_BVALID     	:OUT std_logic;
	AXI_BREADY     	:IN std_logic;
	AXI_RRESP     	   :OUT std_logic_vector(1 downto 0);

	

	APB_PADDR			   	: out std_logic_vector (7 downto 0); 
	APB_PWDATA			      : out	std_logic_vector (31 downto 0);
	APB_PRDATA					:in	std_logic_vector (31 downto 0);
	APB_PWRITE     			:OUT std_logic;
	APB_PENABLE    			:OUT std_logic;
	APB_PSELx      			:OUT std_logic;	
	APB_PREADY    				:in  std_logic;
	
	RAM_data_out           	: out std_logic_vector (31 downto 0);
	RAM_address_out       	: out std_logic_vector (31 downto 0);
	RAM_cmd_out 				: OUT std_logic_vector (1 downto 0);
	RAM_data_in 				: IN std_logic_vector (31 downto 0);
	
	AXI_state_out			         : out	std_logic_vector (2 downto 0);
	RAM_state_out		:OUT	std_logic_vector (2 downto 0);
	APB_state_out		:OUT	std_logic_vector (2 downto 0)
	); 
end component;



component RAM is 
port (
	ARESETn				         : in std_logic; 
	ready				      : in std_logic; 
	ACLK				         : in std_logic; 
	
	RAM_cmd_out_0			      : in std_logic_vector (1 downto 0);
	RAM_data_out_0		 	   : in std_logic_vector (31 downto 0); 
	RAM_address_out_0			   : in std_logic_vector (31 downto 0); 
	RAM_data_in_0			   : out std_logic_vector (31 downto 0);
	
	RAM_cmd_out_1			: in std_logic_vector (1 downto 0);
	RAM_data_out_1		 	: in std_logic_vector (31 downto 0);
	RAM_address_out_1		: in std_logic_vector (31 downto 0);
	RAM_data_in_1			: out std_logic_vector (31 downto 0)
	
	); 
end component;




component Tester is 
Port (
	
	AXI_AWADDR		  			: out	std_logic_vector (31 downto 0); 
	AXI_ARADDR		  			: out	std_logic_vector (31 downto 0); 
	AXI_WDATA		  			: out std_logic_vector (31 downto 0); 
	AXI_RDATA           		: IN  std_logic_vector (31 downto 0);
	AXI_WLAST        			: OUT std_logic;
	AXI_AWLEN         		: OUT std_logic_vector (3 downto 0);
	AXI_WVALID   				: OUT std_logic;
	AXI_WREADY   	 			: IN std_logic;
	AXI_RVALID   				: IN std_logic;
	AXI_RREADY   	 			: OUT std_logic;
	AXI_AWVALID     			: OUT std_logic;
	AXI_AWREADY     			: IN std_logic;
	AXI_ARVALID     			: OUT std_logic;
	AXI_ARREADY     			: IN std_logic;
	AXI_BRESP      			: IN std_logic_vector(1 downto 0);
	AXI_BVALID     			: IN std_logic;
	AXI_BREADY     			: OUT std_logic;
	AXI_RRESP         :IN std_logic_vector(1 downto 0);
	
	APB_PRDATA			:OUT	std_logic_vector (31 downto 0);
	APB_PREADY    		:OUT  std_logic;
	
	AXI_state_out		  	   : in	std_logic_vector (2 downto 0); 
	RAM_state_out		      : IN	std_logic_vector (2 downto 0);
	APB_state_out		      : IN	std_logic_vector (2 downto 0);
	ready 			         : out	std_logic;
	ACLK				         : out	std_logic; 
	ARESETn				         : out	std_logic
	); 
END component; 

begin 
inst_control_unit_DMA : control_unit_DMA PORT MAP (
   ACLK 							=> ACLK,
   ready						=> ready,
   ARESETn						=> ARESETn,
		  
	AXI_AWADDR			=> AXI_AWADDR,
	AXI_ARADDR			=> AXI_ARADDR,
   AXI_WDATA					=> AXI_WDATA,
	AXI_RDATA             =>  AXI_RDATA,
	AXI_WLAST            => AXI_WLAST,
	AXI_AWLEN            => AXI_AWLEN,
	AXI_WVALID          => AXI_WVALID,
	AXI_WREADY          => AXI_WREADY,
	AXI_RVALID          => AXI_RVALID,
	AXI_RREADY          => AXI_RREADY,
	AXI_AWVALID     		=> AXI_AWVALID,
	AXI_AWREADY     		=> AXI_AWREADY,  
	AXI_ARVALID     		=> AXI_ARVALID, 
	AXI_ARREADY     		=> AXI_ARREADY, 
	AXI_BRESP      		=> AXI_BRESP,
	AXI_BVALID     		=> AXI_BVALID,
	AXI_BREADY     	   => AXI_BREADY,
	AXI_RRESP            => AXI_RRESP,
		  
   APB_PADDR				=> APB_PADDR,
   APB_PWDATA				=> APB_PWDATA,
	APB_PRDATA				=> APB_PRDATA,
	APB_PWRITE           => APB_PWRITE,
	APB_PENABLE           => APB_PENABLE,
	APB_PSELx            => APB_PSELx,
	APB_PREADY           => APB_PREADY,
   AXI_state_out						=> AXI_state_out,
	RAM_state_out			   		=> RAM_state_out,
	APB_state_out			   		=> APB_state_out,
	
	RAM_data_out     		=>RAM_data_out,
	RAM_address_out  		=>RAM_address_out,
	RAM_cmd_out          =>RAM_cmd_out,
	RAM_data_in          =>RAM_data_in
	);

inst_RAM : RAM PORT MAP (
   ACLK 							=> ACLK,
   ARESETn 							=> ARESETn,
   ready 						=> ready,
	
   RAM_cmd_out_0	            => RAM_cmd_out,
   RAM_data_out_0				=> RAM_data_out,	
   RAM_address_out_0				=> RAM_address_out,
	RAM_data_in_0				=> RAM_data_in,
	
	RAM_cmd_out_1	            => RAM_cmd_out_fedya,
   RAM_data_out_1				   => RAM_data_out_fedya,	
   RAM_address_out_1				=> RAM_address_out_fedya,
	RAM_data_in_1				   => RAM_data_in_fedya 
	);

inst_Tester : Tester PORT MAP (
	ready 			  			=> ready,
	ACLK				      	=> ACLK,
	ARESETn				  			=> ARESETn,
	
	AXI_AWADDR		      	=> AXI_AWADDR,
	AXI_ARADDR			      => AXI_ARADDR,
	AXI_WDATA             => AXI_WDATA,
	AXI_RDATA            => AXI_RDATA,
	AXI_WLAST            => AXI_WLAST,
	AXI_AWLEN            => AXI_AWLEN,
	AXI_WVALID          => AXI_WVALID,
	AXI_WREADY          => AXI_WREADY,
	AXI_RVALID          => AXI_RVALID,
	AXI_RREADY          => AXI_RREADY,
	AXI_AWVALID     		=> AXI_AWVALID,
	AXI_AWREADY     		=> AXI_AWREADY,  
	AXI_ARVALID     		=> AXI_ARVALID, 
	AXI_ARREADY     		=> AXI_ARREADY, 
	AXI_BRESP      		=> AXI_BRESP,
	AXI_BVALID     		=> AXI_BVALID,
	AXI_BREADY     	   => AXI_BREADY,
	AXI_RRESP            => AXI_RRESP,

	APB_PRDATA				=> APB_PRDATA,
	APB_PREADY           => APB_PREADY,
	
	AXI_state_out			   		=> AXI_state_out,
	RAM_state_out			   		=> RAM_state_out,
	APB_state_out			   		=> APB_state_out
	);
end mashup;
