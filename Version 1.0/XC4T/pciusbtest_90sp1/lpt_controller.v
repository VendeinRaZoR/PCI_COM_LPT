module LPT_controller_82550(
input wire clk, 
input wire irdy, 
input wire reset, 
input wire ACK,
input wire BUSY,
input wire PE,
input wire SELT,
output wire AFD,
input wire ERR,
output wire INIT,
output wire SIN,
output wire [7:0] data,
output wire STROBE,
input wire [7:0] in_addr_bar_offset_w_io,
input wire is_LPT_configured,
input wire is_LPT_iospace,
input wire [7:0] addr_data_buf_in_byte,
input wire [3:0] in_command,
output device_ready,
output par,
output reg interrupt_pin,
output reg control,
output reg [31:0] out_add_data_io
);

always@*
begin
interrupt_pin = 1;
end

//parameter TRDY_DELAY = 0; //обновить схемный файл!!!

//reg data_ready;
  
//reg [2:0] data_ready_delay_counter;

/*always@(posedge clk or posedge irdy)
begin
if(irdy)
begin
data_ready_delay_counter <= 0;
end
else
begin
data_ready_delay_counter <= data_ready_delay_counter + 1;
end
end
  
always@(posedge clk or posedge irdy)
begin
if(irdy)
begin
data_ready <= 0;
end
else
begin
if(!devsel & data_ready_delay_counter >= TRDY_DELAY)
data_ready <= 1;
end
end*/

///////////////////////////////////////////////////////////////

parameter LPTF_RESET = 0; 
parameter LPTF_IDLE = 1; 
parameter LPTF_PIR_READ = 2;
parameter LPTF_PDR_WRITE = 3;
parameter LPTF_PSR_READ = 4;
parameter LPTF_PCR_READ = 5;
parameter LPTF_PCR_WRITE = 6;
parameter LPTF_PXR_READ = 7; 
parameter LPTF_PXR_WRITE = 8; 

reg [7:0] PIR_LPT1;
reg [7:0] PDR_LPT1;
reg [7:0] PSR_LPT1;
reg [7:0] PCR_LPT1;
reg [7:0] PXR_LPT1;

reg [3:0] lpt_state;

wire LPTF_READ_STATE;

assign LPTF_READ_STATE = lpt_state == LPTF_PIR_READ | 
lpt_state == LPTF_PSR_READ | lpt_state == LPTF_PCR_READ | 
lpt_state == LPTF_PXR_READ;

always@(posedge clk)
begin
control <= !(LPTF_READ_STATE);
end

assign device_ready = ((lpt_state != LPTF_IDLE) & (lpt_state != LPTF_RESET)) ? 1'b0 : 1'b1;
//assign trdy = (!devsel & data_ready) ? 1'b0 : 1'b1;

always@*
begin
case({LPTF_READ_STATE,in_addr_bar_offset_w_io[7],in_addr_bar_offset_w_io[6] | is_LPT_iospace,in_addr_bar_offset_w_io[5:0]})
9'h140: out_add_data_io = {PIR_LPT1,PIR_LPT1,PIR_LPT1,PIR_LPT1};
9'h141: out_add_data_io = {PSR_LPT1,PSR_LPT1,PSR_LPT1,PSR_LPT1};
9'h142: out_add_data_io = {PCR_LPT1,PCR_LPT1,PCR_LPT1,PCR_LPT1};
9'h143: out_add_data_io = {PXR_LPT1,PXR_LPT1,PXR_LPT1,PXR_LPT1};
default:
out_add_data_io = 32'h00;
endcase
end

always@(posedge clk or negedge reset)
begin
if(!reset)
begin
lpt_state <= LPTF_RESET;
end
else
begin
case(lpt_state)
LPTF_RESET:
begin
lpt_state <= LPTF_IDLE;
end
LPTF_IDLE:
begin

case({is_LPT_configured & is_LPT_iospace & !irdy,in_command,in_addr_bar_offset_w_io[7:0]})
13'h1300: lpt_state <= LPTF_PDR_WRITE; 
13'h1302: lpt_state <= LPTF_PCR_WRITE;
13'h1303: lpt_state <= LPTF_PXR_WRITE;

13'h1200: lpt_state <= LPTF_PIR_READ;
13'h1201: lpt_state <= LPTF_PSR_READ;
13'h1202: lpt_state <= LPTF_PCR_READ;
13'h1203: lpt_state <= LPTF_PXR_READ;
endcase
end

LPTF_PIR_READ:
begin
if(irdy)
lpt_state <= LPTF_IDLE;
end

LPTF_PSR_READ:
begin
if(irdy)
lpt_state <= LPTF_IDLE;
end

LPTF_PCR_READ:
begin
if(irdy)
lpt_state <= LPTF_IDLE;
end

LPTF_PXR_READ:
begin
if(irdy)
lpt_state <= LPTF_IDLE;
end

LPTF_PDR_WRITE:
begin
if(irdy)
lpt_state <= LPTF_IDLE;
end

LPTF_PCR_WRITE:
begin
if(irdy)
lpt_state <= LPTF_IDLE;
end

LPTF_PXR_WRITE:
begin
if(irdy)
lpt_state <= LPTF_IDLE;
end
endcase
end
end

wire [7:0] data_buf_in;
assign data_buf_in = (PCR_LPT1[5] | PXR_LPT1[1]) ? data : 8'bz;
assign data = (!PCR_LPT1[5] & !PXR_LPT1[1]) ? PDR_LPT1 : 8'bz;

assign STROBE = !PCR_LPT1[0];
assign AFD = !PCR_LPT1[1];
assign INIT = PCR_LPT1[2];
assign SIN = !PCR_LPT1[3];

always@(posedge clk or negedge reset)
begin
if(!reset)
begin
PIR_LPT1 <= 8'hFF;
PDR_LPT1 <= 8'hFF;
PSR_LPT1 <= 8'hFF;
PCR_LPT1 <= 8'hC0;
PXR_LPT1 <= 8'h00;
end
else
begin
PSR_LPT1[7] <= !BUSY;
PSR_LPT1[6] <= ACK;
PSR_LPT1[5] <= PE;
PSR_LPT1[4] <= SELT;
PSR_LPT1[3] <= ERR;
if(lpt_state == LPTF_PCR_WRITE & is_LPT_iospace) 
PCR_LPT1[5:0] <= addr_data_buf_in_byte[5:0]; 
if(lpt_state == LPTF_PDR_WRITE & is_LPT_iospace) 
PDR_LPT1 <= addr_data_buf_in_byte;  
PIR_LPT1 <= data_buf_in;
end
end


endmodule 