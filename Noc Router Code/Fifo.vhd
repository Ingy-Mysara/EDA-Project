LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
library work;
use work.all;
 
ENTITY fifo IS
PORT(	reset, rclk,wclk,rreq,wreq: IN std_logic;
    	datain:in std_logic_vector(7 downto 0);
    	dataout:out std_logic_vector(7 downto 0);
    	empty,full: OUT std_logic
);
END ENTITY fifo;
 
ARCHITECTURE behavioral OF fifo IS
component fifocontroller2 IS
 
PORT( 	reset, rdclk,wrclk,r_req,w_req: IN std_logic;
	write_valid,read_valid,empty,full: OUT std_logic;
 	wr_ptr,rd_ptr : out std_logic_vector(2 downto 0)  );
end component;
 
component ram_dual is
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
end component;
 
signal WEA,REA:  std_logic;
signal ADDRA,ADDRB:  std_logic_vector(2 downto 0);
 
BEGIN
 
controller: fifocontroller2 port map 
(reset => reset, rdclk => rclk, wrclk=>wclk, r_req=>rreq, w_req=>wreq, write_valid=>WEA, read_valid=>REA, empty=>empty, full=>full, wr_ptr=>ADDRA, rd_ptr=>ADDRB);
 
ram: ram_dual port map 
(D_in=> datain,D_out=>dataout,WEA=>WEA, REA=>REA, ADDRA=>ADDRA, ADDRB=>ADDRB, CLKA=>wclk,CLKB=>rclk);
 
END ARCHITECTURE behavioral;
