//РџСЂРёРјРµС‡Р°РЅРёРµ РїРѕ С‚РµРєСѓС‰РµР№ РІРµСЂСЃРёРё:
//Р’ РїСЂРёРЅС†РёРїРµ, РєРѕРЅС‚СЂРѕР»Р»РµСЂ РіРѕС‚РѕРІ, РѕРґРЅР°РєРѕ РЅР° РЅРµРєРѕС‚РѕСЂС‹С… СЃРєРѕСЂРѕСЃС‚СЏС… РґР°РЅРЅС‹Рµ РјРѕРіСѓС‚ Р±С‹С‚СЊ РЅРµРєРѕСЂСЂРµРєС‚РЅС‹ РёРЅРѕРіРґР°
//GATED-CLOCK - Р­РўРћ Р—Р›Рћ !!!
module COM_controller_16C550(
input wire clk, 
input wire irdy, 
input wire reset, 
input wire baudclk_96000kHz,
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
output device_ready,
output par,
output reg interrupt_pin,
output reg TX1,
output wire RTS,
output wire DTR,
output reg control,
output reg [31:0] out_add_data_io,
output wire baudout
);

//assign baudout = baudclk_TX;

//assign testreg = TSR_COM1[8:1];
//assign test_signal = TSR_COM1_empty[0];//TSR_COM1_load_rising_edge;

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

assign baudout = baudclk_RX;

wire COMF_READ_STATE;

reg RX_input[1:0];

reg RSR_enable;

reg [5:0] com_state;  

reg [7:0] FIFO_TX_COM1 [15:0];
reg [7:0] FIFO_RX_COM1 [15:0];

reg [3:0] FIFO_TX_COM1_raddr;
reg [3:0] FIFO_TX_COM1_waddr;

reg [3:0] FIFO_RX_COM1_raddr;
reg [3:0] FIFO_RX_COM1_waddr;

//wire FIFO_TX_COM1_full;
//wire FIFO_RX_COM1_full;

reg [3:0] FIFO_RX_COM1_int_trigger;
reg [3:0] FIFO_RX_COM1_int_trigger_counter;

reg [1:0] parity_error;
reg [1:0] framing_error;

reg FIFO_TX_COM1_empty;
reg FIFO_RX_COM1_empty;

reg interrupt_pending;

reg [1:0] CTS_COM1;
reg [1:0] DSR_COM1;
reg [1:0] RI_COM1;
reg [1:0] DCD_COM1;

reg baudclk_24000kHz;
wire baudclk_1500kHz;

reg baudclk_TX;
reg baudclk_RX;

reg [20:0] bauddiv_counter_TX;
reg [20:0] bauddiv_counter_RX;

reg [1:0] bauddiv_counter_24000kHz_1500kHz;
reg is_422_485;

reg [7:0] bauddiv_counter_115200Hz_TX;
reg [7:0] bauddiv_counter_115200Hz_RX;
reg [7:0] bauddiv_counter_230400Hz_RX;
reg [5:0] bauddiv_counter_18432kHz;

wire TSR_COM1_load_rising_edge; //использовать, чтобы ошибку устранить !!!!!!!
wire RX_input_edge;

wire parity_error_rising_edge;
wire framing_error_rising_edge;

wire CTS_COM1_changed;
wire DSR_COM1_changed;
wire RI_COM1_changed;
wire DCD_COM1_changed;

wire COM1_RESET;

wire interrupt_condition; 
wire interrupt_TX_condition; 
wire interrupt_RX_timeout_condition;
wire interrupt_RX_int_trigger_condition;
wire interrupt_MODEM_condition;
wire interrupt_LINE_condition;

wire FIFO_COM1_enable;

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

//assign FIFO_TX_COM1_full = (FIFO_TX_COM1_waddr == (FIFO_TX_COM1_raddr - 1));
//assign FIFO_RX_COM1_full = (FIFO_RX_COM1_waddr == (FIFO_RX_COM1_raddr - 1));

always@(posedge baudclk_96000kHz)
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

always@(posedge baudclk_96000kHz) 
begin
TSR_COM1_empty[0] <= (TSR_COM1[11:1] == 0); // РµСЃР»Рё Р±СѓРґСѓС‚ РіР»СЋРєРё РЅР° Р»РёРЅРёРё - РІРµР·РґРµ РїРѕСЃС‚Р°РІРёС‚СЊ РїРѕРґРѕР±РЅРѕРµ
TSR_COM1_empty[1] <= TSR_COM1_empty[0];  //РЅР° raddr Рё waddr
end

//reg FIFO_TX_COM1_full;

always@(posedge clk)
begin
FIFO_TX_COM1_empty <= (FIFO_TX_COM1_waddr == FIFO_TX_COM1_raddr);//РґР»СЏ С‚РѕРіРѕ С‡С‚РѕР±С‹ РЅРµ Р±С‹Р»Рѕ gated-clock
//FIFO_TX_COM1_empty[1] <= FIFO_TX_COM1_empty[0];
end

always@(posedge baudclk_96000kHz)
begin
FIFO_RX_COM1_empty <= (FIFO_RX_COM1_waddr == FIFO_RX_COM1_raddr);//РІ РїСЂРµСЂС‹РІР°РЅРёРё РїРѕ РїСѓСЃС‚РѕРјСѓ РїРµСЂРµРґР°СЋС‰РµРјСѓ FIFO
end //РЅСѓ Рё РґР»СЏ РїСЂРёРµРјРЅРѕРіРѕ FIFO С‚РѕР¶Рµ СЃРґРµР»Р°РµРј С‚СЂРёРіРіРµСЂ, РЅРµ Р¶РёСЂРЅРѕ

always@(posedge baudclk_96000kHz) 
begin
parity_error[1] <= parity_error[0];
framing_error[1] <= framing_error[0];
end

always@(posedge baudclk_96000kHz) //С‡Р°СЃС‚РѕС‚Р° РєСЂР°С‚РЅР°СЏ РёР»Рё Р±РѕР»СЊС€Р°СЏ 115200 РІ 3-4 СЂР°Р·Р° РґР»СЏ РѕС‚СЃР»РµР¶РёРІР°РЅРёСЏ
begin											//РґР°РЅРЅС‹С… РЅР° Р»РёРЅРёРё RX 
RX_input[0] <= RX1;
RX_input[1] <= RX_input[0];
end
//С„СЂРѕРЅС‚С‹
assign parity_error_rising_edge = ~parity_error[1] & parity_error[0];
assign framing_error_rising_edge = ~framing_error[1] & framing_error[0];

//assign TSR_COM1_load_rising_edge = TSR_COM1_empty[1] & ~TSR_COM1_empty[0];
assign RX_input_edge = RX_input[1] ^ RX_input[0]; //РІСЃРµ С„СЂРѕРЅС‚С‹ РґРѕР»Р¶РЅС‹ РїРѕСЏРІР»СЏС‚СЊСЃСЏ РїРѕ СЃРёРіРЅР°Р»Сѓ 221184 РєР“С† 
															//РёР»Рё СЃРёРіРЅР°Р»Сѓ, Р±РѕР»СЊС€РµРјСѓ С‡РµРј 115200 РёР»Рё 1500000 РІ СЂР°Р·Р° 3-4
assign CTS_COM1_changed = CTS_COM1[1] ^ CTS_COM1[0];
assign DSR_COM1_changed = DSR_COM1[1] ^ DSR_COM1[0];
assign RI_COM1_changed = RI_COM1[1] ^ RI_COM1[0];
assign DCD_COM1_changed = DCD_COM1[1] ^ DCD_COM1[0];

assign RTS = !MCR_COM1[1];
assign DTR = !MCR_COM1[0];

always@(posedge clk)
begin
control <= !(COMF_READ_STATE);
end

assign device_ready = ((com_state != COMF_IDLE) & (com_state != COMF_RESET)) ? 1'b0 : 1'b1;
//assign trdy = (!devsel & data_ready) ? 1'b0 : 1'b1;

assign COMF_READ_STATE = com_state == COMF_DLM_READ | 
com_state == COMF_DLL_READ | com_state == COMF_RX_READ | 
com_state == COMF_IER_READ | com_state == COMF_IIR_READ | 
com_state == COMF_LCR_READ | com_state == COMF_MCR_READ |
com_state == COMF_LSR_READ | com_state == COMF_MSR_READ;


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

13'h1200: if(LCR_COM1[7]) com_state <= COMF_DLL_READ; else com_state <= COMF_RX_READ;
13'h1201: if(LCR_COM1[7]) com_state <= COMF_DLM_READ; else com_state <= COMF_IER_READ;
13'h1202: com_state <= COMF_IIR_READ;
13'h1203: com_state <= COMF_LCR_READ;
13'h1204: com_state <= COMF_MCR_READ;
13'h1205: com_state <= COMF_LSR_READ;
13'h1206: com_state <= COMF_MSR_READ;

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
com_state <= COMF_RX_END;
end

COMF_RX_END:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_IER_READ:
begin
if(irdy)
com_state <= COMF_IDLE; 
end

COMF_IIR_READ:
begin
if(irdy)
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
end

COMF_MSR_READ:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_DLL_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_TX_WRITE:
begin
com_state <= COMF_TX_END;
end

COMF_DLM_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_IER_WRITE:
begin
if(irdy)
com_state <= COMF_IDLE;
end

COMF_TX_END:
begin
if(irdy)
com_state <= COMF_IDLE;
end

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

always@(posedge baudclk_TX)
begin
TX1 <= (TSR_COM1[11:1] == 0) ? 1'b1 : TSR_COM1[0];
end

always@(posedge baudclk_RX)
begin
if(RSR_COM1_counter == RSR_COM1_bit_count)
RSR_COM1_counter <= 0;
else
if(RSR_enable)
RSR_COM1_counter <= RSR_COM1_counter + 1;
end

always@(posedge baudclk_RX) ///РѕРїРѕСЂРЅР°СЏ С‡Р°СЃС‚РѕС‚Р° РёР»Рё РґСЂСѓРіР°СЏ Р»СЋР±Р°СЏ Р±РѕР»СЊС€Р°СЏ РІ 3-4 СЂР°Р·Р°, 
begin																//РєСЂР°С‚РЅР°СЏ 115200 Рё РЅРµ РјРµРЅРµРµ 230400
if(!RX_input[1]) //когда на линии RX - спадающий фронт, сначала должен сброситься тактовый генератор частоты baudclk_RX (счетчик),
begin //так как может быть ложное срабатывание по baudclk_RX в начале приема, если тактовый генератор
RSR_enable <= 1; //не успеет сброситься
end    //то есть проверка происходит на втором такте 96 МГц, своеобразная задержка на 1 такт на 96 МГц
else
begin
if(RSR_COM1_counter == RSR_COM1_bit_count)
RSR_enable <= 0;
end
end

always@*
begin
case(LCR_COM1[3:0])
4'b0000: RSR_COM1_bit_count = 4'h6;
4'b0001: RSR_COM1_bit_count = 4'h7; 
4'b0010: RSR_COM1_bit_count = 4'h8;
4'b0011: RSR_COM1_bit_count = 4'h9;
4'b0100: RSR_COM1_bit_count = 4'h6;
4'b0101: RSR_COM1_bit_count = 4'h7; 
4'b0110: RSR_COM1_bit_count = 4'h8;
4'b0111: RSR_COM1_bit_count = 4'h9;
4'b1000: RSR_COM1_bit_count = 4'h7;
4'b1001: RSR_COM1_bit_count = 4'h8;
4'b1010: RSR_COM1_bit_count = 4'h9;
4'b1011: RSR_COM1_bit_count = 4'hA;      
4'b1100: RSR_COM1_bit_count = 4'h7;
4'b1101: RSR_COM1_bit_count = 4'h8;
4'b1110: RSR_COM1_bit_count = 4'h9;
4'b1111: RSR_COM1_bit_count = 4'hA;      
endcase
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

always@(posedge baudclk_RX)
begin
if(!RSR_enable)
begin
RSR_COM1 <= 0;
end
else
begin
case(LCR_COM1[3:0])
4'b0000: RSR_COM1 <= {RX_input[1],RSR_COM1[6:1]};
4'b0001: RSR_COM1 <= {RX_input[1],RSR_COM1[7:1]};
4'b0010: RSR_COM1 <= {RX_input[1],RSR_COM1[8:1]};
4'b0011: RSR_COM1 <= {RX_input[1],RSR_COM1[9:1]};
4'b0100: RSR_COM1 <= {RX_input[1],RSR_COM1[6:1]};
4'b0101: RSR_COM1 <= {RX_input[1],RSR_COM1[7:1]};
4'b0110: RSR_COM1 <= {RX_input[1],RSR_COM1[8:1]};
4'b0111: RSR_COM1 <= {RX_input[1],RSR_COM1[9:1]};
4'b1000: RSR_COM1 <= {RX_input[1],RSR_COM1[7:1]};
4'b1001: RSR_COM1 <= {RX_input[1],RSR_COM1[8:1]};
4'b1010: RSR_COM1 <= {RX_input[1],RSR_COM1[9:1]};
4'b1011: RSR_COM1 <= {RX_input[1],RSR_COM1[10:1]};    
4'b1100: RSR_COM1 <= {RX_input[1],RSR_COM1[7:1]};
4'b1101: RSR_COM1 <= {RX_input[1],RSR_COM1[8:1]};
4'b1110: RSR_COM1 <= {RX_input[1],RSR_COM1[9:1]};
4'b1111: RSR_COM1 <= {RX_input[1],RSR_COM1[10:1]};  
endcase
end
end

always@(posedge baudclk_RX /*baudclk_24000kHz*/)
begin
if(RSR_COM1_counter == RSR_COM1_bit_count)
begin
FIFO_RX_COM1[FIFO_RX_COM1_waddr] <= RSR_COM1[8:1];
FIFO_RX_COM1_waddr <= FIFO_RX_COM1_waddr + 1;
case(LCR_COM1[5:0])
6'b000000: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[6]); parity_error[0] <= 0; end
6'b000001: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= 0; end
6'b000010: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= 0; end
6'b000011: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= 0; end
6'b000100: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[6]); parity_error[0] <= 0; end
6'b000101: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= 0; end
6'b000110: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= 0; end
6'b000111: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= 0; end

6'b001000: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !(^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b001001: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !(^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b001010: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !(^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b001011: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !(^RSR_COM1[8:1]) ^ RSR_COM1[9]; end
6'b001100: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !(^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b001101: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !(^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b001110: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !(^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b001111: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !(^RSR_COM1[8:1]) ^ RSR_COM1[9]; end

6'b011000: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= (^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b011001: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= (^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b011010: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= (^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b011011: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= (^RSR_COM1[8:1]) ^ RSR_COM1[9]; end
6'b011100: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= (^RSR_COM1[5:1]) ^ RSR_COM1[6]; end
6'b011101: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= (^RSR_COM1[6:1]) ^ RSR_COM1[7]; end
6'b011110: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= (^RSR_COM1[7:1]) ^ RSR_COM1[8]; end
6'b011111: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= (^RSR_COM1[8:1]) ^ RSR_COM1[9]; end

6'b101000: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !RSR_COM1[6]; end
6'b101001: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !RSR_COM1[7]; end
6'b101010: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !RSR_COM1[8]; end
6'b101011: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !RSR_COM1[9]; end
6'b101100: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= !RSR_COM1[6]; end
6'b101101: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= !RSR_COM1[7]; end
6'b101110: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= !RSR_COM1[8]; end
6'b101111: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= !RSR_COM1[9]; end

6'b111000: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= RSR_COM1[6]; end
6'b111001: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= RSR_COM1[7]; end
6'b111010: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= RSR_COM1[8]; end
6'b111011: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= RSR_COM1[9]; end
6'b111100: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[7]); parity_error[0] <= RSR_COM1[6]; end
6'b111101: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[8]); parity_error[0] <= RSR_COM1[7]; end
6'b111110: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= RSR_COM1[8]; end
6'b111111: begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[10]); parity_error[0] <= RSR_COM1[9]; end
default:
begin framing_error[0] <= !(!RSR_COM1[0] & RSR_COM1[9]); parity_error[0] <= 0; end
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

always@(posedge baudclk_96000kHz)
is_422_485 <= 0;

always@(posedge baudclk_96000kHz)
begin
if(RX_input_edge)
{baudclk_24000kHz,bauddiv_counter_24000kHz_1500kHz}  <= 0;
else
{baudclk_24000kHz,bauddiv_counter_24000kHz_1500kHz} <= bauddiv_counter_24000kHz_1500kHz + 1'b1;
end

always@(posedge baudclk_96000kHz)
begin
if(com_state == COMF_TX_WRITE)
baudclk_TX <= 0;
else
if(bauddiv_counter_TX == {DLM_COM1,DLL_COM1,5'h00}) //для частоты свыше 10 МГц - дополнительная синхронизация
baudclk_TX <= ~baudclk_TX;             					//с тактовой частотой шины PCI
end

always@(posedge baudclk_96000kHz)
begin
if(com_state == COMF_TX_WRITE)
bauddiv_counter_TX <= 16'b1;
else
if(bauddiv_counter_TX == {DLM_COM1,DLL_COM1,5'h00})
bauddiv_counter_TX <= 16'b1;
else
bauddiv_counter_TX <= bauddiv_counter_TX + 1;
end

always@(posedge baudclk_96000kHz)
begin
if(RX_input_edge)
baudclk_RX <= 0;
else
if(bauddiv_counter_RX == {DLM_COM1,DLL_COM1,5'h00})
baudclk_RX <= ~baudclk_RX;
end

always@(posedge baudclk_96000kHz)
begin
if(RX_input_edge)
bauddiv_counter_RX <= 16'b1;
else
if(bauddiv_counter_RX == {DLM_COM1,DLL_COM1,5'h00})
bauddiv_counter_RX <= 16'b1;
else
bauddiv_counter_RX <= bauddiv_counter_RX + 1;
end

////////////////////////////////////////////////////////
///////////////////END CLOCKS/////////////////////////////////
/////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
///////////////////BEGIN TSR/////////////////////////////////
/////////////////////////////////////////////////////////

//Р­С‚Рѕ РјРµСЃС‚Рѕ РЅР°РґРѕ Р±СѓРґРµС‚ РїРѕСЃРјРѕС‚СЂРµС‚СЊ РїСЂРё РјРѕРґРµР»РёСЂРѕРІР°РЅРёРё !!!!!!!
//РґР°РЅРЅС‹Рµ РЅРµ СѓСЃРїРµРІР°СЋС‚ Р·Р°РіСЂСѓР·РёС‚СЊСЃСЏ РІ THR Рё РїРѕРїР°РґР°СЋС‚ РІ TSR
//Рђ С‚Р°РєР¶Рµ, TSR РјРѕР¶РµС‚ Р·Р°РіСЂСѓР·РёС‚СЊСЃСЏ РІ Р»СЋР±РѕР№ РјРѕРјРµРЅС‚, С‚Р°Рє РєР°Рє FIFO_TX_COM1_empty 
//Рё СЃРґРІРёРіРѕРІС‹Р№ СЂРµРіРёСЃС‚СЂ TSR С‚Р°РєС‚РёСЂСѓСЋС‚СЃСЏ РѕС‚ СЂР°Р·РЅС‹С… С‚Р°РєС‚РѕРІС‹С… С‡Р°СЃС‚РѕС‚, РєРѕС‚РѕСЂС‹Рµ РЅРµ СЃРѕРІРїР°РґР°СЋС‚ РїРѕ С„Р°Р·Рµ Рё РЅРµ РєСЂР°С‚РЅС‹

always@(posedge baudclk_TX or negedge reset)
begin
if(!reset)
begin
TSR_COM1 <= 0;
FIFO_TX_COM1_raddr <= 0;
end
else
begin
if(!FIFO_TX_COM1_empty & (TSR_COM1[11:1] == 0) & irdy/*& com_state != COMF_TX_WRITE & com_state != COMF_TX_END*/)
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


////////////////////////////////////////////////////////
///////////////////BEGIN INTERRUPTS/////////////////////////////////
/////////////////////////////////////////////////////////
assign interrupt_TX_condition = IER_COM1_changed_int_flag | FIFO_TX_COM1_empty_int_flag;

assign interrupt_condition = (interrupt_TX_condition & IER_COM1[1]) | (interrupt_RX_timeout_condition & IER_COM1[0]) | (interrupt_RX_int_trigger_condition & IER_COM1[0]) | (interrupt_MODEM_condition & IER_COM1[3]) | (interrupt_LINE_condition & IER_COM1[2]);

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

always@(posedge baudclk_96000kHz or posedge (com_state == COMF_LSR_READ & is_COM_iospace))
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
RSR_COM1_timeout_counter <= 0;
end
else
begin
if(FIFO_RX_COM1_empty | !RX_input[1]) 
RSR_COM1_timeout_counter <= 0;
else
RSR_COM1_timeout_counter <= RSR_COM1_timeout_counter + 1;
end
end

always@(posedge baudclk_RX or posedge (com_state == COMF_RX_READ & is_COM_iospace))
begin
if(com_state == COMF_RX_READ & is_COM_iospace)
begin
FIFO_RX_COM1_timeout_int_flag <= 0;
end
else
begin
if(RSR_COM1_timeout_counter[4] & RSR_COM1_timeout_counter[5])
FIFO_RX_COM1_timeout_int_flag <= 1; 
end
end

always@(posedge baudclk_RX or posedge (com_state == COMF_RX_READ & is_COM_iospace)/*baudclk_24000kHz*/) ///РѕРїРѕСЂРЅР°СЏ С‡Р°СЃС‚РѕС‚Р° РёР»Рё РґСЂСѓРіР°СЏ Р»СЋР±Р°СЏ Р±РѕР»СЊС€Р°СЏ РєСЂР°С‚РЅР°СЏ 115200 РґР»СЏ С‚СЂРёРіРіРµСЂР°
begin                             //С‚Р°Рє РєР°Рє RSR_COM1_counter РѕС‚ СЌС‚РѕР№ С‡Р°СЃС‚РѕС‚С‹ СЂР°Р±РѕС‚Р°РµС‚, РїРѕСЌС‚РѕРјСѓ РЅРµ РјРµРЅСЏС‚СЊ !
if(com_state == COMF_RX_READ & is_COM_iospace)
FIFO_RX_COM1_int_trigger_counter <= 0;
else
begin
if(RSR_COM1_counter == RSR_COM1_bit_count)
FIFO_RX_COM1_int_trigger_counter <= FIFO_RX_COM1_int_trigger_counter + 1;
end
end

always@(posedge baudclk_RX or posedge (com_state == COMF_RX_READ & is_COM_iospace)) 
begin   ///РѕРїРѕСЂРЅР°СЏ С‡Р°СЃС‚РѕС‚Р° РёР»Рё РґСЂСѓРіР°СЏ Р»СЋР±Р°СЏ Р±РѕР»СЊС€Р°СЏ РєСЂР°С‚РЅР°СЏ 115200 РґР»СЏ С‚СЂРёРіРіРµСЂР°
if(com_state == COMF_RX_READ & is_COM_iospace)
FIFO_RX_COM1_int_trigger_int_flag <= 0;
else
begin
if((FIFO_RX_COM1_int_trigger_counter == FIFO_RX_COM1_int_trigger))
FIFO_RX_COM1_int_trigger_int_flag <= 1; 
end
end

always@(posedge baudclk_96000kHz or posedge (com_state == COMF_MSR_READ & is_COM_iospace))
begin
if(com_state == COMF_MSR_READ & is_COM_iospace)
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
//if(!interrupt_pending)
CTS_COM1_changed_int_flag <= 1; 
end
if(DSR_COM1_changed & IER_COM1[3])
begin
MSR_COM1[1] <= 1;
//if(!interrupt_pending)
DSR_COM1_changed_int_flag <= 1;
end 
if(RI_COM1_changed & IER_COM1[3])
begin
MSR_COM1[2] <= 1;
//if(!interrupt_pending)
RI_COM1_changed_int_flag <= 1; 
end
if(DCD_COM1_changed & IER_COM1[3])
begin
MSR_COM1[3] <= 1;
//if(!interrupt_pending)
DCD_COM1_changed_int_flag <= 1; 
end
end
end

always@(posedge FIFO_TX_COM1_empty or posedge ((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace))
begin
if((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace)
FIFO_TX_COM1_empty_int_flag <= 0;//irdy - С‡С‚РѕР±С‹ IIR РЅРµ РёР·РјРµРЅСЏР»СЃСЏ РїРѕ С…РѕРґСѓ РµРіРѕ С‡С‚РµРЅРёСЏ, С‚Рѕ РµСЃС‚СЊ СЃР±СЂРѕСЃ РїСЂРµСЂС‹РІР°РЅРёСЏ
else										//РїРѕСЃР»Рµ С‡С‚РµРЅРёСЏ IIR
begin
//if(/*!interrupt_pending & (com_state != COMF_IIR_READ)*/) //РјРѕР¶РЅРѕ СѓР±СЂР°С‚СЊ, РґСѓРјР°СЋ, РЅРѕ РЅР°РґРѕ С‡С‚РѕР±С‹ СЂР°Р±РѕС‚Р°Р»Рѕ СЃ СѓС‡РµС‚РѕРј РїСЂРµСЂС‹РІР°РЅРёСЏ IER
FIFO_TX_COM1_empty_int_flag <= 1;
end
end

always@(posedge IER_COM1[1] or posedge ((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace))
begin
if((com_state == COMF_IIR_READ | com_state == COMF_IER_READ) & is_COM_iospace)
IER_COM1_changed_int_flag <= 0; //irdy - С‡С‚РѕР±С‹ IIR РЅРµ РёР·РјРµРЅСЏР»СЃСЏ РїРѕ С…РѕРґСѓ РµРіРѕ С‡С‚РµРЅРёСЏ, С‚Рѕ РµСЃС‚СЊ СЃР±СЂРѕСЃ РїСЂРµСЂС‹РІР°РЅРёСЏ
else												//РїРѕСЃР»Рµ С‡С‚РµРЅРёСЏ IIR
begin
//if(!interrupt_pending)
IER_COM1_changed_int_flag <= 1;
end
end

always@(posedge (com_state == COMF_IIR_READ) or posedge interrupt_condition)
begin
if(interrupt_condition)
interrupt_pending <= 1;
else
interrupt_pending <= 0;
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
assign COM1_RESET = (reset | !IER_COM1[7]);

assign FIFO_COM1_enable = FCR_COM1[0];

always@(posedge clk or negedge reset/*COM1_RESET*/)
begin
if(!reset/*COM1_RESET*/)
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
//if(com_state == COMF_FCR_WRITE & is_COM_iospace) //РѕСЃС‚Р°РІРёС‚СЊ - РјРѕР¶РЅРѕ Р±СѓРґРµС‚ СѓР±РёСЂР°С‚СЊ СЂРµР¶РёРј FIFO
//FCR_COM1 <= addr_data_buf_in_byte;

if(com_state == COMF_TX_WRITE & is_COM_iospace)
FIFO_TX_COM1_waddr <= FIFO_TX_COM1_waddr + 1;
if(com_state == COMF_RX_READ & is_COM_iospace & !FIFO_RX_COM1_empty)
FIFO_RX_COM1_raddr <= FIFO_RX_COM1_raddr + 1;


if(interrupt_LINE_condition & IER_COM1[2])
begin
if(com_state != COMF_IIR_READ)
IIR_COM1[3:1] <= 3'h3;
end
else if(interrupt_RX_int_trigger_condition & IER_COM1[0] /*& !FIFO_RX_COM1_full*/)
begin
if(com_state != COMF_IIR_READ)
IIR_COM1[3:1] <= 3'h2;
end
else if(interrupt_RX_timeout_condition & IER_COM1[0] /*& !FIFO_RX_COM1_full*/)
begin
if(com_state != COMF_IIR_READ)
IIR_COM1[3:1] <= 3'h6;
end
else if(interrupt_TX_condition & IER_COM1[1] /*& !FIFO_TX_COM1_full*/)
begin
if(com_state != COMF_IIR_READ)
IIR_COM1[3:1] <= 3'h1;
end
else //MODEM
begin
if(com_state != COMF_IIR_READ)
IIR_COM1[3:1] <=  3'h0;
end

//if(com_state != COMF_IIR_READ)
IIR_COM1[0] <= !interrupt_pending;//!interrupt_condition | FIFO_RX_COM1_full | FIFO_TX_COM1_full;

IIR_COM1[6] <= FIFO_COM1_enable;
IIR_COM1[7] <= FIFO_COM1_enable;

LSR_COM1[0] <= !FIFO_RX_COM1_empty;
LSR_COM1[1] <= 0;
LSR_COM1[2] <= parity_error[0];
LSR_COM1[3] <= framing_error[0];
LSR_COM1[4] <= 0;
LSR_COM1[5] <= FIFO_TX_COM1_empty; 
LSR_COM1[6] <= FIFO_TX_COM1_empty & (TSR_COM1[11:1] == 0); 
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