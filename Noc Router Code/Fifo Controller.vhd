LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_UNSIGNED.ALL;
library work;
 
ENTITY fifocontroller2 IS
 
PORT( 	reset, rdclk,wrclk,r_req,w_req: IN std_logic;
	write_valid,read_valid,empty,full: OUT std_logic;
 	wr_ptr,rd_ptr : out std_logic_vector(2 downto 0)  );
 
END ENTITY fifocontroller2;
ARCHITECTURE fifo OF fifocontroller2 IS
component gray_counter IS 
     port (
	Count_out:out std_logic_vector (2 downto 0); -- Output of the counter
        En       :in  std_logic;                     -- Enable counting
	clock    :in  std_logic;                     -- Input clock
	Reset    :in  std_logic                      -- Input reset
     );
end component;
 
component Gray_to_Binary IS
     port(
         gray_in : in STD_LOGIC_VECTOR(2 downto 0);
         bin_out : out STD_LOGIC_VECTOR(2 downto 0)
         );
end component;
 
SIGNAL write_converter_out ,read_converter_out , write_counter_out ,read_counter_out :std_logic_vector (2 downto 0);
SIGNAL read_en , write_en, read_ok, write_ok :STD_LOGIC :='0';
SIGNAL full_signal: STD_LOGIC;
SIGNAL empty_signal: STD_LOGIC;
SIGNAL next_write, next_read: STD_LOGIC_VECTOR (2 downto 0);
SIGNAL read_add , write_add: STD_LOGIC_VECTOR (2 downto 0) := "000";
 
BEGIN
 
wr_counter: gray_counter port map 
      ( clock => wrclk,Reset => reset ,En => write_ok,Count_out => write_counter_out);
wr_converter: Gray_to_Binary port map 
      ( gray_in => write_counter_out,bin_out => write_converter_out );
 
rd_counter: gray_counter port map 
      ( clock => wrclk,Reset => reset ,En => read_ok,Count_out => read_counter_out);
rd_converter: Gray_to_Binary port map 
      ( gray_in => read_counter_out,bin_out => read_converter_out );
 
 
P3 : PROCESS (wrclk, rdclk, write_add, read_add, w_req, r_req, write_en, read_en, reset,write_converter_out, read_converter_out, empty_signal , full_signal, next_write)
 
BEGIN
write_add <= write_converter_out ;
read_add <= read_converter_out ;

next_write <= std_logic_vector( to_unsigned(to_integer(unsigned(write_add))+1 ,3));
--next_read <= std_logic_vector( to_unsigned(to_integer(unsigned(read_add))+1 ,3));



IF next_write = read_add THEN
empty_signal <= '0';
full_signal <= '1';
ELSIF read_add = write_add THEN 
empty_signal <= '1';
full_signal <= '0';
ELSE
empty_signal <= '0';
full_signal <= '0';
END IF;


IF reset ='1' THEN
write_en <='0';
read_en <= '0';
empty_signal <= '1';
full_signal <= '0';
ELSIF empty_signal = '1' THEN 
write_en <= '1';
read_en <= '0';
ELSIF full_signal = '1' THEN
write_en <='0';
read_en <= '1';
elsif empty_signal = '0' AND full_signal = '0' THEN
write_en <='1';
read_en <= '1';
ELSE
write_en <='1';
read_en <= '1';
END IF;

IF reset ='1' THEN
write_valid<='0';
ELSIF (wrclk'event and wrclk='1') THEN 
IF w_req ='1' and write_en = '1' THEN
wr_ptr <= write_add; -- momken ne2lebhom later on law fih moshkela
write_valid <= '1'; --increament el address momken yekon fih moshkela
write_ok <= '1';
ELSE
write_valid <= '0';
write_ok <= '0';
END IF ;
end if;

--IF w_req ='1' and write_en = '1' THEN
--empty_signal <= '0';
--END IF;
IF reset ='1' THEN
read_valid<='0';
ELSIF (rdclk'event and rdclk='1') THEN 
IF r_req ='1' and read_en = '1' THEN
rd_ptr <= read_add; -- momken ne2lebhom later on law fih moshkela
read_valid <= '1'; --increament el address momken yekon fih moshkela
read_ok <= '1';
ELSE
read_valid <= '0';
read_ok <= '0';
END IF ;
END IF;
--conv_out <=read_converter_out;
empty <= empty_signal;
full <= full_signal;
 
END PROCESS P3 ;


END ARCHITECTURE fifo ;

