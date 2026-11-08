
module IM (
    input wire [31:0]address,
    output wire [31:0] instruction
);

reg [7:0] mem [0:1023];
assign instruction = {mem[address+3],mem[address+2],mem[address+1],mem[address]};

initial begin
    $readmemb("program.mem", mem);
    #1;
    $display("Instruction memory word 0 = %b", mem[0]);
end
endmodule
