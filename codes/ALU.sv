module ALU (
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] alu_out,
    output logic zero_flag,
    input logic [3:0]opcode
    
);



always_comb begin 

case(opcode)

4'b0000 : alu_out = A + B;
4'b0001 : alu_out = A-B;
4'b0010 : alu_out = A & B;
4'b0011 : alu_out = A | B;
4'b0100 : alu_out = A^B;
4'b0101  : alu_out =~(A & B);
4'b0110  : alu_out =~(A | B); 
4'b0111 : alu_out =~(A^B);


default: alu_out = 0;
endcase
end

assign zero_flag = (alu_out == 0) ? 1:0;
endmodule
