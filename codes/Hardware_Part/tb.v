`include "CPU_top.v"

module tb;

reg clk;
reg rst;

CPU dut (
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    #12;
    rst = 0;
end

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, tb);

    $display("TIME | rs1 | ID_EX_rd1 | ForwardA | EX_MEM_rd | EX_MEM_w_en | MEM_WB_rd | MEM_WB_wd | ALU_A");

    repeat(90) begin
        @(posedge clk);
        #1;

        if (dut.ID_EX_instruction !== 32'b0) begin
            $display(
                "%0t | %0d | %0d | %b | %0d | %b | %0d | %0d | %0d",
                $time,
                dut.ID_EX_rs1,
                dut.ID_EX_rd1,
                dut.ForwardA,
                dut.EX_MEM_reg_des,
                dut.EX_MEM_w_en,
                dut.MEM_WB_reg_des,
                dut.MEM_WB_wd,
                dut.ALU_A
            );
        end
    end

    $display("\nFINAL REGISTER VALUES");
    $display("R1 = %0d", dut.R.register[1]);
    $display("R2 = %0d", dut.R.register[2]);
    $display("R3 = %0d", dut.R.register[3]);
    $display("R4 = %0d", dut.R.register[4]);
    $display("MEM[15] = %0d", dut.data_memory.mem[15]);
    $display("MEM[10] = %0d", dut.data_memory.mem[10]);
    $display("R5 = %0d", dut.R.register[5]);
    $display("R6 = %0d", dut.R.register[6]);
    $display("R7 = %0d", dut.R.register[7]);

    $finish;
end

endmodule