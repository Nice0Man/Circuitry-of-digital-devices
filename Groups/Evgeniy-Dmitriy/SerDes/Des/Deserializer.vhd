library ieee;
use ieee.std_logic_1164.all;
entity Deserializer is

port (
	i_clk                          : in  std_logic;
	i_rstb                         : in  std_logic;
	i_sync_reset                   : in  std_logic;
	i_data_ena                     : in  std_logic;
	i_data                         : in  std_logic;
	o_data_valid                   : out std_logic;
	o_data                         : out std_logic_vector(7 downto 0));
end Deserializer;

architecture Behavioral of Deserializer is
	signal r_data_enable                  : std_logic;
	signal r_data                         : std_logic_vector(7 downto 0);
	signal r_count                        : integer range 0 to 7;
begin

Deserializer : process(i_clk,i_rstb)
begin
	if(i_rstb='0') then
		r_data_enable        <= '0';
		r_count              <= 0;
		r_data               <= (others=>'0');
		o_data_valid         <= '0';
		o_data               <= (others=>'0');
	elsif(rising_edge(i_clk)) then
		o_data_valid         <= r_data_enable;
		if(r_data_enable='1') then
			o_data         <= r_data;
		end if;
		if(i_sync_reset='1') then
			r_count        <= 0;
			r_data_enable  <= '0';
		elsif(i_data_ena='1') then
			r_data         <= r_data(6 downto 0)&i_data;
			if(r_count>=7) then
				r_count        <= 0;
				r_data_enable  <= '1';
			else
				r_count        <= r_count + 1;
				r_data_enable  <= '0';
			end if;
		else
			r_data_enable  <= '0';
		end if;
	end if;
end process Deserializer;
end Behavioral;