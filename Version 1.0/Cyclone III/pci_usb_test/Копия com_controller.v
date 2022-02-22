module COM_controller_16C550(
input wire clk, 
input wire irdy, 
input wire reset, 
input wire baudclk_221184kHz,
input wire RX1,
input wire CTS,
input wire DSR,
input wire RI,
input wire DCD,
input wire [7:0] in_addr_bar_offset_w_io,
input wire is_COM_configured,
input wire is_COM_iospace,
input wire [7:0] addr_data_buf_in_byte,
input wire [3:0] in_command,
output devsel,
output trdy, 
output par,
output reg interrupt_pin,
output wire TX1,
output wire RTS,
output wire DTR,
output reg control,
output reg [31:0] out_add_data_io
);

parameter TRDY_DELAY = 0; //обновить схемный файл!!!

reg data_ready;
  
reg [2:0] data_ready_delay_counter;
  
always@(posedge clk)
begin
control <= !(COMF_READ_STATE);
end

assign devsel = (com_state != COMF_IDLE & !irdy) ? 1'b0 : 1'b1;
assign trdy = (!irdy & !devsel & data_ready) ? 1'b0 : 1'b1;

always@(posedge clk or posedge irdy)
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
end

///////////////////////////////////////////////////////////////

parameter COMF_RESET = 0; 
parameter COMF_IDLE = 1; 
parameter COMF_READ = 2; 
parameter COMF_RX_READ = 3;
parameter COMF_TX_WRITE = 4;
parameter COMF_IER_WRITE = 5;
parameter COMF_IIR_WRITE = 6;
parameter COMF_FCR_WRITE = 7; 
parameter COMF_LCR_WRITE = 8; 
parameter COMF_MCR_WRITE = 9;
parameter COMF_LSR_WRITE = 10;
parameter COMF_MSR_WRITE = 11;
parameter COMF_SCR_WRITE = 12;
parameter COMF_DLL_WRITE = 13;
parameter COMF_DLM_WRITE = 14;
parameter COMF_DLL_READ = 15;
parameter COMF_DLM_READ = 16;
parameter COMF_IIR_READ = 17;
parameter COMF_MCR_READ = 18;
parameter COMF_LCR_READ = 19;
parameter COMF_LSR_READ = 20;
parameter COMF_MSR_READ = 21;
parameter COMF_IER_READ = 22;
parameter COMF_TX_INT_FLAG_RESET = 23;
parameter COMF_FIFO_WRITE = 24;
parameter COMF_IER_CHECK = 25;
parameter COMF_TSR_ENABLE = 26;
parameter COMF_RX_END = 27;
parameter COMF_RX_INT_FLAG_RESET = 28;
parameter COMF_MODEM_INT_FLAG_RESET = 29;
parameter COMF_LINE_INT_FLAG_RESET = 30;
parameter COMF_TX_END = 31;

reg [7:0] RBR_COM1;
reg [7:0] THR_COM1;
reg [7:0] IER_COM1;
reg [7:0] IIR_COM1;
reg [7:0] LCR_COM1;
reg [7:0] MCR_COM1;
reg [7:0] SCR_COM1;
reg [7:0] DLL_COM1;
reg [7:0] DLM_COM1;
reg [7:0] FCR_COM1;
reg [7:0] LSR_COM1;
reg [7:0] MSR_COM1;
reg [11:0] TSR_COM1;
reg [1:0] TSR_COM1_empty;
reg [10:0] RSR_COM1;
reg [3:0] RSR_COM1_counter;
reg [3:0] RSR_COM1_bit_count;
reg [5:0] RSR_COM1_timeout_counter;

wire COMF_READ_STATE;

assign COMF_READ_STATE = com_state == COMF_DLM_READ | 
com_state == COMF_DLL_READ | com_state == COMF_RX_READ | 
com_state == COMF_IER_READ | com_state == COMF_IIR_READ | 
com_state == COMF_LCR_READ | com_state == COMF_MCR_READ |
com_state == COMF_LSR_READ | com_state == COMF_MSR_READ;

reg RX_input;

reg RSR_enable;

reg [7:0] FIFO_TX_COM1 [15:0];
reg [7:0] FIFO_RX_COM1 [15:0];

reg [3:0] FIFO_TX_COM1_raddr;
reg [3:0] FIFO_TX_COM1_waddr;

reg [3:0] FIFO_RX_COM1_raddr;
reg [3:0] FIFO_RX_COM1_waddr;

wire FIFO_TX_COM1_full;
wire FIFO_RX_COM1_full;

reg [3:0] FIFO_RX_COM1_int_trigger;
reg [3:0] FIFO_RX_COM1_int_trigger_counter;

reg [1:0] parity_error;
reg [1:0] framing_error;

reg [1:0] FIFO_TX_COM1_empty;
wire FIFO_RX_COM1_empty;

reg [1:0] CTS_COM1;
reg [1:0] DSR_COM1;
reg [1:0] RI_COM1;
reg [1:0] DCD_COM1;

assign FIFO_TX_COM1_full = (FIFO_TX_COM1_waddr == (FIFO_TX_COM1_raddr - 1));
assign FIFO_RX_COM1_full = (FIFO_RX_COM1_waddr == (FIFO_RX_COM1_raddr - 1));

always@(posedge baudclk_221184kHz)
begin
CTS_COM1[0] <= CTS;
CTS_COM1[1] <= CTS_COM1[0];
DSR_COM1[0] <= DSR;
DSR_COM1[1] <= DSR_COM1[0];
RI_COM1[0] <= RI;
RI_COM1[1] <= RI_COM1[0];
DCD_COM1[0] <= DCD;
DCD_COM1[1] <= DCD_COM1[0];
end

always@(posedge baudclk_221184kHz) 
begin
TSR_COM1_empty[0] <= !(|TSR_COM1[11:1]); // если будут глюки на линии - везде поставить подобное
TSR_COM1_empty[1] <= TSR_COM1_empty[0];  //на raddr и waddr
end

always@(posedge clk) 
begin
FIFO_TX_COM1_empty[0] <= (FIFO_TX_COM1_waddr == FIFO_TX_COM1_raddr);
FIFO_TX_COM1_empty[1] <= FIFO_TX_COM1_empty[0]; /// если глюки - убрать...
end

always@(posedge baudclk_221184kHz) 
begin
parity_error[1] <= parity_error[0];
framing_error[1] <= framing_error[0];
end

assign FIFO_RX_COM1_empty = (FIFO_RX_COM1_waddr == FIFO_RX_COM1_raddr);

always@(posedge baudclk_221184kHz)
begin
RX_input <= RX1;
end

wire TSR_COM1_load_rising_edge;
wire FIFO_TX_COM1_empty_rising_edge;
wire RX_input_falling_edge;

wire parity_error_rising_edge;
wire framing_error_rising_edge;

wire CTS_COM1_changed;
wire DSR_COM1_changed;
wire RI_COM1_changed;
wire DCD_COM1_changed;

assign parity_error_rising_edge = ~parity_error[1] & parity_error[0];
assign framing_error_rising_edge = ~framing_error[1] & framing_error[0];

assign TSR_COM1_load_rising_edge = TSR_COM1_empty[1] & ~TSR_COM1_empty[0];
assign FIFO_TX_COM1_empty_rising_edge = ~FIFO_TX_COM1_empty[0] & (FIFO_TX_COM1_waddr == FIFO_TX_COM1_raddr);
assign RX_input_falling_edge = RX_input & ~RX1;

assign CTS_COM1_changed = CTS_COM1[1] ^ CTS_COM1[0];
assign DSR_COM1_changed = DSR_COM1[1] ^ DSR_COM1[0];
assign RI_COM1_changed = RI_COM1[1] ^ RI_COM1[0];
assign DCD_COM1_changed = DCD_COM1[1] ^ DCD_COM1[0];

assign RTS = !MCR_COM1[1];
assign DTR = !MCR_COM1[0];


reg [5:0] com_state;  

always@*
begin
case({COMF_READ_STATE,{LCR_COM1[7] | in_addr_bar_offset_w_io[7]},{in_addr_bar_offset_w_io[6] | is_COM_iospace},in_addr_bar_offset_w_io[5:0]})
9'h1C0: out_add_data_io = {DLL_COM1,DLL_COM1,DLL_COM1,DLL_COM1};
9'h140: out_add_data_io = {RBR_COM1,RBR_COM1,RBR_COM1,RBR_COM1};
9'h1C1: out_add_data_io = {DLM_COM1,DLM_COM1,DLM_COM1,DLM_COM1};
9'h141: out_add_data_io = {IER_COM1,IER_COM1,IER_COM1,IER_COM1};
9'h142: out_add_data_io = {IIR_COM1,IIR_COM1,IIR_COM1,IIR_COM1};
9'h143: out_add_data_io = {LCR_COM1,LCR_COM1,LCR_COM1,LCR_COM1};
9'h144: out_add_data_io = {MCR_COM1,MCR_COM1,MCR_COM1,MCR_COM1};
9'h145: out_add_data_io = {LSR_COM1,LSR_COM1,LSR_COM1,LSR_COM1};
9'h146: out_add_data_io = {MSR_COM1,MSR_COM1,MSR_COM1,MSR_COM1};
9'h147: out_add_data_io = {SCR_COM1,SCR_COM1,SCR_COM1,SCR_COM1}; 
default:
out_add_data_io = 32'h00;
endcase
end


always@(posedge clk or negedge reset)
begin
if(!reset)
begin
com_state <= COMF_RESET;
end
else
begin
case(com_state)
COMF_RESET:
begin
com_state <= COMF_IDLE;
end
COMF_IDLE:
begin

case({is_COM_configured & is_COM_iospace & !irdy,in_command,in_addr_bar_offset_w_io[7:0]})
13'h1300: if(LCR_COM1[7]) com_state <= COMF_DLL_WRITE; else com_state <= COMF_TX_WRITE;
13'h1301: if(LCR_COM1[7]) com_state <= COMF_DLM_WRITE; else com_state <= COMF_IER_WRITE;
13'h1302: com_state <= COMF_FCR_WRITE;
13'h1303: com_state <= COMF_LCR_WRITE;
13'h1304: com_state <= COMF_MCR_WRITE;
//1305: 
//1306:
//13'h1307: com_state <= COMF_SCR_WRITE;
13'h1200: if(LCR_COM1[7]) com_state <= COMF_DLL_READ; else com_state <= COMF_RX_READ;
13'h1201: if(LCR_COM1[7]) com_state <= COMF_DLM_READ; else com_state <= COMF_IER_READ;
13'h1202: com_state <= COMF_IIR_READ;
13'h1203: com_state <= COMF_LCR_READ;
13'h1204: com_state <= COMF_MCR_READ;
13'h1205: com_state <= COMF_LSR_READ;
13'h1206: com_state <= COMF_MSR_READ;
//13'h1207: ;

endcase
end

COMF_DLL_READ:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_DLM_READ:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_RX_READ:
begin
//if(irdy)
com_state <= COMF_RX_END;
end

COMF_RX_END:
begin
if(irdy)
com_state <= COMF_IDLE;
//com_state <= COMF_RX_INT_FLAG_RESET;
end

COMF_IER_READ:
begin
//if(!IIR_COM1[0])  //если будут глюки - добавить
//com_state <= COMF_TX_INT_FLAG_RESET;
/*else*/ if(irdy)
com_state <= COMF_IDLE; 
end

COMF_IIR_READ:
begin
//if(!IIR_COM1[0])
//com_state <= COMF_TX_INT_FLAG_RESET; 
/*else*/ if(irdy)
com_state <= COMF_IDLE;
end

COMF_LCR_READ:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_MCR_READ:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_LSR_READ:
begin
if(irdy)
com_state <= COMF_IDLE;
//if(irdy)
//com_state <= COMF_LINE_INT_FLAG_RESET;
end

COMF_MSR_READ:
begin
if(irdy)
com_state <= COMF_IDLE;
//com_state <= COMF_MODEM_INT_FLAG_RESET;
end

COMF_DLL_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_TX_WRITE:
begin
//if(irdy)
//com_state <= COMF_TX_INT_FLAG_RESET;
com_state <= COMF_TX_END;
end

COMF_DLM_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_IER_WRITE:
begin
//if(irdy)
if(irdy)
com_state <= COMF_IDLE;
//com_state <= COMF_IER_CHECK;
end

/*COMF_IER_CHECK:
begin
if(irdy)
com_state <= COMF_IDLE;
end*/

/*COMF_MODEM_INT_FLAG_RESET:
begin
//if(irdy)
com_state <= COMF_IDLE;
end*/

/*COMF_TX_INT_FLAG_RESET:
begin
com_state <= COMF_IDLE;
end*/

COMF_TX_END:
begin
if(irdy)
com_state <= COMF_IDLE;
end

/*COMF_LINE_INT_FLAG_RESET:
begin
com_state <= COMF_IDLE;
end

COMF_RX_INT_FLAG_RESET:
begin
com_state <= COMF_IDLE;
end*/

COMF_FCR_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_LCR_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_MCR_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_SCR_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

endcase
end
end

assign TX1 = (TSR_COM1_empty[0]) ? 1'b1 : TSR_COM1[0];

always@(posedge baudclk_RX or negedge RSR_enable)
begin
if(!RSR_enable)
begin
RSR_COM1_counter <= 0;
end
else
begin
RSR_COM1_counter <= RSR_COM1_counter + 1;
end
end

always@(posedge baudclk_221184kHz or posedge RX_input_falling_edge)
begin
if(RX_input_falling_edge)
RSR_enable <= 1;
else
begin
if(RSR_COM1_counter == RSR_COM1_bit_count)
RSR_enable <= 0;
end
end

always@*
begin
if(LCR_COM1[3])
RSR_COM1_bit_count <= 4'hB;
else
RSR_COM1_bit_count <= 4'hA;
end

always@*
begin
case(FCR_COM1[7:6])
2'b00: FIFO_RX_COM1_int_trigger = 4'h1;
2'b01: FIFO_RX_COM1_int_trigger = 4'h4;
2'b10: FIFO_RX_COM1_int_trigger = 4'h8;
2'b11: FIFO_RX_COM1_int_trigger = 4'hE;
endcase
end

////////////////////////////////////////////////////////
///////////////////BEGIN RSR/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge baudclk_RX or negedge RSR_enable)
begin
if(!RSR_enable)
begin
RSR_COM1 <= 0;
end
else
begin
if(LCR_COM1[3])
begin
RSR_COM1 <= {RX1,RSR_COM1[10:1]};
end
else
begin
RSR_COM1 <= {RX1,RSR_COM1[9:1]};
end
end
end

always@(posedge baudclk_221184kHz)
begin
if(RSR_COM1_counter == RSR_COM1_bit_count)
begin
FIFO_RX_COM1_waddr <= FIFO_RX_COM1_waddr + 1;
case(LCR_COM1[5:0])
6'b000000: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[6]); parity_error[0] <= 0; end
6'b000001: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= 0; end
6'b000010: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= 0; end
6'b000011: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= 0; end
6'b000100: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[6]); parity_error[0] <= 0; end
6'b000101: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= 0; end
6'b000110: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= 0; end
6'b000111: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= 0; end

6'b001000: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !(^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b001001: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !(^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b001010: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !(^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b001011: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !(^RSR_COM1[8:1]) ^ RSR_COM1[9]; end
6'b001100: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !(^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b001101: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !(^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b001110: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !(^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b001111: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !(^RSR_COM1[8:1]) ^ RSR_COM1[9]; end

6'b011000: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= (^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b011001: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= (^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b011010: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= (^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b011011: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= (^RSR_COM1[8:1]) ^ RSR_COM1[9]; end
6'b011100: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= (^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b011101: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= (^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b011110: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= (^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b011111: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= (^RSR_COM1[8:1]) ^ RSR_COM1[9]; end

6'b101000: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !RSR_COM1[6]; end
6'b101001: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !RSR_COM1[7]; end
6'b101010: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !RSR_COM1[8]; end
6'b101011: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !RSR_COM1[9]; end
6'b101100: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !RSR_COM1[6]; end
6'b101101: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !RSR_COM1[7]; end
6'b101110: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !RSR_COM1[8]; end
6'b101111: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !RSR_COM1[9]; end

6'b111000: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= RSR_COM1[6]; end
6'b111001: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= RSR_COM1[7]; end
6'b111010: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= RSR_COM1[8]; end
6'b111011: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= RSR_COM1[9]; end
6'b111100: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[5:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= RSR_COM1[6]; end
6'b111101: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[6:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= RSR_COM1[7]; end
6'b111110: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[7:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= RSR_COM1[8]; end
6'b111111: begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= RSR_COM1[9]; end
default:
begin FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1]; framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= 0; end
endcase
end
end

////////////////////////////////////////////////////////
///////////////////END RSR/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge clk or negedge reset)
begin
if(!reset)
RBR_COM1 <= 8'hFF;
else
RBR_COM1 <= FIFO_RX_COM1[FIFO_RX_COM1_raddr];
end

always@(posedge clk or negedge reset)
begin
if(!reset)
THR_COM1 <= 0;
else
THR_COM1 <= FIFO_TX_COM1[FIFO_TX_COM1_raddr];
end

////////////////////////////////////////////////////////
///////////////////BEGIN CLOCKS/////////////////////////////////
/////////////////////////////////////////////////////////

reg baudclk_TX;
reg baudclk_RX;

reg [15:0] bauddiv_counter_TX;
reg [15:0] bauddiv_counter_RX;

reg baudclk_115200Hz_TX;  
reg baudclk_115200Hz_RX;  
reg [7:0] bauddiv_counter_115200Hz_TX;
reg [7:0] bauddiv_counter_115200Hz_RX;

always@(posedge baudclk_221184kHz)
begin
if(bauddiv_counter_115200Hz_TX[6] & bauddiv_counter_115200Hz_TX[5])
bauddiv_counter_115200Hz_TX <= 8'b1;
else
bauddiv_counter_115200Hz_TX <= bauddiv_counter_115200Hz_TX + 1;
end

always@(posedge baudclk_221184kHz)
begin
baudclk_115200Hz_TX <= (bauddiv_counter_115200Hz_TX[6] & bauddiv_counter_115200Hz_TX[5]);
end

always@(posedge baudclk_221184kHz)
begin
if((bauddiv_counter_115200Hz_RX[6] & bauddiv_counter_115200Hz_RX[5]) | RX_input_falling_edge)
bauddiv_counter_115200Hz_RX <= 8'b1;
else
bauddiv_counter_115200Hz_RX <= bauddiv_counter_115200Hz_RX + 1;
end

always@(posedge baudclk_221184kHz)
begin
baudclk_115200Hz_RX <= (bauddiv_counter_115200Hz_RX[6] & bauddiv_counter_115200Hz_RX[5]);
end

always@(posedge baudclk_115200Hz_RX or posedge RX_input_falling_edge)
begin
if(RX_input_falling_edge)
baudclk_RX <= 0;
else
begin
if(bauddiv_counter_RX == {DLM_COM1,DLL_COM1})
baudclk_RX <= ~baudclk_RX;
end
end

always@(posedge baudclk_115200Hz_TX)
begin
if(bauddiv_counter_TX == {DLM_COM1,DLL_COM1})
baudclk_TX <= ~baudclk_TX;
end

always@(posedge baudclk_115200Hz_TX or posedge TSR_COM1_load_rising_edge)
begin
if(TSR_COM1_load_rising_edge)
bauddiv_counter_TX <= 16'b1;
else
begin
if(bauddiv_counter_TX == {DLM_COM1,DLL_COM1})
bauddiv_counter_TX <= 16'b1;
else
bauddiv_counter_TX <= bauddiv_counter_TX + 1;
end
end

always@(posedge baudclk_115200Hz_RX or posedge RX_input_falling_edge)
begin
if(RX_input_falling_edge)
bauddiv_counter_RX <= 16'b1;
else
begin
if(bauddiv_counter_RX == {DLM_COM1,DLL_COM1})
bauddiv_counter_RX <= 16'b1;
else
bauddiv_counter_RX <= bauddiv_counter_RX + 1;
end
end

////////////////////////////////////////////////////////
///////////////////END CLOCKS/////////////////////////////////
/////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
///////////////////BEGIN TSR/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge baudclk_TX or negedge reset /*or posedge !FIFO_COM1_empty & TSR_COM1_empty*/)
begin
if(!reset)
begin
TSR_COM1 <= 0;
FIFO_TX_COM1_raddr <= 0;
end
else
begin
if(!FIFO_TX_COM1_empty[0] & TSR_COM1_empty[0] /*& irdy*/)
begin 
FIFO_TX_COM1_raddr <= FIFO_TX_COM1_raddr + 1;
case(LCR_COM1[5:0])
6'b000000: TSR_COM1 <= {6'b000001,THR_COM1[4:0],1'b0};
6'b000001: TSR_COM1 <= {5'b00001,THR_COM1[5:0],1'b0};
6'b000010: TSR_COM1 <= {4'b0001,THR_COM1[6:0],1'b0};
6'b000011: TSR_COM1 <= {3'b001,THR_COM1[7:0],1'b0};
6'b000100: TSR_COM1 <= {6'b000011,THR_COM1[4:0],1'b0};
6'b000101: TSR_COM1 <= {5'b00011,THR_COM1[5:0],1'b0}; 
6'b000110: TSR_COM1 <= {4'b0011,THR_COM1[6:0],1'b0};
6'b000111: TSR_COM1 <= {3'b011,THR_COM1[7:0],1'b0}; 

6'b001000: TSR_COM1 <= {5'b00001,!(^THR_COM1[4:0]),THR_COM1[4:0],1'b0}; 
6'b001001: TSR_COM1 <= {4'b0001,!(^THR_COM1[5:0]),THR_COM1[5:0],1'b0}; 
6'b001010: TSR_COM1 <= {3'b001,!(^THR_COM1[6:0]),THR_COM1[6:0],1'b0}; 
6'b001011: TSR_COM1 <= {2'b01,!(^THR_COM1[7:0]),THR_COM1[7:0],1'b0}; 
6'b001100: TSR_COM1 <= {5'b00011,!(^THR_COM1[4:0]),THR_COM1[4:0],1'b0}; 
6'b001101: TSR_COM1 <= {4'b0011,!(^THR_COM1[5:0]),THR_COM1[5:0],1'b0}; 
6'b001110: TSR_COM1 <= {3'b011,!(^THR_COM1[6:0]),THR_COM1[6:0],1'b0}; 
6'b001111: TSR_COM1 <= {2'b11,!(^THR_COM1[7:0]),THR_COM1[7:0],1'b0}; 

6'b011000: TSR_COM1 <= {5'b00001,^THR_COM1[4:0],THR_COM1[4:0],1'b0}; 
6'b011001: TSR_COM1 <= {4'b0001,^THR_COM1[5:0],THR_COM1[5:0],1'b0}; 
6'b011010: TSR_COM1 <= {3'b001,^THR_COM1[6:0],THR_COM1[6:0],1'b0}; 
6'b011011: TSR_COM1 <= {2'b01,^THR_COM1[7:0],THR_COM1[7:0],1'b0}; 
6'b011100: TSR_COM1 <= {5'b00011,^THR_COM1[4:0],THR_COM1[4:0],1'b0}; 
6'b011101: TSR_COM1 <= {4'b0011,^THR_COM1[5:0],THR_COM1[5:0],1'b0}; 
6'b011110: TSR_COM1 <= {3'b011,^THR_COM1[6:0],THR_COM1[6:0],1'b0}; 
6'b011111: TSR_COM1 <= {2'b11,^THR_COM1[7:0],THR_COM1[7:0],1'b0}; 

6'b101000: TSR_COM1 <= {5'b00001,1'b1,THR_COM1[4:0],1'b0}; 
6'b101001: TSR_COM1 <= {4'b0001,1'b1,THR_COM1[5:0],1'b0}; 
6'b101010: TSR_COM1 <= {3'b001,1'b1,THR_COM1[6:0],1'b0}; 
6'b101011: TSR_COM1 <= {2'b01,1'b1,THR_COM1[7:0],1'b0}; 
6'b101100: TSR_COM1 <= {5'b00011,1'b1,THR_COM1[4:0],1'b0}; 
6'b101101: TSR_COM1 <= {4'b0011,1'b1,THR_COM1[5:0],1'b0}; 
6'b101110: TSR_COM1 <= {3'b011,1'b1,THR_COM1[6:0],1'b0}; 
6'b101111: TSR_COM1 <= {2'b11,1'b1,THR_COM1[7:0],1'b0}; 

6'b111000: TSR_COM1 <= {5'b00001,1'b0,THR_COM1[4:0],1'b0}; 
6'b111001: TSR_COM1 <= {4'b0001,1'b0,THR_COM1[5:0],1'b0}; 
6'b111010: TSR_COM1 <= {3'b001,1'b0,THR_COM1[6:0],1'b0}; 
6'b111011: TSR_COM1 <= {2'b01,1'b0,THR_COM1[7:0],1'b0}; 
6'b111100: TSR_COM1 <= {5'b00011,1'b0,THR_COM1[4:0],1'b0}; 
6'b111101: TSR_COM1 <= {4'b0011,1'b0,THR_COM1[5:0],1'b0}; 
6'b111110: TSR_COM1 <= {3'b011,1'b0,THR_COM1[6:0],1'b0}; 
6'b111111: TSR_COM1 <= {2'b11,1'b0,THR_COM1[7:0],1'b0}; 
default:
TSR_COM1 <= {3'b001,THR_COM1[7:0],1'b0};
endcase
end
else
begin
TSR_COM1 <= {1'b0,TSR_COM1[11:1]};
end
end
end

////////////////////////////////////////////////////////
///////////////////END TSR/////////////////////////////////
/////////////////////////////////////////////////////////

/*always@* //насчет приоритетов - надо смотреть !!!
begin
////////
if(interrupt_LINE_condition)
interrupt_priority = 5'h10;
else if(interrupt_RX_timeout_condition)
interrupt_priority = 5'h8;
else if(interrupt_RX_int_trigger_condition)
interrupt_priority = 5'h4;
else if(interrupt_TX_condition)
interrupt_priority = 5'h2;
else if(interrupt_MODEM_condition)
interrupt_priority = 5'h1;
else
interrupt_priority = 0;
end*/


////////////////////////////////////////////////////////
///////////////////BEGIN INTERRUPTS/////////////////////////////////
/////////////////////////////////////////////////////////

wire interrupt_condition; 
wire interrupt_TX_condition; 
wire interrupt_RX_timeout_condition;
wire interrupt_RX_int_trigger_condition;
wire interrupt_MODEM_condition;
wire interrupt_LINE_condition;
assign interrupt_TX_condition = IER_COM1_changed_int_flag | FIFO_TX_COM1_empty_int_flag /*| TSR_COM1_empty_int_flag*/;

assign interrupt_condition = interrupt_TX_condition | interrupt_RX_timeout_condition | interrupt_RX_int_trigger_condition | interrupt_MODEM_condition | interrupt_LINE_condition;

assign interrupt_LINE_condition = parity_error_int_flag | framing_error_int_flag;

assign interrupt_RX_timeout_condition = FIFO_RX_COM1_timeout_int_flag;
assign interrupt_RX_int_trigger_condition = FIFO_RX_COM1_int_trigger_int_flag;

assign interrupt_MODEM_condition = CTS_COM1_changed_int_flag | DSR_COM1_changed_int_flag |
RI_COM1_changed_int_flag | DCD_COM1_changed_int_flag;

assign is_COM1_initialized = MCR_COM1[3];

always@*
begin
interrupt_pin = !(is_COM1_initialized & interrupt_condition /*& IER_COM1[1] & FIFO_COM1_empty & com_state != COMF_IIR_RESET & interrupt_a_enable*/);//!!!!!!
end

reg IER_COM1_changed_int_flag;
reg FIFO_TX_COM1_empty_int_flag;
reg FIFO_RX_COM1_int_trigger_int_flag;
reg FIFO_RX_COM1_timeout_int_flag;

reg CTS_COM1_changed_int_flag;
reg DSR_COM1_changed_int_flag;
reg RI_COM1_changed_int_flag;
reg DCD_COM1_changed_int_flag;

reg parity_error_int_flag;
reg framing_error_int_flag;

always@(posedge baudclk_221184kHz or posedge (com_state == COMF_LSR_READ & is_COM_iospace))
begin
if(com_state == COMF_LSR_READ & is_COM_iospace)
begin
parity_error_int_flag <= 0;
framing_error_int_flag <= 0;
end
else
begin
if(parity_error_rising_edge)
begin
parity_error_int_flag <= 1;
end 
if(framing_error_rising_edge)
begin
framing_error_int_flag <= 1; 
end
end
end

always@(posedge baudclk_RX or posedge (com_state == COMF_RX_READ & is_COM_iospace))
begin
if(com_state == COMF_RX_READ & is_COM_iospace)
begin
FIFO_RX_COM1_timeout_int_flag <= 0;
RSR_COM1_timeout_counter <= 0;
end
else
begin
if(!FIFO_RX_COM1_empty) //изменение !!!! если работать не будет - убрать как было
begin
RSR_COM1_timeout_counter <= RSR_COM1_timeout_counter + 1;
if((RSR_COM1_timeout_counter[4] & RSR_COM1_timeout_counter[5]))
FIFO_RX_COM1_timeout_int_flag <= 1; 
end
end
end

always@(posedge baudclk_RX or posedge (com_state == COMF_RX_READ & is_COM_iospace))
begin
if(com_state == COMF_RX_READ & is_COM_iospace)
begin
FIFO_RX_COM1_int_trigger_int_flag <= 0;
end
else
begin
if(RSR_COM1_counter == RSR_COM1_bit_count)
FIFO_RX_COM1_int_trigger_counter <= FIFO_RX_COM1_int_trigger_counter + 1;
if(FIFO_RX_COM1_int_trigger_counter == FIFO_RX_COM1_int_trigger)
begin
FIFO_RX_COM1_int_trigger_counter <= 0;
FIFO_RX_COM1_int_trigger_int_flag <= 1; 
end
end
end

always@(posedge baudclk_221184kHz or posedge (com_state == COMF_MSR_READ /*COMF_MODEM_INT_FLAG_RESET*/ & is_COM_iospace))
begin
if(com_state == COMF_MSR_READ /*COMF_MODEM_INT_FLAG_RESET*/ & is_COM_iospace)
begin
CTS_COM1_changed_int_flag <= 0;
DSR_COM1_changed_int_flag <= 0;
RI_COM1_changed_int_flag <= 0;
DCD_COM1_changed_int_flag <= 0;
MSR_COM1[3:0] <= 0;
end
else
begin
MSR_COM1[4] <= !CTS;
MSR_COM1[5] <= !DSR;
MSR_COM1[6] <= !RI;
MSR_COM1[7] <= !DCD;
if(CTS_COM1_changed & IER_COM1[3])
begin
MSR_COM1[0] <= 1;
CTS_COM1_changed_int_flag <= 1; 
end
if(DSR_COM1_changed & IER_COM1[3])
begin
MSR_COM1[1] <= 1;
DSR_COM1_changed_int_flag <= 1; 
end
if(RI_COM1_changed & IER_COM1[3])
begin
MSR_COM1[2] <= 1;
RI_COM1_changed_int_flag <= 1; 
end
if(DCD_COM1_changed & IER_COM1[3])
begin
MSR_COM1[3] <= 1;
DCD_COM1_changed_int_flag <= 1; 
end
end
end

always@(posedge clk or posedge ((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace))
begin
if((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace)
FIFO_TX_COM1_empty_int_flag <= 0;
else
begin
if(FIFO_TX_COM1_empty_rising_edge)
FIFO_TX_COM1_empty_int_flag <= 1;
end
end

always@(posedge clk or posedge ((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace))
begin
if((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace)
IER_COM1_changed_int_flag <= 0;
else
begin
if(com_state == COMF_IER_WRITE & is_COM_iospace & IER_COM1[1])
IER_COM1_changed_int_flag <= 1;
end
end

////////////////////////////////////////////////////////
///////////////////END INTERRUPTS/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge clk)
begin
if(com_state == COMF_TX_WRITE & is_COM_iospace)
FIFO_TX_COM1[FIFO_TX_COM1_waddr] <= addr_data_buf_in_byte;
end

////////////////////////////////////////////////////////
///////////////////BEGIN COM1 REGISTERS/////////////////////////////////
/////////////////////////////////////////////////////////

wire COM1_RESET;
assign COM1_RESET = (reset | !IER_COM1[7]);

wire FIFO_COM1_enable;

assign FIFO_COM1_enable = FCR_COM1[0];

always@(posedge clk or negedge COM1_RESET)
begin
if(!COM1_RESET)
begin
IER_COM1 <= 8'h00;
LCR_COM1 <= 8'h00;
MCR_COM1 <= 8'h00;
LSR_COM1 <= 8'h60;
SCR_COM1 <= 8'h00;
DLL_COM1 <= 8'h60;
DLM_COM1 <= 8'h80;
IIR_COM1 <= 8'h01;
FCR_COM1 <= 8'hC1;
FIFO_TX_COM1_waddr <= 0;
FIFO_RX_COM1_raddr <= 0;
end
else
begin
if(com_state == COMF_DLL_WRITE & is_COM_iospace)
DLL_COM1 <= addr_data_buf_in_byte;
if(com_state == COMF_DLM_WRITE & is_COM_iospace)
DLM_COM1 <= addr_data_buf_in_byte;
if(com_state == COMF_IER_WRITE & is_COM_iospace)
IER_COM1 <= addr_data_buf_in_byte;
if(com_state == COMF_LCR_WRITE & is_COM_iospace)
LCR_COM1 <= addr_data_buf_in_byte;
if(com_state == COMF_MCR_WRITE & is_COM_iospace)
MCR_COM1 <= addr_data_buf_in_byte;
if(com_state == COMF_SCR_WRITE & is_COM_iospace)
SCR_COM1 <= addr_data_buf_in_byte;
if(com_state == COMF_FCR_WRITE & is_COM_iospace)
FCR_COM1 <= addr_data_buf_in_byte;

if(com_state == COMF_TX_WRITE & is_COM_iospace)
FIFO_TX_COM1_waddr <= FIFO_TX_COM1_waddr + 1;
if(com_state == COMF_RX_READ & is_COM_iospace & !FIFO_RX_COM1_empty)
FIFO_RX_COM1_raddr <= FIFO_RX_COM1_raddr + 1;


if(interrupt_LINE_condition & IER_COM1[2])
begin
IIR_COM1[3:1] <= 3'h3;
end
else if(interrupt_RX_int_trigger_condition & IER_COM1[0] & !FIFO_RX_COM1_full)
begin
IIR_COM1[3:1] <= 3'h2;
end
else if(interrupt_RX_timeout_condition & IER_COM1[0] & !FIFO_RX_COM1_full)
begin
IIR_COM1[3:1] <= 3'h6;
end
else if(interrupt_TX_condition & IER_COM1[1] & !FIFO_TX_COM1_full)
begin
IIR_COM1[3:1] <= 3'h1;
end
else //MODEM
begin
IIR_COM1[3:1] <=  3'h0;
end

IIR_COM1[0] <= !interrupt_condition | FIFO_RX_COM1_full | FIFO_TX_COM1_full;

IIR_COM1[6] <= FIFO_COM1_enable;
IIR_COM1[7] <= FIFO_COM1_enable;

LSR_COM1[0] <= !FIFO_RX_COM1_empty;
LSR_COM1[1] <= 0;
LSR_COM1[2] <= parity_error[0];
LSR_COM1[3] <= framing_error[0];
LSR_COM1[4] <= 0;
LSR_COM1[5] <= FIFO_TX_COM1_empty[0]; 
LSR_COM1[6] <= FIFO_TX_COM1_empty[0] & TSR_COM1_empty[0]; 
LSR_COM1[7] <= !FIFO_RX_COM1_empty & (parity_error[0] | framing_error[0]);

if(FCR_COM1[2])
begin
FIFO_TX_COM1_waddr <= FIFO_TX_COM1_raddr;
FIFO_RX_COM1_raddr <= FIFO_RX_COM1_waddr;
end

end
end


////////////////////////////////////////////////////////
///////////////////END COM1 REGISTERS/////////////////////////////////
/////////////////////////////////////////////////////////


endmodule 