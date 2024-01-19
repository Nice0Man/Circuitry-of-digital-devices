LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all; 
entity control_unit_DMA is 
generic(
   N           :integer := 15 
	);
port ( 						  
	clk			:IN 	std_logic;
	ready 		:IN	std_logic; 
	rst			:IN 	std_logic;
	
	AXI_address_in 	:IN	std_logic_vector (31 downto 0);
	AXI_data_in		:IN	std_logic_vector (31 downto 0);
	AXI_cmd_in       : IN std_logic_vector (1 downto 0);
	AXI_data_out  :OUT std_logic_vector (31 downto 0);
	AXI_flag_out  :OUT std_logic;
	
	APB_address_out		:OUT 	std_logic_vector (7 downto 0);
	APB_data_out		:OUT	std_logic_vector (31 downto 0);
	
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
	TYPE state_type_APB IS (free, send_APB); 
	
	signal state_AXI 			  		: state_type_AXI;
	signal state_RAM 			  		: state_type_RAM;
	signal state_APB 			  		: state_type_APB;
	
	signal buff_state_AXI 			  		: std_logic_vector (2 downto 0);
	signal buff_state_RAM 			  		: std_logic_vector (2 downto 0);
	signal buff_state_APB 			  		: std_logic_vector (2 downto 0);
	
	signal counter                : integer range 0 to N; -- порядковый номер последовательно поступающих данных
	
   signal buff_data 					: std_logic_vector (31 downto 0);
	signal buff_address				: std_logic_vector (31 downto 0);
--	signal buff_cmd               : std_logic_vector (1 downto 0);
	
--	signal buff_data_next 	: std_logic_vector (31 downto 0); 
--	signal buff_address_next : std_logic_vector (31 downto 0); 	
--	signal r_memo_com 		   : std_logic_vector (31 downto 0); 
--	signal buff_data_out     : std_logic_vector (31 downto 0);
--	signal count	 		: std_logic_vector (0 to 11); 
--	signal buff_address 	: std_logic_vector (0 to 15); 
	
	begin
	
	state_AXI_proc:
	process (clk)
	begin 
		IF (rst = '1') then 
			state_AXI <= free;
		ELSIF (rising_edge(clk)) then
			IF (ready = '1') then 
			state_AXI <= state_AXI;
			else
				CASE state_AXI is 
					when free =>
						if (AXI_cmd_in = "11") then
							state_AXI <= regfill_CPU;
						elsif (AXI_cmd_in = "10") then
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
						if (counter rem 3 = 0 and buff_data(31) = '0') then
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
	process (clk)
	begin 
		IF rst = '1' then 
			state_RAM <= free;
		ELSIF (rising_edge(clk)) then
			IF (ready = '1') then 
			state_RAM <= state_RAM;
			else
				CASE state_RAM is 
					when free =>
						if (buff_state_AXI = "111") then
							state_RAM <= send_RAM;
						elsif (buff_state_AXI = "100") then
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
		end if;
	end process;

state_APB_proc:
	process (clk)
	begin 
		IF rst = '1' then 
			state_APB <= free;
		ELSIF (rising_edge(clk)) then
			IF (ready = '1') then 
			state_APB <= state_APB;
			else
				CASE state_APB is 
					when free =>
						if (state_AXI = send_RAM and counter rem 3 = 0 and buff_data(31) = '0') then    
							state_APB <= send_APB;
						else
							state_APB <= free;
						end if;
				
					when send_APB =>
						state_APB <= free;				
						
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
			counter <= counter + 1;
				
		elsif( state_AXI = send_RAM or state_AXI = send_CPU or state_AXI = send_RAM or state_AXI = regfill_RAM) then
			counter <= counter;
			 
		elsif (state_AXI =  free ) then
			counter <= 0;
		end if;
	end if;
	
	
	----------------------------------buff_address-----------------------------------------
	IF (ready = '1') then 
		buff_address<= buff_address;
	else
		IF (state_AXI = regfill_CPU or state_AXI = regfill_RAM) then 
			buff_address <= AXI_address_in;
				
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
		
		elsif (state_AXI = regfill_CPU) then
			buff_data <= AXI_data_in;
			
		elsif (state_AXI = send_RAM or state_AXI = regfill_RAM) then 
			buff_data <= buff_data;
			
		elsif (state_AXI = free) then
			buff_data <= x"00000000";
		end if;
	end if;
	
	-------------------------------------buff_cmd---------------------------------------
--	IF (ready = '1') then 
--		buff_cmd<= buff_cmd;
--	else
--		IF (state_AXI = regfill_CPU or state_AXI = regfill_RAM) then 
--			buff_cmd <= AXI_address_in(1 downto 0);
				
--		elsif( state_AXI = send_RAM or state_AXI = send_CPU) then
--			buff_cmd <= buff_cmd;
			 
--		elsif (state_AXI =  free ) then
--			buff_cmd <= '00';
--		end if;
--	end if;
	
	
	-----------------------------------------------------------------------------------------------------------
	
	
	-------------------------------------out_sig-----------------------------------------

	
	
	------------------------------------APB_data_out------------------------------------------
	IF (ready = '1') then
		APB_data_out <= x"00000000";
	else
		IF (state_APB = send_APB) then 
			APB_data_out <= buff_address;
		elsif(state_APB = free) then 
			APB_data_out <= x"00000000";
		end if; 
	end if;
	
	
	------------------------------------APB_address_out--------------------------------------------
	IF (ready = '1') then
		APB_address_out <= x"00";
	else
		IF (state_APB = free) then 
			APB_address_out <= x"00";
		elsif (state_APB = send_APB) then
			APB_address_out <= x"11";
		end if;
	end if;
	

	
	---------------------------------------RAM_address_out------------------------------------------------
	IF (ready = '1') then
		RAM_address_out <= x"00000000";
	else
		IF (state_RAM = free) then 
			RAM_address_out <= x"00000000";
		elsif (state_RAM = send_RAM) then
			RAM_address_out <= buff_address + std_logic_vector(to_unsigned(counter - 1, 32));
		elsif(state_RAM = regfill_RAM) then
			RAM_address_out <= buff_address;
		end if;
	end if;
	
	---------------------------------------RAM_data_out------------------------------------------------
	IF (ready = '1') then
		RAM_data_out <= x"00000000";
	else
		IF (state_RAM = free or state_RAM = regfill_RAM) then 
			RAM_data_out <= x"00000000";
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
	--------------------------------------AXI_data_out-------------------------------------------------------
	IF (ready = '1') then
		AXI_data_out <= x"00000000";
	else
		IF (state_AXI = free or state_AXI = regfill_RAM or state_AXI = regfill_CPU or state_AXI = send_RAM) then 
			AXI_data_out <= x"00000000";
		elsif (state_AXI = send_CPU) then
			AXI_data_out <= RAM_data_in;--buff_data;
		end if;
	end if;
	--------------------------------------AXI_flag_out-------------------------------------------------------
	IF (ready = '1') then
		AXI_flag_out <= '0';
	else
		IF (state_AXI = free or state_AXI = regfill_RAM or state_AXI = send_CPU or state_AXI = send_RAM) then 
			AXI_flag_out <= '0';
		elsif (state_AXI = regfill_CPU) then
			AXI_flag_out <= '1';
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
			APB_state_out <= "001";
			buff_state_APB <= "001";
		end case;
end process;
end FSM;
