Library ieee;
use ieee.std_logic_1164.all;

ENTITY register8 IS PORT(
	Datat_in : in std_logic_vector(7 downto 0);
	Data_out : out std_logic_vector(7 downto 0);
   	Clock    : in std_logic;
    	Clock_En : in std_logic ;
    	Reset    : in std_logic
);
END register8;

ARCHITECTURE register8Archi OF register8 IS
BEGIN
    process(Clock, Reset)
    begin
        if Reset = '1' then
            Data_out <= "00000000";
        elsif rising_edge(Clock) then
            if Clock_En = '1' then
                Data_out <= Datat_in;
            end if;
        end if;
    end process;
END register8Archi;
