module DM(
    input logic clk,
    input logic [31:0]mem_address,
    output logic [31:0] read_data,
    input logic [31:0]  write_data,
    input logic mem_read,
    input logic mem_write
);

logic [31:0] mem [0:31];

assign read_data = (mem_read == 1 ) ? mem[mem_address] : 0;

always @(posedge clk ) begin
    if(mem_write == 1)
    mem[mem_address] <= write_data;
end
initial begin
    mem[8] = 32'd52;
    mem[18] = 32'd46;
    mem[15] = 32'd68;
    end

endmodule
