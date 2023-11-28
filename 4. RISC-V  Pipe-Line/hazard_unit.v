module hazard_unit (
    input rst,clk,
    input[4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE,
    input[1:0] PCSrcE,
    input [1:0] ResultSrcE,
    input[4:0] RdM,
    input RegWriteM,
    input[4:0] RdW,
    input RegWriteW,
    output reg StallF, StallD, FlushD, FlushE, 
    output reg [1:0] ForwardAE, ForwardBE
);

reg lwStall;

always @(posedge rst) {lwStall, StallF, StallD, ForwardAE, ForwardBE} = 7'b0000_000;

always @(Rs1D, Rs2D, Rs1E, Rs2E, RdE, PCSrcE, ResultSrcE, RdM, RegWriteM, RdW, RegWriteW) begin
    
    {lwStall, StallF, StallD, ForwardAE, ForwardBE} = 7'b0000_000;

    if(((Rs1E == RdM) && RegWriteM) && (Rs1E != 5'b00000))
        ForwardAE = 2'b10;
    else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 5'b00000))
        ForwardAE = 2'b01;
    else 
        ForwardAE = 2'b00;

    if(((Rs2E == RdM) && RegWriteM) && (Rs2E != 5'b00000))
        ForwardBE = 2'b10;
    else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 5'b00000))
        ForwardBE = 2'b01;
    else 
        ForwardBE = 2'b00;

    if (((Rs1D == RdE) || (Rs2D == RdE)) && (ResultSrcE == 2'b01))
        {lwStall,StallD, StallF} = 3'b111;
        
end

assign FlushD = |PCSrcE;
assign FlushE = (lwStall || |PCSrcE);
    
endmodule
