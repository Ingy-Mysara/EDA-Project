library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_dual is
	port 
	(
		D_in	: in std_logic_vector(7 downto 0);
		D_out	: out std_logic_vector(7 downto 0);	
		WEA	: in std_logic; --is originally set to 1?
		REA	: in std_logic;
		ADDRA	: in std_logic_vector(2 downto 0);	--write
		ADDRB	: in std_logic_vector(2 downto 0);	--read
		CLKA	: in std_logic;			--write clk	
		CLKB	: in std_logic			--read clk
		
		
	);
	
end ram_dual;

architecture rtl of ram_dual is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(7 downto 0);
	type memory_t is array(7 downto 0) of word_t;
	
	-- Declare the RAM signal.
	signal ram : memory_t;

begin

	process(CLKA)
	begin
		if(rising_edge(CLKA)) then 
			if(WEA = '1') then
				ram(to_integer(unsigned(ADDRA))) <= D_in;
			end if;
		end if;
	end process;
	
	process(CLKB)
	begin
		if(rising_edge(CLKB)) then
			if(REA = '1') then
				D_out <= ram(to_integer(unsigned(ADDRB)));
			end if;
		end if;
	end process;

end rtl;
