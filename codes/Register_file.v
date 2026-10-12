
module registers (
input wire clk,
input wire [3:0] rs1, // address of register 1
input wire [3:0] rs2, //  address of reg2
input wire w_en,
input wire [3:0] reg_des, //address where to store the data
output wire [31:0]rd1, //data value of reg 1
output wire [31:0] rd2, // data values of reg 2
input wire [31:0] wd // data to be written


);

reg [31:0] register [0:15];

assign rd1 = (rs1==0)? 32'b0 : register[rs1];
assign rd2 = (rs2==0)? 32'b0 : register[rs2];

always @(posedge clk )begin
    if(w_en && reg_des != 0) //Following RISC V functionality
    register[reg_des] <= wd;
end

initial begin
    register[1] = 11;
    register[2] = 8;
    register[3] = 2;
    register[4] = 15;
    register[5] = 17;
    register[8] = 75;
    register [6] = 25;
    register [7] = 25; 
    register [8] = 42;
    register [9] = 31;
    register [10] = 63;
end
endmodule
