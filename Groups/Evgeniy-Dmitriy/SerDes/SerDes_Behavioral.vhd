library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SerDes is
    Port (
		  clk_in_ser       : in  std_logic := '0';
        reset_ser        : in  std_logic := '0';
        valid_data       : in  std_logic := '0'; -- '1'-передаются валидные данные, '0'-тестовый паттерн 
        data_in_ser      : in  std_logic_vector(9 downto 0) := (others => '0');
        data_out_ser     : out std_logic := '0';
		  clk_out_ser      : out std_logic := '0';
		  
		  
	     clk_in_deser     : in  std_logic := '0';
        reset_deser      : in  std_logic := '0';
		  link_trained     : out std_logic := '0'; -- '1' когда выравнивание установлено
        data_in_deser    : in  std_logic := '0';
        data_out_deser   : out std_logic_vector(9 downto 0) := (others => '0')
    );
end SerDes;

architecture Behavioral of SerDes is

	 signal data_selection_ser          : std_logic_vector(3 downto 0);
    signal counter_ser      : std_logic_vector(2 downto 0) := (others => '0');
    signal din_ser          : std_logic_vector(9 downto 0) := (others => '0');
	 signal clk_out_ser_signal  : std_logic := '0';


    signal dout_deser            : std_logic_vector(9 downto 0) := (others => '0');
    signal dout_buffer_deser     : std_logic_vector(9 downto 0) := (others => '0');
    signal counter_deser         	 : std_logic_vector(2 downto 0) := (others => '0');
    signal data_selection_deser  	 : std_logic_vector(2 downto 0) := (others => '0');
    signal counter_word_deser    	 : std_logic_vector(1 downto 0) := (others => '0');
	 
    signal linked          	 : std_logic := '0';
	 signal alignment_was_set	 : std_logic := '0';
    
    signal ddr             	 : std_logic_vector(1 downto 0);
    signal ddr0            	 : std_logic;
    signal din_deser           : std_logic_vector(1 downto 0);
    signal test_pattern    	 : std_logic_vector(9 downto 0) := "1100111001";

begin
	 ----------------------------Сериализатор------------------------------------

    ----------------------------------------------------------------------------
    -- Генерация выходного тактового сигнала сериализатора
    ----------------------------------------------------------------------------
    clk_out_deser_proc : process (clk_in_ser)
    begin
        if rising_edge(clk_in_ser) then
            if reset_ser = '1' then
                clk_out_ser_signal <= '0';
					 
            else
                if counter_ser = "100" then
                    clk_out_ser_signal <= '1';

                elsif counter_ser = "010" then
                    clk_out_ser_signal <= '0';

                end if;
            end if;
				clk_out_ser <= clk_out_ser_signal;
        end if;
    end process;
	 
	 
    ----------------------------------------------------------------------------
    -- Счетчик сериализатора
    ----------------------------------------------------------------------------
    counter_ser_proc : process (clk_in_ser)
    begin
        if rising_edge(clk_in_ser) then
            if reset_ser = '1' then
                counter_ser <= (others => '0');

            else
					 if counter_ser = "100" then
                    counter_ser <= (others => '0');

                else
                    counter_ser <= counter_ser + 1;
						  
					 end if;
            end if;
        end if;
    end process;

    data_selection_ser <= counter_ser & (not clk_in_ser);

	 ----------------------------------------------------------------------------
    -- Прием данных сериализатором/отправка тестового паттерна
    ----------------------------------------------------------------------------
    process (clk_out_ser_signal)
    begin
        if rising_edge(clk_out_ser_signal) then
            if reset_ser = '1' then
                din_ser <= (others => '0');

            else
                if valid_data = '0' then
                    din_ser <= test_pattern;
					 else
						  din_ser <= data_in_ser;
                end if;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Сериализация данных
    ----------------------------------------------------------------------------
    serializing_proc : process (data_selection_ser, din_ser)
    begin
        case data_selection_ser is
            when"0000"  => data_out_ser <= din_ser(9);
            when"0001"  => data_out_ser <= din_ser(8);
            when"0010"  => data_out_ser <= din_ser(7);
            when"0011"  => data_out_ser <= din_ser(6);
            when"0100"  => data_out_ser <= din_ser(5);
            when"0101"  => data_out_ser <= din_ser(4);
            when"0110"  => data_out_ser <= din_ser(3);
            when"0111"  => data_out_ser <= din_ser(2);
				when"1000"  => data_out_ser <= din_ser(1);
				when"1001"  => data_out_ser <= din_ser(0);
            when others => data_out_ser <= '0';

        end case;
    end process; 
	 
	 
	 ---------------------------Десериализатор-----------------------------------

    link_trained <= linked;

    ----------------------------------------------------------------------------
    -- Прием данных десериализатором  
    ----------------------------------------------------------------------------
    ddr0 <= data_in_deser when falling_edge(clk_in_deser);
    ddr(1) <= ddr0 when rising_edge(clk_in_deser);
    ddr(0) <= data_in_deser when rising_edge(clk_in_deser); 
    din_deser  <= ddr;
     
    ----------------------------------------------------------------------------
    -- Выравнивание данных
    ---------------------------------------------------------------------------- 
    align_proc : process (clk_in_deser)
    begin
        if rising_edge(clk_in_deser) then
            if reset_deser = '1' then
                counter_deser <= "000";
                linked  <= '0';

            else
                if counter_deser = "100" then
                    counter_deser <= "000";

                else
                    if linked = '1' then
                        counter_deser <= counter_deser + 1;
								
								if dout_buffer_deser(9) = '0' then 
								    alignment_was_set  <= '1';
				
								elsif dout_buffer_deser(9) = '1' and alignment_was_set = '1' then
								    linked <= '0';
								    alignment_was_set <= '0';
								end if;

                    else
                        if counter_word_deser = "01" and counter_deser = "001" then
                            if dout_buffer_deser = test_pattern then
                                linked <= '1';
                            else
                                linked <= linked;
                            end if;
									 
                            counter_deser <= counter_deser + 1;

                        elsif counter_word_deser = "11" and counter_deser = "001" then
                            counter_deser <= counter_deser + 2;

                        else
                            counter_deser <= counter_deser + 1;

                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Счетчик записанных комбинаций
    ----------------------------------------------------------------------------
    word_counter_proc : process (clk_in_deser)
    begin
        if rising_edge(clk_in_deser) then
            if counter_deser = "100" then
                counter_word_deser <= counter_word_deser + 1;

            end if;
        end if;
    end process;
	 
    data_selection_deser <= counter_deser;
	 
    ----------------------------------------------------------------------------
    -- Десериализация
    ----------------------------------------------------------------------------
    deserializing_proc : process (clk_in_deser)
    begin
        if rising_edge(clk_in_deser) then
            if reset_deser = '1' then
                dout_deser <= (others => '0');

            else
                if data_selection_deser = "000" then
                    dout_deser(9 downto 8) <= din_deser;
                    dout_buffer_deser <= dout_deser;
						  
                elsif data_selection_deser = "001" then
                    dout_deser(7 downto 6) <= din_deser;	

                elsif data_selection_deser = "010" then
                    dout_deser(5 downto 4) <= din_deser;

                elsif data_selection_deser = "011" then
                    dout_deser(3 downto 2) <= din_deser;
						  
					 elsif data_selection_deser = "100" then
                    dout_deser(1 downto 0) <= din_deser;
						  
                end if;
            end if;
        end if;
    end process;
     
    data_out_deser <= dout_buffer_deser;
	 
end Behavioral;

						  	
