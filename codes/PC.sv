module PC (
    input logic clk,
    input logic rst,
    input logic branch,
    input logic jump,
    input logic [16:0]target,
   // input logic zero, //flag
    input logic Halt,stall,
    output logic [31:0] PC_out
);

initial begin
    PC_out = 0;
end


always @(posedge clk or posedge rst)begin
    if(rst == 1) PC_out <= 0;
    else
    if(Halt == 1 || stall == 1) PC_out <= PC_out;
    else
    if(jump == 1) PC_out <=  target;
    else
    if(branch == 1 )
    PC_out <= target;
    else
    PC_out <= PC_out+ 4;
end
endmodule
