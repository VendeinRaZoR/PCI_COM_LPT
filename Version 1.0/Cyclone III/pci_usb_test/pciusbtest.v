input wire clk,
input wire clock,
input wire irdy,
input wire stop,
output wire led,
output wire led2
);

reg [256:0] counter;

assign led2 = irdy;
assign led = counter[10]; 

always@(posedge clock)
begin
counter <= counter + 1;
end

endmodule
