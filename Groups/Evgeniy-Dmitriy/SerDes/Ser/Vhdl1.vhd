library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Serializer is
    Port (
        i_clk          : in STD_LOGIC;
        i_rstb         : in STD_LOGIC;
		  i_sync_reset   : in STD_LOGIC;
		  
        i_data         : in STD_LOGIC_VECTOR(7 downto 0);
        o_data         : out STD_LOGIC;
        o_data_ena	  : out  STD_LOGIC
		  );
end Serializer;

architecture Behavioral of Serializer is
    signal r_data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 signal r_count : integer := 0;  -- Счетчик сериализованных битов
begin
    -- Процесс для сериализации данных (из 8 бит в 1 бит)
Serializer : process(i_clk,i_rstb)
begin
	if (i_rstb='0') then
		r_data <= (others => '0');  -- Сброс сдвигового регистра
      r_count <= 0;  -- Сброс счетчика
      o_data_ena <= '0';  
		o_data <= '0';
	elsif (rising_edge(i_clk)) then
		if(i_sync_reset='1') then
			r_count        <= 0;
			o_data_ena <= '0';
		elsif (r_count = 0) then
			r_data <= i_data;  -- Записываем параллельные данные
			o_data <= i_data(7);
			o_data_ena <= '1';
			r_count <= r_count + 1;
      elsif (r_count < 8) then
			o_data <= r_data(7-r_count);
			o_data_ena <= '1';
         r_count <= r_count + 1;  -- Увеличиваем счетчик
      else
			o_data_ena <= '0';
      end if;
	end if;
end process;
end Behavioral;
