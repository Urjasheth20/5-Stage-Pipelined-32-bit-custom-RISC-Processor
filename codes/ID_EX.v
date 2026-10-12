
module ID_EX(
    input wire clk, rst,
    input wire flush,stall,
    // IF stage
    input wire [31:0] IF_ID_PC_out,
    input wire [31:0] IF_ID_instruction,
    input wire IF_ID_Halt,
    input wire branch_eq, branch_neq,

    // Register numbers
    input wire [3:0] rs1,
    input wire [3:0] rs2,
    input wire [3:0] reg_des,

    // Register data
    input wire [31:0] rd1,
    input wire [31:0] rd2,
    input wire [16:0] immediate,

    // Control signals
    input wire alu_in2,
    input wire S_mux2,
    input wire w_en,
    input wire mem_read,
    input wire mem_write,

    // ALU signals
    input wire [3:0] operation,

    // Outputs
    output reg [3:0] ID_EX_rs1,
    output reg [3:0] ID_EX_rs2,
    output reg [3:0] ID_EX_reg_des,

    output reg [31:0] ID_EX_rd1,
    output reg [31:0] ID_EX_rd2,

    output reg [16:0] ID_EX_immediate,

    output reg [3:0] ID_EX_operation,

    output reg ID_EX_alu_in2,
    output reg ID_EX_S_mux2,

    output reg ID_EX_w_en,
    output reg ID_EX_mem_read,
    output reg ID_EX_mem_write,

    output reg [31:0] ID_EX_PC_out,
    output reg [31:0] ID_EX_instruction,
    output reg ID_EX_Halt,
    output reg ID_EX_branch_eq,ID_EX_branch_neq
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
