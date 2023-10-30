library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.SerDes;
use work.SerDes_tester;

entity SerDes_tb is
end SerDes_tb;

architecture struct of SerDes_tb is 
                                              
	-- signals                                                   
	SIGNAL clk_in_deser : STD_LOGIC := '0';
	SIGNAL clk_in_ser : STD_LOGIC := '0';
	SIGNAL clk_out_ser  : std_logic := '0';

	SIGNAL data_in_deser : STD_LOGIC := '0';
	SIGNAL data_in_ser : STD_LOGIC_VECTOR(9 DOWNTO 0) := "1100111001";
	SIGNAL data_out_deser : STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');
	SIGNAL data_out_ser : STD_LOGIC := '0';

	SIGNAL link_trained : STD_LOGIC := '0';
	SIGNAL valid_data : STD_LOGIC := '0';

	SIGNAL reset_deser : STD_LOGIC := '0';
	SIGNAL reset_ser : STD_LOGIC := '0';

	COMPONENT SerDes
		PORT (
		clk_in_deser : IN STD_LOGIC := '0';
		clk_in_ser : IN STD_LOGIC := '0';
		clk_out_ser : OUT STD_LOGIC := '0';
		data_in_deser : IN STD_LOGIC := '0';
		data_in_ser : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');
		data_out_deser : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');
		data_out_ser : OUT STD_LOGIC := '0';
		link_trained : OUT STD_LOGIC := '0';
		valid_data : IN STD_LOGIC := '0';	
		reset_deser : IN STD_LOGIC := '0';
		reset_ser : IN STD_LOGIC := '0'
		);
	END COMPONENT;
	
	COMPONENT SerDes_tester
		PORT (
		clk_in_deser : OUT STD_LOGIC := '0';
		clk_in_ser : OUT STD_LOGIC := '0';
		clk_out_ser : IN STD_LOGIC := '0';
		data_in_deser : OUT STD_LOGIC := '0';
		data_in_ser : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');
		data_out_deser : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');
		data_out_ser : IN STD_LOGIC := '0';
		link_trained : IN STD_LOGIC := '0';
		valid_data : OUT STD_LOGIC := '0';	
		reset_deser : OUT STD_LOGIC := '0';
		reset_ser : OUT STD_LOGIC := '0'
		);
	END COMPONENT;
	
	--FOR ALL : SerDes USE ENTITY my_project1.SerDes;
   	--FOR ALL : SerDes_tester USE ENTITY my_project1.SerDes_tester;
	
BEGIN
	
	U_0 : entity work.SerDes
		PORT MAP (
			clk_in_deser => clk_in_deser,
			clk_in_ser => clk_in_ser,
			clk_out_ser => clk_out_ser,
			data_in_deser => data_in_deser,
			data_in_ser => data_in_ser,
			data_out_deser => data_out_deser,
			data_out_ser => data_out_ser,
			link_trained => link_trained,
			valid_data => valid_data,
			reset_deser => reset_deser,
			reset_ser => reset_ser
		);
		
	U_1 : entity work.SerDes_tester
		PORT MAP (
			clk_in_deser => clk_in_deser,
			clk_in_ser => clk_in_ser,
			clk_out_ser => clk_out_ser,
			data_in_deser => data_in_deser,
			data_in_ser => data_in_ser,
			data_out_deser => data_out_deser,
			data_out_ser => data_out_ser,
			link_trained => link_trained,
			valid_data => valid_data,
			reset_deser => reset_deser,
			reset_ser => reset_ser
		);	

END struct;

	