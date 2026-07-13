module ID_EX(
    input logic clk, rst,
    input logic flush,stall,
    // IF stage
    input logic [31:0] IF_ID_PC_out,
    input logic [31:0] IF_ID_instruction,
    input logic IF_ID_Halt,
    input logic branch_eq, branch_neq,

    // Register numbers
    input logic [3:0] rs1,
    input logic [3:0] rs2,
    input logic [3:0] reg_des,

    // Register data
    input logic [31:0] rd1,
    input logic [31:0] rd2,
    input logic [16:0] immediate,

    // Control signals
    input logic alu_in2,
    input logic S_mux2,
    input logic w_en,
    input logic mem_read,
    input logic mem_write,

    // ALU signals
    input logic [3:0] operation,

    // Outputs
    output logic [3:0] ID_EX_rs1,
    output logic [3:0] ID_EX_rs2,
    output logic [3:0] ID_EX_reg_des,

    output logic [31:0] ID_EX_rd1,
    output logic [31:0] ID_EX_rd2,

    output logic [16:0] ID_EX_immediate,

    output logic [3:0] ID_EX_operation,

    output logic ID_EX_alu_in2,
    output logic ID_EX_S_mux2,

    output logic ID_EX_w_en,
    output logic ID_EX_mem_read,
    output logic ID_EX_mem_write,

    output logic [31:0] ID_EX_PC_out,
    output logic [31:0] ID_EX_instruction,
    output logic ID_EX_Halt,
    output logic ID_EX_branch_eq,ID_EX_branch_neq
);

always @(posedge clk or posedge rst)begin
    if(rst == 1)begin
        ID_EX_immediate <= 0;
        ID_EX_operation <=0;
        ID_EX_rd1 <= 0;
        ID_EX_rd2 <= 0;
        ID_EX_reg_des <= 0;
        ID_EX_rs1 <= 0;
        ID_EX_rs2 <= 0;
        ID_EX_S_mux2 <= 0;
        ID_EX_PC_out <= 0;
        ID_EX_instruction <=0;
        ID_EX_alu_in2 <= 0;
        ID_EX_alu_in2   <= 0;
        ID_EX_S_mux2    <= 0;
        ID_EX_w_en      <= 0;
        ID_EX_mem_read  <= 0;
        ID_EX_mem_write <= 0;
        ID_EX_branch_eq <= 0;
        ID_EX_branch_neq <= 0;
        ID_EX_Halt <= 0;
    end else  if (flush ) begin
    ID_EX_immediate <= 0;
    ID_EX_operation <= 0;
    ID_EX_rd1 <= 0;
    ID_EX_rd2 <= 0;
    ID_EX_reg_des <= 0;
    ID_EX_rs1 <= 0;
    ID_EX_rs2 <= 0;

    ID_EX_alu_in2 <= 0;
    ID_EX_S_mux2 <= 0;
    ID_EX_w_en <= 0;
    ID_EX_mem_read <= 0;
    ID_EX_mem_write <= 0;

    ID_EX_branch_eq <= 0;
    ID_EX_branch_neq <= 0;

    ID_EX_PC_out <= 0;
    ID_EX_instruction <= 32'b0;   // NOP
    end  else  if (stall ) begin
    ID_EX_immediate <= 0;
    ID_EX_operation <= 0;
    ID_EX_rd1 <= 0;
    ID_EX_rd2 <= 0;
    ID_EX_rs1 <= 0;
    ID_EX_rs2 <= 0;

    ID_EX_alu_in2 <= 0;
    ID_EX_S_mux2 <= 0;
    ID_EX_w_en <= 0;
    ID_EX_mem_read <= 0;
    ID_EX_mem_write <= 0;

    ID_EX_branch_eq <= 0;
    ID_EX_branch_neq <= 0;

    ID_EX_PC_out <= 0;
    ID_EX_instruction <= 32'b0;
    end
    else begin 
        ID_EX_immediate <= immediate;
        ID_EX_operation <=operation;
        ID_EX_rd1 <= rd1;
        ID_EX_rd2 <= rd2;
        ID_EX_reg_des <= reg_des;
        ID_EX_rs1 <= rs1;
        ID_EX_rs2 <= rs2;
        ID_EX_S_mux2 <= S_mux2;
        ID_EX_instruction <= IF_ID_instruction;
        ID_EX_PC_out <= IF_ID_PC_out;
        ID_EX_alu_in2 <= alu_in2;
        ID_EX_alu_in2   <= alu_in2;
        ID_EX_S_mux2    <= S_mux2;
        ID_EX_w_en      <= w_en;
        ID_EX_mem_read  <= mem_read;
        ID_EX_mem_write <= mem_write;
        ID_EX_branch_eq <= branch_eq;
        ID_EX_branch_neq <= branch_neq;
        ID_EX_Halt <= IF_ID_Halt;
    end
end

endmodule
