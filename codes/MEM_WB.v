
module MEM_WB(
    input wire clk,
    input wire rst,

    // Debug information
    input wire [31:0] EX_MEM_PC_out,
    input wire [31:0] EX_MEM_instruction,
    input wire EX_MEM_Halt,

    // Control signals
    input wire EX_MEM_w_en,
    input wire EX_MEM_S_mux2,

    // Data from MEM stage
    input wire [31:0] read_data,
    input wire [31:0] EX_MEM_alu_out,
    input wire [3:0]  EX_MEM_reg_des,

    // Outputs to WB stage
    output reg [31:0] MEM_WB_read_data,
    output reg [31:0] MEM_WB_alu_out,
    output reg [3:0]  MEM_WB_reg_des,

    output reg [31:0] MEM_WB_PC_out,
    output reg [31:0] MEM_WB_instruction,

    output reg MEM_WB_w_en,
    output reg MEM_WB_S_mux2,
    output reg MEM_WB_Halt
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        MEM_WB_read_data <= 0;
        MEM_WB_alu_out <= 0;
        MEM_WB_reg_des <= 0;

        MEM_WB_PC_out <= 0;
        MEM_WB_instruction <= 0;

        MEM_WB_w_en <= 0;
        MEM_WB_S_mux2 <= 0;
        MEM_WB_Halt <= 0;
    end
    else begin
        MEM_WB_read_data <= read_data;
        MEM_WB_alu_out <= EX_MEM_alu_out;
        MEM_WB_reg_des <= EX_MEM_reg_des;

        MEM_WB_PC_out <= EX_MEM_PC_out;
        MEM_WB_instruction <= EX_MEM_instruction;

        MEM_WB_w_en <= EX_MEM_w_en;
        MEM_WB_S_mux2 <= EX_MEM_S_mux2;
        MEM_WB_Halt <= EX_MEM_Halt;
    end
end

endmodule
