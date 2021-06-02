library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
  
ENTITY gray_counter IS 
     port (
	Count_out:out std_logic_vector (2 downto 0); -- Output of the counter
        En       :in  std_logic;                     -- Enable counting
	clock    :in  std_logic;                     -- Input clock
	Reset    :in  std_logic                      -- Input reset
     );
END ENTITY gray_counter;
 
architecture gray_counterArchi of gray_counter is
signal tmp: std_logic_vector(2 downto 0);
begin
process (clock, Reset) 
begin       
	if (Reset = '1') then
		tmp <= "000";
	elsif (rising_edge(clock)) then
		if (En = '1') then
			tmp <= tmp + 1;
		end if;
	end if;
	end process;
Count_out <=	(tmp(2) &  
              	(tmp(2) xor  tmp(1)) & 
             	(tmp(1) xor  tmp(0))); 
END ARCHITECTURE gray_counterArchi;
