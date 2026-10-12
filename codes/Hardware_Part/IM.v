
module IM (
    input wire [31:0]address,
    output wire [31:0] instruction
);

reg [7:0] mem [0:1023];
assign instruction = {mem[address+3],mem[address+2],mem[address+1],mem[address]};
initial begin
    $readmemb("C:\Users\urjas\OneDrive\Documents\VERILOG\RISC V - Single cycle to pipeline\5-Stage-Pipelined-32-bit-Custom-RISC-Processor\codes\Hardware_Part\program.mem", mem);
end

endmodule
