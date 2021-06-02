library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux is
port(
	d_in  :	in std_logic_vector(7 downto 0);
	d_out1: out std_logic_vector(7 downto 0);
	d_out2: out std_logic_vector(7 downto 0);
	d_out3: out std_logic_vector(7 downto 0);
	d_out4: out std_logic_vector(7 downto 0);
	Sel   : in std_logic_vector(1 downto 0);
	En    :	in std_logic
);
end demux;

architecture MuxArchi of demux is
begin
process (En, Sel, d_in)
begin
IF (En='1') THEN
	IF(Sel ="00")THEN
		d_out1<=d_in;
		d_out2<="XXXXXXXX";
		d_out3<="XXXXXXXX";
		d_out4<="XXXXXXXX";
	ELSIF (Sel ="01")THEN
		d_out2<=d_in;
		d_out1<="XXXXXXXX";
		d_out3<="XXXXXXXX";
		d_out4<="XXXXXXXX";
		
	ELSIF (Sel ="10")THEN
		d_out3<=d_in;
		d_out1<="XXXXXXXX";
		d_out2<="XXXXXXXX";
		d_out4<="XXXXXXXX";
	ELSE
		d_out4<=d_in;
		d_out1<="XXXXXXXX";
		d_out2<="XXXXXXXX";
		d_out3<="XXXXXXXX";
	end if ;
ELSE
	d_out1<="XXXXXXXX";
	d_out2<="XXXXXXXX";
	d_out3<="XXXXXXXX";
	d_out4<="XXXXXXXX";
END IF;	
end process;
end MuxArchi;
