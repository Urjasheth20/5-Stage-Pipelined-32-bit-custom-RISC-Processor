module EX_MEM(
    input logic clk, rst,
    input logic ID_EX_Halt,
    // From EX stage
    input logic [31:0] alu_out,
    input logic [3:0]  ID_EX_reg_des,
    input logic [31:0] ID_EX_rd2,

    // Control signals
    input logic ID_EX_w_en,
    input logic ID_EX_mem_read,
    input logic ID_EX_mem_write,
    input logic ID_EX_S_mux2, 

    // Debug/instruction tracking
    input logic [31:0] ID_EX_PC_out,
    input logic [31:0] ID_EX_instruction,

    // To MEM stage
    output logic [31:0] EX_MEM_alu_out,
    output logic [3:0]  EX_MEM_reg_des,
    output logic [31:0] EX_MEM_rd2,

    // Control signals
    output logic EX_MEM_w_en,
    output logic EX_MEM_mem_read,
    output logic EX_MEM_mem_write,
    output logic EX_MEM_S_mux2,
    output logic EX_MEM_Halt,

    // Debug/instruction tracking
    output logic [31:0] EX_MEM_PC_out,
    output logic [31:0] EX_MEM_instruction
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
