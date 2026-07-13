module IF_ID(
    input logic clk,rst,
    input logic [31:0]PC_out,
    input logic [31:0] instruction,
    input logic flush,
    input logic Halt,stall,

    output logic [31:0] IF_ID_PC_out,
    output logic [31:0] IF_ID_instruction,
    output logic IF_ID_Halt

);

always @(posedge clk or posedge rst)begin
    if(rst == 1)begin
        IF_ID_PC_out <= 0;
        IF_ID_instruction <= 0;
        IF_ID_Halt <= 0;
    end else if(Halt || stall) begin
        IF_ID_PC_out <= IF_ID_PC_out;
        IF_ID_instruction <= IF_ID_instruction;
     end else if (flush) begin
        IF_ID_instruction <= 0;   // Insert NOP
    end else begin
        IF_ID_PC_out <= PC_out;
        IF_ID_instruction <= instruction;
        IF_ID_Halt <= Halt;
    end
end
endmodule
