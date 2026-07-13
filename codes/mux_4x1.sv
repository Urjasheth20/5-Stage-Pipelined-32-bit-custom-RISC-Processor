module mux_4x1(
    input logic [31:0]I0,
    input logic [31:0]I1,
    input logic [31:0]I2,
    input logic [31:0]I3,
    input logic [1:0]S,
    output logic [31:0] Y
);

always @(*)begin
    if(S == 2'b00) Y <= I0; else
    if(S == 2'b01) Y <= I1; else
    if(S == 2'b10) Y <= I2; else
    if(S == 2'b11) Y <= I3; 
end


endmodule
