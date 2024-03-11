LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all; 
entity control_unit_DMA is 
generic(
   N           :integer := 15 
	);
port ( 						  
	ACLK			:IN 	std_logic;
	ARESETn			:IN 	std_logic;
	ready 		:IN	std_logic; 
	
	AXI_AWADDR 		:IN	std_logic_vector (31 downto 0);
	AXI_ARADDR 		:in	std_logic_vector (31 downto 0); 
	AXI_WDATA		:IN	std_logic_vector (31 downto 0);
	AXI_RDATA  		:OUT std_logic_vector (31 downto 0);
	AXI_WLAST  		:IN std_logic;
	AXI_AWLEN      :IN std_logic_vector(3 downto 0);
	AXI_WVALID     :IN std_logic;
	AXI_WREADY     :OUT std_logic;
	AXI_RVALID     :OUT std_logic;
	AXI_RREADY     :IN std_logic;
	AXI_AWVALID    :IN std_logic;
	AXI_AWREADY    :OUT std_logic;
	AXI_ARVALID    :IN std_logic;
	AXI_ARREADY    :OUT std_logic;
	AXI_BRESP      :OUT std_logic_vector(1 downto 0);
	AXI_BVALID     :OUT std_logic;
	AXI_BREADY     :IN std_logic;
	AXI_RRESP      :OUT std_logic_vector(1 downto 0);

	
	APB_PADDR		:OUT 	std_logic_vector (7 downto 0);
	APB_PWDATA		:OUT	std_logic_vector (31 downto 0);
	APB_PRDATA		:IN	std_logic_vector (31 downto 0);
	APB_PWRITE     :OUT std_logic;
	APB_PENABLE    :OUT std_logic;
	APB_PSELx      :OUT std_logic;
	APB_PREADY     :IN std_logic;
	
	RAM_data_out : OUT std_logic_vector (31 downto 0);
	RAM_address_out : OUT std_logic_vector (31 downto 0);
	RAM_cmd_out : OUT std_logic_vector (1 downto 0);
	RAM_data_in : IN std_logic_vector (31 downto 0);
	
	AXI_state_out		:OUT	std_logic_vector (2 downto 0); 
	RAM_state_out		:OUT	std_logic_vector (2 downto 0);
	APB_state_out		:OUT	std_logic_vector (2 downto 0)
	);

end control_unit_DMA;

architecture FSM of control_unit_DMA IS 

	TYPE state_type_AXI IS (free, regfill_CPU, regfill_RAM, send_RAM, send_CPU);
	TYPE state_type_RAM IS (free, regfill_RAM, send_RAM); 
	TYPE state_type_APB IS (free, send_APB, regfill_APB); 
	
	signal state_AXI 			  		: state_type_AXI;
	signal state_RAM 			  		: state_type_RAM;
	signal state_APB 			  		: state_type_APB;
	
	signal buff_state_AXI 			  		: std_logic_vector (2 downto 0);
	signal buff_state_RAM 			  		: std_logic_vector (2 downto 0);
	signal buff_state_APB 			  		: std_logic_vector (2 downto 0);
	signal buff_AWLEN   						: std_logic_vector(3 downto 0);
	signal buff_BVALID                  : std_logic;
	signal buff_flag                    : std_logic;
	
	signal counter                : std_logic_vector(3 downto 0); -- порядковый номер последовательно поступающих данных
	
   signal buff_data 					: std_logic_vector (31 downto 0);
	signal buff_address				: std_logic_vector (31 downto 0);
	signal RAM_Addr_count  			: std_logic_vector (31 downto 0);-----------------------------

	
	begin
	
	RAM_address_out <= RAM_Addr_count;---------------------------------------------------------
	
	state_AXI_proc:
	process (ACLK)
	begin 
		IF (ARESETn = '0') then 
			state_AXI <= free;
		ELSIF (rising_edge(ACLK)) then
			IF (ready = '1') then 
			state_AXI <= state_AXI;
			else
				CASE state_AXI is 
					when free =>
						if (AXI_AWVALID = '1') then
							state_AXI <= regfill_CPU;
						elsif (AXI_ARVALID = '1') then
							state_AXI <= regfill_RAM;
						else
							state_AXI <= free;
						end if;
				
					when regfill_CPU =>
						state_AXI <= send_RAM;
					when regfill_RAM => 
						if (state_RAM = regfill_RAM) then
							state_AXI <= send_CPU;
						else
							state_AXI <= state_AXI;
						end if;
						
					when send_RAM =>   
						if (AXI_WLAST = '1' and counter = buff_AWLEN) then
							state_AXI <= free;
						else
							state_AXI <= regfill_CPU;
						end if;
					
						
					when send_CPU =>
						state_AXI <= free;
						
						
				end case;
			end if;			
		end if;
	end process;
	
state_RAM_proc:
	process (ACLK)
	begin 
		IF ARESETn = '0' then 
			state_RAM <= free;
		ELSIF (rising_edge(ACLK)) then
				CASE state_RAM is 
					when free =>
						if (state_AXI = send_RAM) then
							state_RAM <= send_RAM;
						elsif (state_AXI = regfill_RAM) then
							state_RAM <= regfill_RAM;
						else
							state_RAM <= free;
						end if;
				
					when send_RAM =>
						state_RAM <= free;
					
					when regfill_RAM => 
						state_RAM <= free;					
						
				end case;	
		end if;
	end process;

state_APB_proc:
	process (ACLK,ARESETn)
	begin 
		IF ARESETn = '0' then 
			state_APB <= free;
		ELSIF (rising_edge(ACLK)) then
			IF (ready = '1') then 
			state_APB <= state_APB;
			else
				CASE state_APB is 
					when free =>
						if (state_AXI = send_RAM and AXI_WLAST = '1' and counter = buff_AWLEN) then    
							state_APB <= send_APB;
						else
							state_APB <= free;
						end if;
				
					when send_APB =>
						state_APB <= free;	
							
					when regfill_APB =>
						if(APB_PREADY = '1') then
							state_APB <= free;
						else
							state_APB <= state_APB;
						end if;
				end case;	
			end if;			
		end if;
	end process;

proces_sig: 
Process (state_AXI, state_RAM, state_APB)
begin
	-------------------------------------in_sig----------------------------------------------
	
	----------------------------------counter-----------------------------------------
	IF (ready = '1') then 
		counter<= counter;
	else
		IF (state_AXI = regfill_CPU) then 
			counter <= counter + "0001";
				
		elsif( state_AXI = send_RAM or state_AXI = send_CPU or state_AXI = send_RAM or state_AXI = regfill_RAM) then
			counter <= counter;
			 
		elsif (state_AXI =  free ) then
			counter <= "0000";
		end if;
	end if;
	
	
	----------------------------------buff_AWLEN-----------------------------------------
	IF (ready = '1') then 
		buff_AWLEN<= buff_AWLEN;
	else
		IF (state_AXI = regfill_CPU and AXI_AWVALID ='1') then 
			buff_AWLEN <= AXI_AWLEN;
				
		elsif( state_AXI = send_RAM or state_AXI = send_CPU or state_AXI = send_RAM or state_AXI = regfill_RAM) then
			buff_AWLEN <= buff_AWLEN;
			 
		elsif (state_AXI =  free ) then
			buff_AWLEN <= "0000";
		end if;
	end if;
	
	
	----------------------------------buff_address-----------------------------------------
	IF (ready = '1') then 
		buff_address<= buff_address;
	else
		IF (state_AXI = regfill_CPU and AXI_AWVALID ='1') then 
			buff_address <= AXI_AWADDR;
				
		elsif (state_AXI = regfill_RAM and AXI_ARVALID ='1') then 
			buff_address <= AXI_ARADDR;
			
		elsif( state_AXI = send_RAM or state_AXI = send_CPU) then
			buff_address <= buff_address;
			 
		elsif (state_AXI =  free ) then
			buff_address <= x"00000000";
		end if;
	end if;
	
	
	-------------------------------------buff_data---------------------------------------
	
	IF (ready = '1') then
		buff_data <= buff_data;
	else
		IF (state_RAM = regfill_RAM or state_AXI = send_CPU) then
			buff_data <= RAM_data_in;
		
		elsif (state_AXI = regfill_CPU and AXI_WVALID = '1') then
			buff_data <= AXI_WDATA;
			
		elsif (state_AXI = send_RAM or state_AXI = regfill_RAM) then 
			buff_data <= buff_data;
			
		elsif (state_AXI = free) then
			buff_data <= x"00000000";
		end if;
	end if;
	
	
	--------------------------------------buff_BVALID-------------------------------------------------------
		IF (ready = '1') then
		buff_BVALID <= '0';
	else
		IF(state_APB = send_APB) then --state_AXI = send_RAM and AXI_WLAST = '1' and counter = buff_AWLEN
			buff_BVALID <= '1';
			AXI_BRESP <= "00";
		elsif(state_AXI = free) then
			IF(AXI_BREADY ='1' and buff_BVALID = '1') then
				AXI_BVALID <= '0';
			elsif(AXI_BREADY ='0' and buff_BVALID = '1') then
				AXI_BVALID <= '1';
			else
				AXI_BVALID <= '0';
			end if;
		elsif (state_AXI = send_RAM or state_AXI = regfill_CPU or state_AXI = send_CPU or state_AXI = regfill_RAM) then 
			buff_BVALID <= '0';
		end if;
	end if; 					
	
	----------------------------------buff_flag-----------------------------------------
	IF (ready = '1') then 
		buff_flag<= buff_flag;
	else
		if( state_AXI = free or state_AXI = send_CPU or state_AXI = regfill_RAM or state_AXI = regfill_CPU) then
			buff_flag <= '0';
		elsif (state_AXI = send_RAM ) then
			buff_flag <= '1';
		end if;
	end if;
	-----------------------------------------------------------------------------------------------------------
	
	
	-------------------------------------out_sig-----------------------------------------

	
	
	------------------------------------APB_PWDATA------------------------------------------
	IF (ready = '1') then
		APB_PWDATA <= x"00000000";
	else
		IF (state_APB = send_APB) then 
			APB_PWDATA <= buff_address;
		elsif(state_APB = free) then 
			APB_PWDATA <= x"00000000";
		end if; 
	end if;
	
	
	------------------------------------APB_PADDR--------------------------------------------
	IF (ready = '1') then
		APB_PADDR <= x"00";
	else
		IF (state_APB = free) then 
			APB_PADDR <= x"00";
		elsif (state_APB = send_APB) then
			APB_PADDR <= x"11";
		end if;
	end if; 
	
	------------------------------------APB_PWRITE--------------------------------------------
	IF (ready = '1') then
		APB_PWRITE <= 'Z';
	else
		IF (state_APB = free) then 
			APB_PWRITE <= 'Z';
		elsif (state_APB = send_APB) then
			APB_PWRITE <= '1';
		elsif (state_APB = regfill_APB) then
			APB_PWRITE <= '0';
		end if;
	end if;
	
	------------------------------------APB_PENABLE--------------------------------------------
	IF (ready = '1') then
		APB_PENABLE <= '0';
	else
		IF (state_APB = free) then 
			APB_PENABLE <= '0';
		elsif (state_APB = send_APB) then
			APB_PENABLE <= '1';
		elsif (state_APB = regfill_APB) then
			APB_PENABLE <= '1';
		end if;
	end if;
	
	------------------------------------APB_PSELx--------------------------------------------
	IF (ready = '1') then
		APB_PSELx <= 'Z';
	else
		IF (state_APB = free) then 
			APB_PSELx <= '0';
		elsif (state_APB = send_APB) then
			APB_PSELx <= '1';
		elsif (state_APB = regfill_APB) then
			APB_PSELx <= '1';
		end if;
	end if;

	
	---------------------------------------RAM_address_out------------------------------------------------
	IF (ready = '1') then
		RAM_address_out <= x"00000000";
	else
		IF (state_RAM = free) then 
--			RAM_address_out <= x"00000000";
		elsif (state_RAM = send_RAM) then
			RAM_address_out <= buff_address + counter - "0001";
		elsif(state_RAM = regfill_RAM) then
			RAM_address_out <= buff_address;
		end if;
	end if;
	
	---------------------------------------RAM_data_out------------------------------------------------
	IF (ready = '1') then
		RAM_data_out <= x"00000000";
	else
		IF (state_RAM = free or state_RAM = regfill_RAM) then 
--			RAM_data_out <= x"00000000";
		elsif (state_RAM = send_RAM) then
			RAM_data_out <= buff_data;
		end if;
	end if;

	---------------------------------------RAM_cmd_out------------------------------------------------
	IF (ready = '1') then
		RAM_cmd_out <= "00";
	else
		IF (state_RAM = free) then 
			RAM_cmd_out <= "00";
		elsif (state_RAM = send_RAM) then
			RAM_cmd_out <= "11";
		elsif (state_RAM = regfill_RAM) then
			RAM_cmd_out <= "10";
		end if;
	end if;	
	--------------------------------------AXI_RDATA-------------------------------------------------------
	IF (ready = '1') then
		AXI_RDATA <= x"00000000";
	else
		IF (state_AXI = free or state_AXI = regfill_RAM or state_AXI = regfill_CPU or state_AXI = send_RAM) then 
			AXI_RDATA <= x"00000000";
		elsif (state_AXI = send_CPU) then
			AXI_RDATA <= RAM_data_in;--buff_data;
		end if;
	end if;

	
	--------------------------------------AXI_WREADY-------------------------------------------------------
		IF (ready = '1') then
		AXI_WREADY <= '0';
	else
		IF (state_AXI = regfill_RAM or state_AXI = send_CPU) then 
			AXI_WREADY <= '0';
		elsif (state_AXI = free or state_AXI = regfill_CPU) then
			AXI_WREADY <= '1';
		elsif(state_AXI = send_RAM) then
			IF (buff_flag = '1') then
				AXI_WREADY <= '1';
			else
				AXI_WREADY <= '0';
			end if;
		end if;
	end if;
	
	--------------------------------------AXI_RVALID-------------------------------------------------------
		IF (ready = '1') then
		AXI_RVALID <= '0';
	else
		IF (state_AXI = regfill_RAM or state_AXI = send_RAM or state_AXI = regfill_CPU or state_AXI = free) then 
			AXI_RVALID <= '0';
		elsif (state_AXI = send_CPU) then
			AXI_RVALID <= '1';
			AXI_RRESP  <= "00";
		end if;
	end if;
	
	--------------------------------------AXI_AWREADY-------------------------------------------------------
		IF (ready = '1') then
		AXI_AWREADY <= '0';
	else
		IF (state_AXI = send_RAM or state_AXI = regfill_RAM or state_AXI = send_CPU) then 
			AXI_AWREADY <= '0';
		elsif ((state_AXI = regfill_CPU and counter = "0000")  or state_AXI = free) then
			AXI_AWREADY <= '1';
		end if;
	end if;

	--------------------------------------AXI_ARREADY-------------------------------------------------------
		IF (ready = '1') then
		AXI_ARREADY <= '0';
	else
		IF (state_AXI = send_RAM or state_AXI = regfill_CPU or state_AXI = send_CPU) then 
			AXI_ARREADY <= '0';
		elsif (state_AXI = regfill_RAM  or state_AXI = free) then
			AXI_ARREADY <= '1';
		end if;
	end if;
	
	--------------------------------------AXI_BRESP-------------------------------------------------------
		IF (ready = '1') then
		AXI_BVALID <= '0';
	else
		if(state_AXI = free) then
			AXI_BVALID <= buff_BVALID;
		elsif (state_AXI = send_RAM or state_AXI = regfill_CPU or state_AXI = send_CPU or state_AXI = regfill_RAM) then 
			AXI_BVALID <= '0';
		end if;
	end if; 
	
end process; 







AXI_state:
PROCESS (state_AXI)
begin
	case state_AXI is 
		when free =>
			AXI_state_out <= "000";
			buff_state_AXI <= "000";
		when regfill_CPU =>
			AXI_state_out <= "110";
			buff_state_AXI <= "110";
		when regfill_RAM =>
			AXI_state_out <= "100";
			buff_state_AXI <= "100";
		when send_RAM =>
			AXI_state_out <= "111";
			buff_state_AXI <= "111";
		when send_CPU =>
			AXI_state_out <= "101";
			buff_state_AXI <= "101";
		end case;
end process;

RAM_state:
PROCESS (state_RAM)
begin
	case state_RAM is 
		when free =>
			RAM_state_out <= "000";
			buff_state_RAM <= "000";
		when send_RAM =>
			RAM_state_out <= "110";
			buff_state_RAM <= "110";
		when regfill_RAM =>
			RAM_state_out <= "100";
			buff_state_RAM <= "100";
		end case;
end process;

APB_state:
PROCESS (state_APB)
begin
	case state_APB is 
		when free =>
			APB_state_out <= "000";
			buff_state_APB <= "000";
		when send_APB =>
			APB_state_out <= "110";
			buff_state_APB <= "110";
		when regfill_APB =>
			APB_state_out <= "100";
			buff_state_APB <= "100";
		end case;
end process;
end FSM;
