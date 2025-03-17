module DSP_2 (A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,CLK,OPMODE,CEA,CEB,CEC,
	CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,PCIN,PCOUT,BCOUT,BCIN); 

input [17:0] A , B , D ; 
input [47:0] C ; 
input [17:0] BCIN; 
input CARRYIN,CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP; 
input RSTA,RSTB,RSTC,RSTD,RSTM,RSTOPMODE,RSTP,RSTCARRYIN; 
input [47:0] PCIN ; 
input [7:0] OPMODE ;

output [47:0] P ; 
output [35:0] M ; 
output CARRYOUT,CARRYOUTF; 
output [47:0] PCOUT; 
output [17:0] BCOUT ; 

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

wire [17:0] A0_out,B0_out,A1_out,B1_out,D_out;
wire [47:0] C_out; 
reg [17:0] Adder_out,MUX_1_out; 
wire [7:0] OPMODE_out; 
wire [35:0] Multiplier_out; 
wire [35:0] M_out;
reg Carry_cascade; 
wire Carry_cascade_out; 
reg [47:0] MUX_X_out , MUX_Z_out; 
reg [47:0] Adder_2_out;
reg Carry_out_before_reg ; 


/*-------------Stage 1---------------*/ 
generate 
if(RSTTYPE=="ASYNC") begin : async_load_inputs 
	Load_inputs_asynch #(.PIPELINE(A0REG),.WIDTH(18)) I1 (.IN(A),.EN(CEA),.OUT(A0_out),.RST(RSTA),.CLK(CLK));
	Load_inputs_asynch #(.PIPELINE(CREG),.WIDTH(48)) I2 (.IN(C),.EN(CEC),.OUT(C_out),.RST(RSTC),.CLK(CLK));
	Load_inputs_asynch #(.PIPELINE(DREG),.WIDTH(18)) I3 (.IN(D),.EN(CED),.OUT(D_out),.RST(RSTD),.CLK(CLK));
	Load_inputs_asynch #(.PIPELINE(OPMODEREG),.WIDTH(8)) I4 (.IN(OPMODE),.EN(CEOPMODE),.OUT(OPMODE_out),.RST(RSTOPMODE),.CLK(CLK));


	if(B_INPUT=="DIRECT")  begin : direct_B_input 
		Load_inputs_asynch #(.PIPELINE(B0REG),.WIDTH(18)) I5 (.IN(B),.EN(CEB),.OUT(B0_out),.RST(RSTB),.CLK(CLK));
	end 
	else begin : BCIN_B_input_asynch  
		Load_inputs_asynch #(.PIPELINE(B0REG),.WIDTH(18)) I5 (.IN(BCIN),.EN(CEB),.OUT(B0_out),.RST(RSTB),.CLK(CLK));
	end 
end 
	else begin : sync_load_inputs 
		Load_inputs_synch #(.PIPELINE(A0REG),.WIDTH(18)) I1 (.IN(A),.EN(CEA),.OUT(A0_out),.RST(RSTA),.CLK(CLK));
		Load_inputs_synch #(.PIPELINE(CREG),.WIDTH(48)) I2 (.IN(C),.EN(CEC),.OUT(C_out),.RST(RSTC),.CLK(CLK));
		Load_inputs_synch #(.PIPELINE(DREG),.WIDTH(18)) I3 (.IN(D),.EN(CED),.OUT(D_out),.RST(RSTD),.CLK(CLK));
		Load_inputs_synch #(.PIPELINE(OPMODEREG),.WIDTH(8)) I4 (.IN(OPMODE),.EN(CEOPMODE),
							.OUT(OPMODE_out),.RST(RSTOPMODE),.CLK(CLK));

		if(B_INPUT=="DIRECT") begin :  direct_B_input_synch
			Load_inputs_synch #(.PIPELINE(B0REG),.WIDTH(18)) I5 (.IN(B),.EN(CEB),.OUT(B0_out),.RST(RSTB),.CLK(CLK));
		end else begin : BCIN_B_input_synch
			Load_inputs_synch #(.PIPELINE(B0REG),.WIDTH(18)) I5 (.IN(BCIN),.EN(CEB),.OUT(B0_out),.RST(RSTB),.CLK(CLK));
		end
	end 
endgenerate 

/*-------------Stage 2---------------*/ 
generate 
	if(RSTTYPE=="ASYNC") begin :  async_pipeline_stage2 
		Load_inputs_asynch #(.PIPELINE(B1REG),.WIDTH(18)) I6 (.IN(MUX_1_out),.EN(CEB),.OUT(B1_out),.RST(RSTB),.CLK(CLK)); 
		Load_inputs_asynch #(.PIPELINE(A1REG),.WIDTH(18)) I11 (.IN(A0_out),.EN(CEA),.OUT(A1_out),.RST(RSTA),.CLK(CLK));
	end 
	else begin : sync_pipeline_stage2
	Load_inputs_synch #(.PIPELINE(B1REG),.WIDTH(18)) I6 (.IN(MUX_1_out),.EN(CEB),.OUT(B1_out),.RST(RSTB),.CLK(CLK));
	Load_inputs_synch #(.PIPELINE(A1REG),.WIDTH(18)) I11 (.IN(A0_out),.EN(CEA),.OUT(A1_out),.RST(RSTA),.CLK(CLK));
	end 

endgenerate

always @(*) begin 
	if(OPMODE_out[6])
		Adder_out=D_out-B0_out; 
	else 
		Adder_out=D_out+B0_out; 
	if(OPMODE_out[4]) 
		MUX_1_out=Adder_out;
	else 
		MUX_1_out=B0_out; 
end 
assign BCOUT=B1_out; 

/*-------------Stage 3---------------*/ 
generate 
	if(RSTTYPE=="ASYNC") begin : async_stage3 
		Load_inputs_asynch #(.PIPELINE(MREG),.WIDTH(36)) I7 (.IN(Multiplier_out),.EN(CEM),.OUT(M_out),.RST(RSTM),.CLK(CLK));
		Load_inputs_asynch #(.PIPELINE(CREG),.WIDTH(1)) I8 (.IN(Carry_cascade),.EN(CECARRYIN),.OUT(Carry_cascade_out),
							.RST(RSTCARRYIN),.CLK(CLK));
	end 
	else begin  : sync_stage3
		Load_inputs_synch #(.PIPELINE(MREG),.WIDTH(36)) I7 (.IN(Multiplier_out),.EN(CEM),
							.OUT(M_out),.RST(RSTM),.CLK(CLK));
		Load_inputs_synch #(.PIPELINE(CREG),.WIDTH(1)) I8 (.IN(Carry_cascade),.EN(CECARRYIN),.OUT(Carry_cascade_out),
							.RST(RSTCARRYIN),.CLK(CLK));
	end 
endgenerate

always @(*) begin 
	if (CARRYINSEL=="OPMODE5") 
		Carry_cascade=OPMODE_out[5]; 
	else if (CARRYINSEL=="CARRYIN")
		Carry_cascade=CARRYIN; 
	else 
		Carry_cascade=0; 
end 

assign Multiplier_out=B1_out*A1_out; 
assign M=M_out; 

/*-------------Stage 4---------------*/ 
generate 
	if(RSTTYPE=="ASYNC") begin : async_stage4 
		Load_inputs_asynch #(.PIPELINE(PREG),.WIDTH(48)) I9 (.IN(Adder_2_out),.EN(CEP),.OUT(P),.RST(RSTP),.CLK(CLK));
		Load_inputs_synch #(.PIPELINE(CARRYOUTREG),.WIDTH(1)) I10 (.IN(Carry_out_before_reg),.EN(CECARRYIN),.OUT(Carry_out_after_reg),
							.RST(RSTCARRYIN),.CLK(CLK));
	end 
	else begin : sync_stage4
		Load_inputs_synch #(.PIPELINE(PREG),.WIDTH(48)) I9 (.IN(Adder_2_out),.EN(CEP),.OUT(P),.RST(RSTP),.CLK(CLK));
		Load_inputs_synch #(.PIPELINE(CARRYOUTREG),.WIDTH(1)) I10 (.IN(Carry_out_before_reg),.EN(CECARRYIN),.OUT(CARRYOUT)
							,.RST(RSTCARRYIN),.CLK(CLK));
	end 

endgenerate 

always @(*) begin 
	case(OPMODE_out[1:0]) 
	2'b00:MUX_X_out=48'b0;
	2'b01:MUX_X_out={12'b0,M_out};
	2'b10:MUX_X_out=PCOUT; 
	2'b11:MUX_X_out={D[11:0],A[17:0],B[17:0]};
	endcase 

	case(OPMODE_out[3:2])
	2'b00:MUX_Z_out=48'b0;
	2'b01:MUX_Z_out=PCIN; 
	2'b10:MUX_Z_out=PCOUT; 
	2'b11:MUX_Z_out=C_out; 
	endcase 

	if(OPMODE_out[7])
		{Carry_out_before_reg,Adder_2_out}=MUX_Z_out-(MUX_X_out+Carry_cascade_out); 
	else 
		{Carry_out_before_reg,Adder_2_out}=MUX_Z_out+(MUX_X_out+Carry_cascade_out); 
	
end 

assign CARRYOUTF=CARRYOUT; 
assign PCOUT=P; 

endmodule 









