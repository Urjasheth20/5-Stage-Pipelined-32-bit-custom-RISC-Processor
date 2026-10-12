
`include "CPU_top.v"
module tb;

reg clk;
reg rst;

CPU dut(
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;

    end
initial begin
    rst = 1;

    #3
    rst = 0;

end

/*
always @(posedge clk) begin
    $display("\n===== t=%0t =====", $time);

    // IF stage
    $display("PC = %0d", dut.PC_out);
    $display("instruction      = %b", dut.instruction);

    // IF/ID register
    $display("IF_ID_instruction= %b", dut.IF_ID_instruction);

    // Control Unit outputs
    $display("ISA=%b op=%b rd=%0d rs1=%0d rs2=%0d imm=%0d",
             dut.CU.ISA_type,
             dut.operation,
             dut.reg_des,
             dut.rs1,
             dut.rs2,
             dut.immediate);

    $display("alu_in2=%b S_mux2=%b w_en=%b mem_r=%b mem_w=%b",
             dut.alu_in2,
             dut.S_mux2,
             dut.w_en,
             dut.mem_read,
             dut.mem_write);

    // ID/EX register
    $display("ID_EX: rd=%0d rs1=%0d rs2=%0d",
             dut.ID_EX_reg_des,
             dut.ID_EX_rs1,
             dut.ID_EX_rs2);

    $display("ID_EX_instr=%b", dut.ID_EX_instruction);

end
    
*/
always @(posedge clk)
begin
    $display(" time =%0t PC=%d rst=%b R6=%d %d %d mem[15]=%d " ,
            $time, 
            dut.PC_out,dut.rst,dut.R.register[3],dut.R.register[1],dut.R.register[2],dut.data_memory.mem[15]);
            //$display("R6 = %0d", dut.R.register[6]);
            //$display("mem[15] = %0d", dut.data_memory.mem[15]);
            $display("R1 = %0d", dut.R.register[1]);
$display("R2 = %0d", dut.R.register[2]);
$display("R3 = %0d", dut.R.register[3]);
$display("R4 = %0d", dut.R.register[4]);
$display("R5 = %0d", dut.R.register[5]);
$display("R6 = %0d", dut.R.register[6]);
$display("R7 = %0d", dut.R.register[7]);
$display("R8 = %0d", dut.R.register[8]);
$display("MEM15 = %0d", dut.data_memory.mem[15]);

            
end


initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,tb);

    $display("R6 = %0d", dut.R.register[1]);
    $display("mem[15] = %0d", dut.data_memory.mem[15]);
    $display("----- Register File -----");


end
initial begin
    #500;
    $finish;
end
endmodule
