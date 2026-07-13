module Forward_unit(
    // Current instruction in EX
    input logic [3:0]ID_EX_rs1,
    input logic [3:0]ID_EX_rs2,

// Previous instruction in MEM
    input logic [3:0] EX_MEM_reg_des,
    input logic  EX_MEM_w_en,

// Instruction in WB
    input logic [3:0] MEM_WB_reg_des,
    input logic MEM_WB_w_en,
    output logic [1:0]ForwardA,
    output logic [1:0]ForwardB
);

always @(*)begin
    ForwardA = 0;
    ForwardB = 0;

    if(EX_MEM_w_en && EX_MEM_reg_des != 0 && EX_MEM_reg_des == ID_EX_rs1)
    ForwardA = 2'b10;
    else if(MEM_WB_w_en && MEM_WB_reg_des != 0 && MEM_WB_reg_des == ID_EX_rs1)
    ForwardA = 2'b01;

    if(EX_MEM_w_en && EX_MEM_reg_des != 0 && EX_MEM_reg_des == ID_EX_rs2)
    ForwardB = 2'b10;
    else if(MEM_WB_w_en && MEM_WB_reg_des != 0 && MEM_WB_reg_des == ID_EX_rs2)
    ForwardB = 2'b01;
end

endmodule
