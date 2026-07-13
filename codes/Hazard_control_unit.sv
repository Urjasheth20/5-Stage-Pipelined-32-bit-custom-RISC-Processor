module Hazard_CU(
    input logic  ID_EX_mem_read,
    input logic [3:0] ID_EX_reg_des,
    input logic [3:0] rs1,
    input logic [3:0] rs2,
    output logic stall


);
always @(*) begin

    stall = 0;
     
    if(ID_EX_mem_read == 1 && ((ID_EX_reg_des == rs1) || (ID_EX_reg_des == rs2))) begin
        stall = 1;
    end
end
endmodule
