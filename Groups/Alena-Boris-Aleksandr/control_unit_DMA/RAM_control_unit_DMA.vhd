LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity RAM is 
port (
	rst				: in std_logic;
	ready				: in std_logic;
	clk				: in std_logic;
	RAM_cmd_out			: in std_logic_vector (1 downto 0);
	
	RAM_data_out		 	: in std_logic_vector (31 downto 0);
	RAM_address_out			: in std_logic_vector (31 downto 0);
--	r_DMA_cs			: in std_logic;
--	r_DMA_data_in		 	: in std_logic_vector (0 to 63);
--	r_DMA_command			: in std_logic_vector (0 to 1);
--	r_DMA_address			: in std_logic_vector (0 to 15);
	RAM_data_in			: out std_logic_vector (31 downto 0)
	);
end RAM;

architecture behave of RAM is 
type ram_32k_x32 is array (0 to 2 ** 5 - 1) of std_logic_vector(31 downto 0); 
signal r_memory_Ram : ram_32k_x32 := (
--15 	=> x"000000000000001A",
--16 	=> x"C000000000000014",
--17 	=> x"000000000000001A",
--18 	=> x"A000000C0000000A",
--19 	=> x"0000000000001213",
--20 	=> x"C000000000000000",
--21 	=> x"0AAAAAAAAAAA0001",
--300 	=> x"D000000000003456",
--301	=> x"000000000000001A",
--302	=> x"C0000000000000A0",
--303	=> x"0000000000000001",
--304	=> x"C0000000000000DD",
others 	=> x"00000000"
);

begin

process(clk)
begin 	
	If rst = '1' then
		RAM_data_in <= x"00000000";
	elsif (rising_edge(clk)) then
		IF (RAM_cmd_out = "11") then
			r_memory_Ram(to_integer (unsigned(RAM_address_out))) <= RAM_data_out; 
			RAM_data_in <= x"00000000";
		elsif (RAM_cmd_out = "10" ) then 
			RAM_data_in <= r_memory_Ram(to_integer (unsigned(RAM_address_out))); 
--		elsif (ready ='0') then
--			if (r_DMA_command = "01") then 
--				r_DMA_data_out <= r_memory_Ram(to_integer (unsigned(r_DMA_address))); 
--			elsif (r_DMA_command = "10") then 
--				r_memory_Ram(to_integer (unsigned(r_DMA_address))) <= r_DMA_data_in;
--				r_DMA_data_out <= x"0000000000000000";
--			end if;
		end if;	
	end if;
end process;
end behave;
	