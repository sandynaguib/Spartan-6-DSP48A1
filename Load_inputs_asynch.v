module Load_inputs_asynch (IN,CLK,EN,OUT,RST); 

parameter PIPELINE=1; 
parameter WIDTH=18;
input [WIDTH-1:0] IN; 
input CLK,RST,EN; 
reg [WIDTH-1:0] OUT_FF ;
output [WIDTH-1:0] OUT; 


//Pipeline 
always @(posedge CLK or posedge RST) begin 
	if(RST)
		OUT_FF<=0; 
	else if (EN)
		OUT_FF<=IN; 
end 

assign OUT = (PIPELINE) ? OUT_FF : IN ; 

endmodule 