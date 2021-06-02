Library ieee;
USE ieee.std_logic_1164.ALL;
ENTITY router is
	port(	wclock, rclock, rst: IN std_logic;
		datai1,datai2, datai3, datai4: IN std_logic_vector ( 7 DOWNTO 0);
		wr1, wr2, wr3, wr4: IN std_logic;
		datao1,datao2, datao3, datao4: OUT std_logic_vector ( 7 DOWNTO 0));

end router;


ARCHITECTURE ROUTERarch of router is
COMPONENT register8 IS
        PORT(
	Datat_in : in std_logic_vector(7 downto 0);
	Data_out : out std_logic_vector(7 downto 0);
   	Clock    : in std_logic;
    	Clock_En : in std_logic ;
    	Reset    : in std_logic
);
END COMPONENT ;

COMPONENT DeMux IS
port(
	d_in  :	in std_logic_vector(7 downto 0);
	d_out1: out std_logic_vector(7 downto 0);
	d_out2: out std_logic_vector(7 downto 0);
	d_out3: out std_logic_vector(7 downto 0);
	d_out4: out std_logic_vector(7 downto 0);
	Sel   : in std_logic_vector(1 downto 0);
	En    :	in std_logic
);
END COMPONENT ;

COMPONENT fifo IS
PORT(	reset, rclk,wclk,rreq,wreq: IN std_logic;
    	datain:in std_logic_vector(7 downto 0);
    	dataout:out std_logic_vector(7 downto 0);
    	empty,full: OUT std_logic
);
END COMPONENT ;

COMPONENT Round_robin IS port (
	din1 , din2 , din3 , din4 : in std_logic_vector(7 downto 0); -- system inputs
	dout: out std_logic_vector(7 downto 0); -- system outputs
	clk : in std_logic	 -- clock 
);
END COMPONENT ;

COMPONENT decider IS
port (	     clock: in std_logic;
	     Eflag1,Eflag2,Eflag3,Eflag4: in std_logic;
	     outFlag: out std_logic);

END COMPONENT ;


subtype flag1bit is std_logic;
subtype data8bit is std_logic_vector(7 downto 0);

type array4x8 is array(1 to 4) of data8bit;

type array4x1 is array(1 to 4) of flag1bit;

signal deciderFlag: array4x1;
signal DeMuxToFIFO1,DeMuxToFIFO2,DeMuxToFIFO3,DeMuxToFIFO4,FIFOtoSch1,FIFOtoSch2,FIFOtoSch3,FIFOtoSch4,output: array4x8;
signal EmptyFifo1,EmptyFifo2,EmptyFifo3,EmptyFifo4,FullFifo1,FullFifo2,FullFifo3,FullFifo4,fifo_wreq1,fifo_wreq2,fifo_wreq3,fifo_wreq4: array4x1;
signal IBtoDeMux:array4x8;



type data_io is array (1 to 4) of std_logic_vector(7 downto 0);
type packettype is array (1 to 4) of std_logic;
type flagType is array (1 to 4) of std_logic;
--signal dataos1,dataos2,dataos3,dataos4: std_logic_Vector(7 downto 0 );

--signal dataos: data_io := (dataos1,dataos2,dataos3,dataos4);

--signal dataos: array4x8 := (dataos1,dataos2,dataos3,dataos4);
 
signal wr: packettype;
signal datai: data_io;
FOR ALL: demux USE ENTITY WORK.Demux (MuxArchi);
FOR ALL: register8 USE ENTITY WORK.Register8 (register8Archi);

FOR ALL: fifo USE ENTITY WORK.fifo (behavioral);

FOR ALL: Round_robin USE ENTITY WORK.Round_Robin (rr1);
FOR ALL: decider USE ENTITY WORK.decider (behaveofdecider);

BEGIN
wr <= (wr1,wr2,wr3,wr4);

datai <= (datai1,datai2,datai3,datai4);



fifo_wreq1(1) <='1' when (wr1= '1' and  IBtoDeMux(1)(1 downto 0) = "00") 
else '0';
fifo_wreq2(1) <='1' when (wr1= '1' and  IBtoDeMux(1)(1 downto 0) = "01")
else '0';
fifo_wreq3(1) <='1' when (wr1= '1' and  IBtoDeMux(1)(1 downto 0) = "10") 
else '0';
fifo_wreq4(1) <='1' when (wr1= '1' and  IBtoDeMux(1)(1 downto 0) = "11") 
else '0';

fifo_wreq1(2) <='1' when (wr2= '1' and  IBtoDeMux(2)(1 downto 0) = "00")
else '0';
fifo_wreq2(2) <='1' when (wr2= '1' and  IBtoDeMux(2)(1 downto 0) = "01")
else '0';
fifo_wreq3(2) <='1' when (wr2= '1' and  IBtoDeMux(2)(1 downto 0) = "10")
else '0';
fifo_wreq4(2) <='1' when (wr2= '1' and  IBtoDeMux(2)(1 downto 0) = "11")
else '0';

fifo_wreq1(3) <='1' when (wr3= '1' and  IBtoDeMux(3)(1 downto 0) = "00")
else '0';
fifo_wreq2(3) <='1' when (wr3= '1' and  IBtoDeMux(3)(1 downto 0) = "01") 
else '0';
fifo_wreq3(3) <='1' when (wr3= '1' and  IBtoDeMux(3)(1 downto 0) = "10") 
else '0';
fifo_wreq4(3) <='1' when (wr3= '1' and  IBtoDeMux(3)(1 downto 0) = "11")
else '0';

fifo_wreq1(4) <='1' when (wr4= '1' and  IBtoDeMux(4)(1 downto 0) = "00") 
else '0';
fifo_wreq2(4) <='1' when (wr4= '1' and  IBtoDeMux(4)(1 downto 0) = "01")
else '0';
fifo_wreq3(4) <='1' when (wr4= '1' and  IBtoDeMux(4)(1 downto 0) = "10") 
else '0';
fifo_wreq4(4) <='1' when (wr4= '1' and  IBtoDeMux(4)(1 downto 0) = "11")
else '0';

 
ib1 : register8 PORT MAP(Datat_in =>datai(1), Data_Out =>IBtoDeMux(1), Clock =>wclock, Clock_En =>wr(1), Reset =>rst); 
dm1: demux PORT MAP(d_in =>IBtoDeMux(1), d_out1 =>DeMuxToFIFO1(1) , d_out2 =>DeMuxToFIFO2(1) , d_out3=>DeMuxToFIFO3(1), d_out4 =>DeMuxToFIFO4(1), Sel=>IBtoDeMux(1)(1 downto 0), En=> wr(1) );
fifo11 :fifo PORT MAP(rreq=>deciderFlag(1) ,wreq=> fifo_wreq1(1)  ,empty=>EmptyFifo1(1), full=>FullFifo1(1), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO1(1)  , dataout=>FIFOtoSch1(1));	
fifo21 :fifo PORT MAP(rreq=>deciderFlag(1) ,wreq=> fifo_wreq2(1)  ,empty=>EmptyFifo2(1), full=>FullFifo2(1), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO2(1)  , dataout=>FIFOtoSch2(1));	
fifo31 :fifo PORT MAP(rreq=>deciderFlag(1) ,wreq=> fifo_wreq3(1)  ,empty=>EmptyFifo3(1), full=>FullFifo3(1), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO3(1)  , dataout=>FIFOtoSch3(1));	
fifo41 :fifo PORT MAP(rreq=>deciderFlag(1) ,wreq=> fifo_wreq4(1)  ,empty=>EmptyFifo4(1), full=>FullFifo4(1), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO4(1)  , dataout=>FIFOtoSch4(1));	
sch1 :Round_robin PORT MAP(clk =>rclock, din1=> FIFOtoSch1(1), din2=> FIFOtoSch1(2), din3=>FIFOtoSch1(3), din4=>FIFOtoSch1(4), dout=>output(1) );
dec1 :decider PORT MAP(clock=>rclock, Eflag1=>EmptyFifo1(1),Eflag2=>EmptyFifo2(1),Eflag3=>EmptyFifo3(1),Eflag4=>EmptyFifo4(1), outFlag =>deciderFlag(1) );

ib2 : register8 PORT MAP(Datat_in =>datai(2), Data_Out =>IBtoDeMux(2), Clock =>wclock, Clock_En =>wr(2), Reset =>rst); 
dm2: demux PORT MAP(d_in =>IBtoDeMux(2), d_out1 =>DeMuxToFIFO1(2) , d_out2 =>DeMuxToFIFO2(2) , d_out3=>DeMuxToFIFO3(2), d_out4 =>DeMuxToFIFO4(2), Sel=>IBtoDeMux(2)(1 downto 0), En=> wr(2) );
fifo12 :fifo PORT MAP(rreq=>deciderFlag(2) ,wreq=> fifo_wreq1(2)  ,empty=>EmptyFifo1(2), full=>FullFifo1(2), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO1(2)  , dataout=>FIFOtoSch1(2));	
fifo22 :fifo PORT MAP(rreq=>deciderFlag(2) ,wreq=> fifo_wreq2(2)  ,empty=>EmptyFifo2(2), full=>FullFifo2(2), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO2(2)  , dataout=>FIFOtoSch2(2));	
fifo32 :fifo PORT MAP(rreq=>deciderFlag(2) ,wreq=> fifo_wreq3(2)  ,empty=>EmptyFifo3(2), full=>FullFifo3(2), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO3(2)  , dataout=>FIFOtoSch3(2));	
fifo42 :fifo PORT MAP(rreq=>deciderFlag(2) ,wreq=> fifo_wreq4(2)  ,empty=>EmptyFifo4(2), full=>FullFifo4(2), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO4(2)  , dataout=>FIFOtoSch4(2));	
sch2 :Round_robin PORT MAP(clk =>rclock, din1=> FIFOtoSch2(1), din2=> FIFOtoSch2(2), din3=>FIFOtoSch2(3), din4=>FIFOtoSch2(4), dout=>output(2) );
dec2 :decider PORT MAP(clock=>rclock, Eflag1=>EmptyFifo1(2),Eflag2=>EmptyFifo2(2),Eflag3=>EmptyFifo3(2),Eflag4=>EmptyFifo4(2), outFlag =>deciderFlag(2) );

ib3 : register8 PORT MAP(Datat_in =>datai(3), Data_Out =>IBtoDeMux(3), Clock =>wclock, Clock_En =>wr(3), Reset =>rst); 
dm3: demux PORT MAP(d_in =>IBtoDeMux(3), d_out1 =>DeMuxToFIFO1(3) , d_out2 =>DeMuxToFIFO2(3) , d_out3=>DeMuxToFIFO3(3), d_out4 =>DeMuxToFIFO4(3), Sel=>IBtoDeMux(3)(1 downto 0), En=> wr(3) );
fifo13 :fifo PORT MAP(rreq=>deciderFlag(3) ,wreq=> fifo_wreq1(3)  ,empty=>EmptyFifo1(3), full=>FullFifo1(3), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO1(3)  , dataout=>FIFOtoSch1(3));	
fifo23 :fifo PORT MAP(rreq=>deciderFlag(3) ,wreq=> fifo_wreq2(3)  ,empty=>EmptyFifo2(3), full=>FullFifo2(3), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO2(3)  , dataout=>FIFOtoSch2(3));	
fifo33 :fifo PORT MAP(rreq=>deciderFlag(3) ,wreq=> fifo_wreq3(3)  ,empty=>EmptyFifo3(3), full=>FullFifo3(3), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO3(3)  , dataout=>FIFOtoSch3(3));	
fifo43 :fifo PORT MAP(rreq=>deciderFlag(3) ,wreq=> fifo_wreq4(3)  ,empty=>EmptyFifo4(3), full=>FullFifo4(3), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO4(3)  , dataout=>FIFOtoSch4(3));	
sch3 :Round_robin PORT MAP(clk =>rclock, din1=> FIFOtoSch3(1), din2=> FIFOtoSch3(2), din3=>FIFOtoSch3(3), din4=>FIFOtoSch3(4), dout=>output(3) );
dec3 :decider PORT MAP(clock=>rclock, Eflag1=>EmptyFifo1(3),Eflag2=>EmptyFifo2(3),Eflag3=>EmptyFifo3(3),Eflag4=>EmptyFifo4(3), outFlag =>deciderFlag(3) );

ib4 : register8 PORT MAP(Datat_in =>datai(4), Data_Out =>IBtoDeMux(4), Clock =>wclock, Clock_En =>wr(4), Reset =>rst); 
dm4: demux PORT MAP(d_in =>IBtoDeMux(4), d_out1 =>DeMuxToFIFO1(4) , d_out2 =>DeMuxToFIFO2(4) , d_out3=>DeMuxToFIFO3(4), d_out4 =>DeMuxToFIFO4(4), SEL=>IBtoDeMux(4)(1 downto 0), En=> wr(4) );
fifo14 :fifo PORT MAP(rreq=>deciderFlag(4) ,wreq=> fifo_wreq1(4)  ,empty=>EmptyFifo1(4), full=>FullFifo1(4), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO1(4)  , dataout=>FIFOtoSch1(4));	
fifo24 :fifo PORT MAP(rreq=>deciderFlag(4) ,wreq=> fifo_wreq2(4)  ,empty=>EmptyFifo2(4), full=>FullFifo2(4), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO2(4)  , dataout=>FIFOtoSch2(4));	
fifo34 :fifo PORT MAP(rreq=>deciderFlag(4) ,wreq=> fifo_wreq3(4)  ,empty=>EmptyFifo3(4), full=>FullFifo3(4), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO3(4)  , dataout=>FIFOtoSch3(4));	
fifo44 :fifo PORT MAP(rreq=>deciderFlag(4) ,wreq=> fifo_wreq4(4)  ,empty=>EmptyFifo4(4), full=>FullFifo4(4), reset => rst, rclk =>rclock, wclk=>wclock,datain=> DeMuxToFIFO4(4)  , dataout=>FIFOtoSch4(4));	
sch4 :Round_robin PORT MAP(clk =>rclock, din1=> FIFOtoSch4(1), din2=> FIFOtoSch4(2), din3=>FIFOtoSch4(3), din4=>FIFOtoSch4(4), dout=>output(4) );
dec4 :decider PORT MAP(clock=>rclock, Eflag1=>EmptyFifo1(4),Eflag2=>EmptyFifo2(4),Eflag3=>EmptyFifo3(4),Eflag4=>EmptyFifo4(4), outFlag =>deciderFlag(4) );

datao1<= output(1);
datao2<=output(2);
datao3<=output(3);
datao4<=output(4);



end ARCHITECTURE ROUTERarch ;




