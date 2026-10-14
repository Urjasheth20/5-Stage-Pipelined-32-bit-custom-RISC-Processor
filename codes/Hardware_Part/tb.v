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

    #15;
    $display("\n===== Register Values After Each Instruction =====");

    // Wait for the program to execute
    repeat (90) begin
        @(posedge clk);
        #1;

        if (dut.MEM_WB_w_en &&
            dut.MEM_WB_instruction != 32'b0) begin

            $display("\nTime = %0t | PC = %0d",
                     $time, dut.PC_out);

            $display("R0=%0d R1=%0d R2=%0d R3=%0d",
                     dut.R.register[0],
                     dut.R.register[1],
                     dut.R.register[2],
                     dut.R.register[3]);

            $display("R4=%0d R5=%0d R6=%0d R7=%0d",
                     dut.R.register[4],
                     dut.R.register[5],
                     dut.R.register[6],
                     dut.R.register[7]);

            $display("R8=%0d R9=%0d R10=%0d",
                     dut.R.register[8],
                     dut.R.register[9],
                     dut.R.register[10]);
        end

        
    end
    always @(posedge clk) begin
    #1;
    $display(
        "t=%0t PC=%0d WB_en=%b WB_instr=%h R6=%0d",
        $time,
        dut.PC_out,
        dut.MEM_WB_w_en,
        dut.MEM_WB_instruction,
        dut.R.register[6]
    );
end

    

    $finish;
end

endmodule