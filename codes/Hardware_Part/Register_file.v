module registers (
    input wire clk,
    input wire [3:0] rs1,
    input wire [3:0] rs2,
    input wire w_en,
    input wire [3:0] reg_des,
    output wire [31:0] rd1,
    output wire [31:0] rd2,
    input wire [31:0] wd
);

reg [31:0] register [0:15];

assign rd1 = (rs1 == 0) ? 32'b0 :
             (w_en && reg_des != 0 && reg_des == rs1) ? wd :
             register[rs1];

assign rd2 = (rs2 == 0) ? 32'b0 :
             (w_en && reg_des != 0 && reg_des == rs2) ? wd :
             register[rs2];

always @(posedge clk) begin
    if (w_en && reg_des != 0)
        register[reg_des] <= wd;
end

initial begin
    register[0]  = 0;
    register[1]  = 11;
    register[2]  = 8;
    register[3]  = 2;
    register[4]  = 15;
    register[5]  = 17;
    register[6]  = 12;
    register[7]  = 25;
    register[8]  = 42;
    register[9]  = 31;
    register[10] = 63;
    register[15] = 58;
end

endmodule