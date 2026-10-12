
module control_unit(
    input wire rst,
    input wire [31:0]instruction,
    output reg [3:0] operation, // ALU operation

    output reg alu_in2,S_mux2,

    output reg [3:0] reg_des, // destination reg
    output reg [3:0] rs1, // source 1 reg
    output reg [3:0] rs2, // source 2 reg 
    output reg [16:0] immediate, // imm reg
    output reg w_en, // to write in a reg
    
    

    //control signals
    
    output reg mem_read,
    output reg mem_write,
    output reg branch_eq,
    output reg branch_neq,
    output reg jump,
    output reg Halt
    
    
);
reg [2:0] ISA_type;



assign ISA_type = instruction [31:29];


always @(*) begin

if(rst == 1) begin
    
    reg_des = 0;
    rs1 = 0;
    rs2 = 0;
    immediate = 0;
    w_en = 0;
     mem_read   = 0;
     mem_write = 0;
     branch_eq = 0;
     branch_neq = 0;
     jump = 0;
     Halt = 0;

end
else begin

    reg_des = 0;
    rs1 = 0;
    rs2 = 0;
    immediate = 0;
    w_en = 0;
    mem_read   = 0;
    branch_eq=0;
    branch_neq =0;
    jump = 0;
    Halt = 0;
    alu_in2 = 0;
    S_mux2  = 0;
    operation = 0;
    mem_write = 0;
    

case (ISA_type)

3'b000:  begin //R-type
operation = instruction[28:25];
reg_des = instruction[24:21];
rs1 = instruction[20:17];
rs2 = instruction[16:13];
alu_in2 = 0;
w_en = 1;
S_mux2 = 0;



end

3'b001: begin//I-type
operation = instruction[28:25];
reg_des = instruction[24:21];
rs1 = instruction[20:17];
immediate = instruction[16:0];
alu_in2 = 1;
w_en = 1;
S_mux2 = 0;

end

3'b010: begin//mem type
if(instruction[28:25]== 4'b0001) begin //store 
    operation = 4'b0000;
    rs1 = instruction[24:21]; // ALU A
    rs2 = instruction[20:17]; // Data reg
    immediate = instruction[16:0]; //offset // ALU B
    alu_in2 = 1;
    S_mux2 = 0;
    w_en = 0;
    mem_read   = 0;
    mem_write = 1;
end else begin
//load
operation = instruction[28:25];
reg_des = instruction[24:21];
rs1 = instruction[20:17];
immediate = instruction[16:0];
alu_in2= 1;
S_mux2 = 1;
w_en = 1;
mem_read   = 1;
mem_write = 0;
end
end


3'b011: begin
    if(instruction[28:25]== 4'b0000) begin //BEQ
        operation = 4'b0001;
        rs1 = instruction[24:21];
        rs2 = instruction[20:17];
        immediate = instruction[16:0]; //target
        alu_in2 = 0;
        w_en = 0;
        S_mux2 = 0; 
        branch_eq = 1;

    end else
    if(instruction[28:25]== 4'b0001) begin //BNEQ
        operation = 4'b0001;
        rs1 = instruction[24:21];
        rs2 = instruction[20:17];
        immediate = instruction[16:0]; //target
        alu_in2 = 0;
        w_en = 0;
        S_mux2 = 0; 
        branch_neq = 1;

    end 
end

// JUMP TYPE
3'b100: begin
     jump = 1;
     immediate = instruction[16:0];

end


//HALT
3'b101: begin
     Halt = 1;

end 
default: begin
    operation   = 4'b0000;
    reg_des     = 4'b0000;
    rs1         = 4'b0000;
    rs2         = 4'b0000;
    immediate   = 17'b0;
    w_en        = 1'b0;
    alu_in2     = 1'b0;
    S_mux2      = 1'b0;
    mem_read    = 1'b0;
    mem_write   = 1'b0;
    branch_eq   = 1'b0;
    branch_neq  = 1'b0;
    jump        = 1'b0;
    Halt        = 1'b0;
end


endcase

end

end

endmodule
