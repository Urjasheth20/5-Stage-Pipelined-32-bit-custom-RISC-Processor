`include "ALU.sv"
`include "PC.sv"
`include "IM.sv"
`include "Register_file.sv"
`include "control_unit.sv"
`include "DM.sv"
`include "IF_ID.sv"
`include "ID_EX.sv"
`include "EX_MEM.sv"
`include "MEM_WB.sv"
`include "Hazard_Control_unit.sv"
`include "Forwarding_unit.sv"
`include "mux_4x1.sv"
module CPU (
    input clk,rst

);

//IF_ID
wire [31:0] IF_ID_PC_out;
wire [31:0] IF_ID_instruction;

wire mem_read,branch_eq,branch_neq,branch_taken,jump,Halt;
wire alu_in2,S_mux2;
wire [3:0] operation;
wire [3:0] rs1,rs2;
wire [31:0] ALU_B_final;
wire [3:0] reg_des;
wire [31:0] instruction,PC_out,wd,alu_out,read_data;
wire zero_flag,w_en,mem_write;
wire [16:0] immediate;
wire [16:0] PC_mux;

wire [3:0]  ID_EX_rs1, ID_EX_rs2, ID_EX_reg_des;
wire [31:0] ID_EX_rd1, ID_EX_rd2;
wire [16:0] ID_EX_immediate;
wire [3:0]  ID_EX_operation;
wire        ID_EX_S_mux2;
wire [31:0] ID_EX_PC_out, ID_EX_instruction;

wire [31:0] EX_MEM_alu_out;
wire [3:0]  EX_MEM_reg_des;

wire [31:0] EX_MEM_PC_out;
wire [31:0] EX_MEM_instruction;
wire  ID_EX_alu_in2;
wire ID_EX_mem_read;
wire ID_EX_mem_write;
wire ID_EX_w_en;

wire EX_MEM_mem_read;
wire EX_MEM_mem_write;
wire EX_MEM_w_en;

wire [31:0] EX_MEM_store_data;

wire [31:0] EX_MEM_read_data;
wire [31:0] EX_MEM_rd2;

wire [31:0] MEM_WB_read_data;
wire [31:0] MEM_WB_alu_out;

wire [3:0] MEM_WB_reg_des;

wire MEM_WB_S_mux2;
wire MEM_WB_w_en;

wire [31:0] MEM_WB_wd;
wire EX_MEM_S_mux2;
wire [31:0] MEM_WB_PC_out;
wire [31:0] MEM_WB_instruction;
wire ID_EX_branch_eq, ID_EX_branch_neq;
wire flush;
wire  ID_EX_Halt,EX_MEM_Halt,MEM_WB_Halt,stall;
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [31:0] ALU_A;
wire [31:0] ALU_B;

assign ALU_B_final = (ID_EX_alu_in2 == 0) ? ALU_B : ID_EX_immediate;

assign MEM_WB_wd = (MEM_WB_S_mux2 == 0) ? MEM_WB_alu_out : MEM_WB_read_data;

assign branch_taken =(zero_flag && ID_EX_branch_eq || branch_neq && !ID_EX_branch_neq);

assign PC_mux = (branch_taken || jump) ? ID_EX_immediate : 16'b0;


assign flush = branch_taken;

mux_4x1 input_ALU_A(
    .I0(ID_EX_rd1),
    .I1(MEM_WB_wd),
    .I2(EX_MEM_alu_out),
    .I3(32'b0),
    .S(ForwardA),
    .Y(ALU_A)
);
mux_4x1 input_ALU_B(
    .I0(ID_EX_rd2),
    .I1(MEM_WB_wd),
    .I2(EX_MEM_alu_out),
    .I3(32'b0),
    .S(ForwardB),
    .Y(ALU_B)
);

PC prog_counter(
    .clk(clk),
    .rst(rst),
    .branch(branch_taken),
    .target(PC_mux),
    .jump(jump),
    .Halt(Halt),
    .PC_out(PC_out),
    .stall(stall)
);


IM mem (
    .address(PC_out),
    .instruction(instruction)

);


IF_ID IF_ID(
    .clk(clk),
    .rst(rst),
    .PC_out(PC_out),
    .instruction(instruction),
    .IF_ID_PC_out(IF_ID_PC_out),
    .IF_ID_instruction(IF_ID_instruction),
    .flush(flush),
    .Halt(Halt),
    .stall(stall)
);

wire [31:0]rd1,rd2;

ALU alu(
    .A(ALU_A),
    .B(ALU_B_final),
    .alu_out(alu_out),
    .zero_flag(zero_flag),
    .opcode(ID_EX_operation)
);


registers R(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .reg_des(MEM_WB_reg_des),
    .rd1(rd1),
    .rd2(rd2),
    .wd(MEM_WB_wd),
    .w_en(MEM_WB_w_en)
    );

ID_EX ID_EX(
    .clk(clk),
    .rst(rst),

    // IF stage
    .IF_ID_PC_out(IF_ID_PC_out),
    .IF_ID_instruction(IF_ID_instruction),
    .flush(flush),
    .stall(stall),
   // .IF_ID_Halt(Halt),


    // Register numbers
    .rs1(rs1),
    .rs2(rs2),
    .reg_des(reg_des),
    .alu_in2(alu_in2),

    // Register data
    .rd1(rd1),
    .rd2(rd2),
    .immediate(immediate),

    // ALU signals
    .operation(operation),
    .S_mux2(S_mux2),


    //Memory control signals
    .mem_read(mem_read),
    .mem_write(mem_write),
    .w_en(w_en),
    .branch_eq(branch_eq),
    .branch_neq(branch_neq),
    

    // Outputs
    .ID_EX_rs1(ID_EX_rs1),
    .ID_EX_rs2(ID_EX_rs2),
    .ID_EX_reg_des(ID_EX_reg_des),
    .ID_EX_rd1(ID_EX_rd1),
    .ID_EX_rd2(ID_EX_rd2),
    .ID_EX_immediate(ID_EX_immediate),
    .ID_EX_operation(ID_EX_operation),
    .ID_EX_S_mux2(ID_EX_S_mux2),
    .ID_EX_PC_out(ID_EX_PC_out),
    .ID_EX_instruction(ID_EX_instruction),
    .ID_EX_alu_in2(ID_EX_alu_in2),
    .ID_EX_mem_read(ID_EX_mem_read),
    .ID_EX_mem_write(ID_EX_mem_write),
    .ID_EX_w_en(ID_EX_w_en),
    .ID_EX_branch_eq(ID_EX_branch_eq),
    .ID_EX_branch_neq(ID_EX_branch_neq)
  //  .ID_EX_Halt(ID_EX_Halt)
);



EX_MEM EX_MEM(
    .clk(clk),
    .rst(rst),

    // From EX stage
    .alu_out(alu_out),
    .ID_EX_reg_des(ID_EX_reg_des),
    .ID_EX_w_en(ID_EX_w_en),
    .ID_EX_rd2(ALU_B),
    .ID_EX_S_mux2(ID_EX_S_mux2),
 //   .ID_EX_Halt(ID_EX_Halt),
    

    .ID_EX_PC_out(ID_EX_PC_out),
    .ID_EX_instruction(ID_EX_instruction),
    .ID_EX_mem_read(ID_EX_mem_read),
    .ID_EX_mem_write(ID_EX_mem_write),

    // To MEM stage
    .EX_MEM_alu_out(EX_MEM_alu_out),
    .EX_MEM_reg_des(EX_MEM_reg_des),

    .EX_MEM_PC_out(EX_MEM_PC_out),
    .EX_MEM_instruction(EX_MEM_instruction),
    .EX_MEM_mem_read(EX_MEM_mem_read),
    .EX_MEM_mem_write(EX_MEM_mem_write),

    .EX_MEM_w_en(EX_MEM_w_en),
    .EX_MEM_rd2(EX_MEM_rd2),
    .EX_MEM_S_mux2(EX_MEM_S_mux2)
 //   .EX_MEM_Halt(EX_MEM_Halt)

);
MEM_WB MEM_WB(
    .clk(clk),
    .rst(rst),

    // Debug
    .EX_MEM_PC_out(EX_MEM_PC_out),
    .EX_MEM_instruction(EX_MEM_instruction),
 //   .EX_MEM_Halt(EX_MEM_Halt),

    // Control
    .EX_MEM_w_en(EX_MEM_w_en),
    .EX_MEM_S_mux2(EX_MEM_S_mux2),

    // Data from MEM stage
    .read_data(read_data),
    .EX_MEM_alu_out(EX_MEM_alu_out),
    .EX_MEM_reg_des(EX_MEM_reg_des),

    // Outputs to WB stage
    .MEM_WB_read_data(MEM_WB_read_data),
    .MEM_WB_alu_out(MEM_WB_alu_out),
    .MEM_WB_reg_des(MEM_WB_reg_des),

    .MEM_WB_PC_out(MEM_WB_PC_out),
    .MEM_WB_instruction(MEM_WB_instruction),

    .MEM_WB_w_en(MEM_WB_w_en),
    .MEM_WB_S_mux2(MEM_WB_S_mux2)
 //   .MEM_WB_Halt(MEM_WB_Halt)
);

control_unit CU(
    .rst(rst),
    .instruction(IF_ID_instruction),
    .operation(operation),
    .alu_in2(alu_in2),
    .S_mux2(S_mux2),
    .w_en(w_en),
    .reg_des(reg_des), 
    .rs1(rs1),
    .rs2(rs2),
    .immediate(immediate),
    .mem_read(mem_read),
    .branch_eq(branch_eq),
    .branch_neq(branch_neq),
    .jump(jump),
    .Halt(Halt),
    .mem_write(mem_write)
);

Hazard_CU Hazard_CU(
    .ID_EX_mem_read(ID_EX_mem_read),
    .ID_EX_reg_des(ID_EX_reg_des),
    .rs1(rs1),
    .rs2(rs2),
    .stall(stall)
    );

Forward_unit FU (
    .ID_EX_rs1(ID_EX_rs1),
    .ID_EX_rs2(ID_EX_rs2),

    .EX_MEM_reg_des(EX_MEM_reg_des),
    .EX_MEM_w_en(EX_MEM_w_en),

    .MEM_WB_reg_des(MEM_WB_reg_des),
    .MEM_WB_w_en(MEM_WB_w_en),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

DM data_memory(
    .clk(clk),
    .mem_address(EX_MEM_alu_out),
    .read_data(read_data),
    .write_data(EX_MEM_rd2),
    .mem_read(EX_MEM_mem_read),
    .mem_write(EX_MEM_mem_write)
    
);





endmodule
