module PCI_io(
input clk,
input wire [31:0] in_cs_addr_data,
input wire [31:0] in_io_addr_data_device0,
input wire [31:0] in_io_addr_data_device1,
input wire [31:0] in_io_addr_data_device2,
input wire [31:0] in_io_addr_data_device3,
input wire [31:0] in_in_addr_data_buf,
input wire control,
input wire is_config_space,
input wire is_io_space0,
input wire is_io_space1,
input wire is_io_space2,
input wire is_io_space3,
output wire [31:0] out_in_addr_data_buf,
output wire [31:0] out_addr_data 
);

reg [31:0] in_io_addr_data;

always@*
begin
case({is_io_space0,is_io_space1,is_io_space2,is_io_space3})
4'b1000: in_io_addr_data = in_io_addr_data_device0;
4'b0100: in_io_addr_data = in_io_addr_data_device1;
4'b0010: in_io_addr_data = in_io_addr_data_device2;
4'b0001: in_io_addr_data = in_io_addr_data_device3;
default:
in_io_addr_data = 0;
endcase
end

reg [31:0] out_addr_data_reg;

assign out_addr_data = (!control) ?  out_addr_data_reg : 32'bz; 

always@(posedge clk)
begin
out_addr_data_reg <= is_config_space ? in_cs_addr_data : in_io_addr_data;
end

assign out_in_addr_data_buf = (control) ? in_in_addr_data_buf : 32'bz;


endmodule 