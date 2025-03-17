module DSP_tb ();  
reg [17:0] A , B , D ; 
reg [47:0] C ; 
reg [17:0] BCIN; 
reg CARRYIN,CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP; 
reg RSTA,RSTB,RSTC,RSTD,RSTM,RSTOPMODE,RSTP,RSTCARRYIN; 
reg [47:0] PCIN ; 
reg [7:0] OPMODE ;

wire [47:0] P ; 
wire [35:0] M ; 
wire CARRYOUT,CARRYOUTF; 
wire [47:0] PCOUT; 
wire [17:0] BCOUT ; 

parameter A0REG =0 ;
parameter A1REG =1 ;
parameter B0REG =0 ;
parameter B1REG =1 ; 

parameter CREG=1 ;
parameter DREG=1 ;
parameter MREG=1 ; 
parameter PREG=1 ; 
parameter CARRYINREG=1;  
parameter CARRYOUTREG=1;   
parameter OPMODEREG =1 ; 

parameter CARRYINSEL="OPMODE5";  
parameter B_INPUT="DIRECT"; 
parameter RSTTYPE="SYNC"; 

//DUT instantiation 
DSP_2 #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),.PREG(PREG),.OPMODEREG(OPMODEREG)) DUT 
	(.A(A),.B(B),.C(C),.D(D),.CARRYIN(CARRYIN),.M(M),.P(P),.CARRYOUT(CARRYOUT),.CARRYOUTF(CARRYOUTF),.CLK(CLK),
	.OPMODE(OPMODE),.CEA(CEA),.CEB(CEB),.CEC(CEC),.CECARRYIN(CECARRYIN),.CED(CED),.CEM(CEM),.CEOPMODE(CEOPMODE),
	.CEP(CEP),.RSTA(RSTA),.RSTB(RSTB),.RSTC(RSTC),.RSTCARRYIN(RSTCARRYIN),.RSTD(RSTD),.RSTM(RSTM),.RSTOPMODE(RSTOPMODE),
	.RSTP(RSTP),.PCIN(PCIN),.PCOUT(PCOUT),.BCOUT(BCOUT),.BCIN(BCIN));

//Clock generation 
initial begin 
	CLK=1'b0; 
	forever 
	#20 CLK=~CLK;
end 

initial begin 
	//Resetting everything 
	RSTA=1'b1; RSTB=1'b1; RSTC=1'b1; RSTD=1'b1; RSTM=1'b1; RSTOPMODE=1'b1; RSTCARRYIN=1'b1; RSTP=1'b1;
	@(negedge CLK);

	//Enabling everything 
	CEA=1'b1; CEB=1'b1; CEC=1'b1; CED=1'b1; CEM=1'b1; CEP=1'b1; CEOPMODE=1'b1; CECARRYIN=1'b1; 
	RSTA=1'b0; RSTB=1'b0; RSTC=1'b0; RSTD=1'b0; RSTM=1'b0; RSTOPMODE=1'b0; RSTCARRYIN=1'b0; RSTP=1'b0;

	//Scenario 1  , (D+B)* A , P=24
	D=18'd10; 
	A=18'd2; 
	B=18'd2; 
	BCIN=18'd5; //No need for it just making sure no effect 
	C=48'd0; 
	OPMODE=8'b00010001;
	repeat (4) @(negedge CLK); 

	//Scenario 2 , B*A , P=50 
	D=18'd0; 
	A=18'd10; 
	B=18'd5; 
	OPMODE=8'b00000001;
	repeat (4) @(negedge CLK); 

	//Scenario 3 , (D+B)*A+C , P=10
	D=18'd1;
	B=18'd3; 
	A=18'd2; 
	C=48'd2; 
	OPMODE=8'b00011101;
	repeat (4) @(negedge CLK); 

	//Scenario 4 , (B*A)+C , P=25 
	D=18'd0;
	B=18'd10; 
	A=18'd2; 
	C=48'd5;
	OPMODE=8'b00001101;
	repeat(4) @(negedge CLK); 

	//Scnaerio 5 , C+CIN , P=21
	C=48'd20; 
	OPMODE=8'b00101100; 
	CARRYIN=0; //To make sure that the value of OPMODE5 is taken not CARRYIN
	repeat(2) @(negedge CLK); 

	//Scenario 6 - Concatentation 
	D=1'd1;
	B=1'd1;
	A=1'd1; 
	OPMODE=8'b00000011;
	repeat(4) @(negedge CLK);

	//Scenario 7 , D-B , P=5 
	D=18'd10; 
	B=18'd5; 
	A=18'd1;
	OPMODE=8'b01010001;
	repeat(4) @(negedge CLK);

	//Scenario 8 , (D+B+C+CIN) , P=6;
	D=18'd3; 
	B=18'd1; 
	A=18'd1; 
	C=48'd1;
	CARRYIN=1; 
	OPMODE=8'b00111101;
	repeat(4) @(negedge CLK);


	//Scenario 9 , Z-(X+CIN) , X=B , P=14 
	D=18'd5; //No need making sure it is has no effect 
	B=18'd5; 
	A=18'd1;
	PCIN=48'd20;
	OPMODE=8'b10100101; 
	repeat(4) @(negedge CLK); 

	//Scenario 10 , Testing accumlator , P=28
	OPMODE=8'b00001010;
	CARRYIN=0;
	RSTA=1'b1; RSTB=1'b1 ; RSTC=1'b1; RSTD=1'b1; RSTCARRYIN=1'b1; RSTM=1'b1;
	//Resetting the other blocks to test the accumlator only
	repeat(2) @(negedge CLK); 	
	$stop;
end 
endmodule 
