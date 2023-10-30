LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

entity SerDes_tester is
    Port (
		  clk_in_ser       : out  std_logic := '0';
        reset_ser        : out  std_logic := '0';
        valid_data       : out  std_logic := '0'; -- '1'-передаются валидные данные, '0'-тестовый паттерн 
        data_in_ser      : out  std_logic_vector(9 downto 0) := "1100111001";
        data_out_ser     : in std_logic := '0';
		  clk_out_ser      : in std_logic := '0';
		  
		  
	     clk_in_deser     : out  std_logic := '0';
        reset_deser      : out  std_logic := '0';
		  link_trained     : in std_logic := '0'; -- '1' когда выравнивание установлено
        data_in_deser    : out  std_logic := '0';
        data_out_deser   : in std_logic_vector(9 downto 0) := (others => '0')
    );
end SerDes_tester;

ARCHITECTURE flow OF SerDes_tester IS
	 -- constants
	 constant clk_in_ser_period : time := 3.3333 ns;
    constant test_pattern : std_logic_vector(9 downto 0) := "1100111001"; 
	 
BEGIN	
	
    clk_gen_proc : process
    begin
        clk_in_ser    <= '1';
		  data_in_deser <= data_out_ser;
        wait for clk_in_ser_period*2/8;
		  
        clk_in_deser <= '0';
		  data_in_deser <= data_out_ser;
        wait for clk_in_ser_period*2/8;

        clk_in_ser    <= '0';
		  data_in_deser <= data_out_ser;
        wait for clk_in_ser_period*2/8;
		  
        clk_in_deser <= '1';
		  data_in_deser <= data_out_ser;
        wait for clk_in_ser_period*2/8;

    end process;
	
	
	data_gen_proc : process
   begin
        reset_deser <= '1';
        reset_ser   <= '1';
        wait for 35 ns;

        reset_ser <= '0';
        wait for 25 ns;
        reset_deser <= '0';

        wait until link_trained = '1';
		  --wait for 100 ns;
		  valid_data <= '1';
		  
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0001100000";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0101011010";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0111111110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0100111110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0100011100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0011111010";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0111110100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0111111110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0111111100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0001111110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0001100000";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0001101010";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0001101110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0001100100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000001010";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000010100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000000000";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000001010";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000001110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000000110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000001010";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000010100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011100";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000011110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000000000";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000001010";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000001110";
        wait until rising_edge(clk_out_ser);
        data_in_ser <= "0000000110";
        wait until rising_edge(clk_out_ser);
		  
		  valid_data <= '0';
		  data_in_ser <= test_pattern;
		  
		  
        wait;

    end process;

END flow;

