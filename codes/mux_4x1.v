
module mux_4x1(
    input wire [31:0]I0,
    input wire [31:0]I1,
    input wire [31:0]I2,
    input wire [31:0]I3,
    input wire [1:0]S,
    output reg [31:0] Y
);

always @(*)begin
    if(S == 2'b00) Y <= I0; else
    if(S == 2'b01) Y <= I1; else
    if(S == 2'b10) Y <= I2; else
    if(S == 2'b11) Y <= I3; 
end


endmodule
