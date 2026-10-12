
module EX_MEM(
    input wire clk, rst,
    input wire ID_EX_Halt,
    // From EX stage
    input wire [31:0] alu_out,
    input wire [3:0]  ID_EX_reg_des,
    input wire [31:0] ID_EX_rd2,

    // Control signals
    input wire ID_EX_w_en,
    input wire ID_EX_mem_read,
    input wire ID_EX_mem_write,
    input wire ID_EX_S_mux2, 

    // Debug/instruction tracking
    input wire [31:0] ID_EX_PC_out,
    input wire [31:0] ID_EX_instruction,

    // To MEM stage
    output reg [31:0] EX_MEM_alu_out,
    output reg [3:0]  EX_MEM_reg_des,
    output reg [31:0] EX_MEM_rd2,

    // Control signals
    output reg EX_MEM_w_en,
    output reg EX_MEM_mem_read,
    output reg EX_MEM_mem_write,
    output reg EX_MEM_S_mux2,
    output reg EX_MEM_Halt,

    // Debug/instruction tracking
    output reg [31:0] EX_MEM_PC_out,
    output reg [31:0] EX_MEM_instruction
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        EX_MEM_alu_out      <= 0;
        EX_MEM_reg_des      <= 0;
        EX_MEM_rd2          <= 0;

        EX_MEM_w_en         <= 0;
        EX_MEM_mem_read     <= 0;
        EX_MEM_mem_write    <= 0;
        EX_MEM_S_mux2       <= 0;

        EX_MEM_PC_out       <= 0;
        EX_MEM_instruction  <= 0;

        EX_MEM_Halt <= 0;

    end
    else begin
        EX_MEM_alu_out <= alu_out;
        EX_MEM_reg_des <= ID_EX_reg_des;
        EX_MEM_rd2 <= ID_EX_rd2;

        EX_MEM_w_en <= ID_EX_w_en;
        EX_MEM_mem_read <= ID_EX_mem_read;
        EX_MEM_mem_write <= ID_EX_mem_write;
        EX_MEM_S_mux2 <= ID_EX_S_mux2;

        EX_MEM_PC_out <= ID_EX_PC_out;
        EX_MEM_instruction <= ID_EX_instruction;
        EX_MEM_Halt <= ID_EX_Halt;
    end
end

endmodule
