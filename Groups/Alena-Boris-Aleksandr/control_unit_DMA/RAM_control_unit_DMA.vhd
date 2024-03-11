LIBRARY ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity RAM is 
port (
	ARESETn				: in std_logic;
	ready				: in std_logic;
	ACLK				: in std_logic;
	
	RAM_cmd_out_0			: in std_logic_vector (1 downto 0);
	RAM_data_out_0		 	: in std_logic_vector (31 downto 0);
	RAM_address_out_0		: in std_logic_vector (31 downto 0);
	RAM_data_in_0			: out std_logic_vector (31 downto 0);
	
	RAM_cmd_out_1			: in std_logic_vector (1 downto 0);
	RAM_data_out_1		 	: in std_logic_vector (31 downto 0);
	RAM_address_out_1		: in std_logic_vector (31 downto 0);
	RAM_data_in_1			: out std_logic_vector (31 downto 0)
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

process(ACLK)
begin 	
	If ARESETn = '0' then
		RAM_data_in_0 <= x"00000000";
	elsif (rising_edge(ACLK)) then
		IF (RAM_cmd_out_0 = "11") then
			r_memory_Ram(to_integer (unsigned(RAM_address_out_0))) <= RAM_data_out_0; 
			RAM_data_in_0 <= x"00000000";
		elsif (RAM_cmd_out_1 = "11") then
			r_memory_Ram(to_integer (unsigned(RAM_address_out_1))) <= RAM_data_out_1; 
			RAM_data_in_1 <= x"00000000";
		else
			if (RAM_cmd_out_0 = "10" ) then 
				RAM_data_in_0 <= r_memory_Ram(to_integer (unsigned(RAM_address_out_0))); 
			end if;
			if (RAM_cmd_out_1 = "10" ) then 
			RAM_data_in_1 <= r_memory_Ram(to_integer (unsigned(RAM_address_out_1)));
			end if;
		end if;	
	end if;
end process;

end behave;
	