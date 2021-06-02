library ieee;
 use ieee.std_logic_1164.all;

 entity Round_robin is

 port (
	din1 , din2 , din3 , din4 : in std_logic_vector(7 downto 0); -- system inputs
	dout: out std_logic_vector(7 downto 0); -- system outputs
	clk : in std_logic	 -- clock 
);
end Round_robin ;

 -- purpose: Main architecture details for rr
architecture rr1 of Round_robin is

type state_type is (i1,i2,i3,i4);
SIGNAL current_state: state_type;
SIGNAL next_state:state_type ;

begin
cs: PROCESS (clk) IS

begin

IF rising_edge (clk) THEN
current_state <= next_state;
END IF;
END PROCESS cs;

ns: PROCESS (current_state, din1,din2,din3,din4)
BEGIN
CASE current_state IS
	WHEN i1 => dout <= din1;
	next_state<= i2;

	WHEN i2 => dout <= din2;
	next_state<= i3;

	WHEN i3 => dout <= din3;
	next_state<= i4;

	WHEN i4 => dout <= din4; 
	next_state<= i1;

end case;
END Process ns ;
END architecture rr1;
