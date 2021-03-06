//РџСЂРёРјРµС‡Р°РЅРёРµ РїРѕ С‚РµРєСѓС‰РµР№ РІРµСЂСЃРёРё:
//1.РЎРґРµР»Р°С‚СЊ РїСЂРѕРІРµСЂРєСѓ РЅР° РѕС€РёР±РєСѓ РїРµСЂРµРїРѕР»РЅРµРЅРёСЏ СЃ РїСЂРµСЂС‹РІР°РЅРёРµРј
//2.РЎРґРµР»Р°С‚СЊ РїСЂРѕРІРµСЂРєСѓ РЅР° С‡РµС‚РЅРѕСЃС‚СЊ Рё РѕС€РёР±РєСѓ РєР°РґСЂР° СЃ РїСЂРµСЂС‹РІР°РЅРёРµРј
//3.РћР±СЂР°Р±РѕС‚РєР° РјРѕРґРµРјРЅС‹С… СЃРёРіРЅР°Р»РѕРІ СЃ РїСЂРµСЂС‹РІР°РЅРёРµРј (РїРѕ-Р¶РµР»Р°РЅРёСЋ)
//4.РЎРґРµР»Р°С‚СЊ LOOP Р·Р°РјС‹РєР°РЅРёРµ RX Рё TX СЃРёРіРЅР°Р»РѕРІ РІРЅСѓС‚СЂРё (С‚РµСЃС‚РёСЂРѕРІР°РЅРёРµ)
//1.Overflow Interrupt 
//2.Modem Interrupt (CTS,RTS)
//3.Parerror, frameerror interrupts
//4.LOOP RX TX
//5.FIFO TX on some speeds glitch!!! (maybe)
//6.Some unused registers
`timescale 1 ns/ 1 ps
module com_controller(
input wire I_CLK_BUS, 
input wire I_CLK_DEV,
input wire _I_RESET, 
input wire I_OE_WE_DEV,
input wire I_RX,
input wire I_CTS,
input wire I_DSR,
input wire I_RI,
input wire I_DCD,
input wire I_DEVSEL,
input wire [31:0] I_ADDR,
input wire [3:0] I_BE,
output O_PAR,
output O_INTX,
output O_TX,
output wire O_RTS,
output wire O_DTR,
output reg O_DEVRDY,
inout [31:0] IO_AD,
output baudclk
);

//assign baudclk = strb_tx;

reg [31:0] O_AD;
wire [31:0] I_AD;

reg [7:0] adnbyte;

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
reg [10:0] RSR_COM1;
reg [5:0] rx_timeout_cntr;
reg rx_done;

reg rx_in[1:0];

reg rx_shift_en;

reg [7:0] FIFO_TX_COM1 [15:0];
reg [7:0] FIFO_RX_COM1 [15:0];

reg [3:0] fifo_tx_raddr;
reg [3:0] fifo_tx_waddr;

reg [3:0] fifo_rx_raddr;
reg [3:0] fifo_rx_waddr;

reg [3:0] fifo_rx_itrig;
reg [3:0] fifo_rx_itrig_cntr;

reg [1:0] par_err;
reg [1:0] frame_err;

wire fifo_tx_empty;
wire fifo_rx_empty;
wire tx_shift_empty;

//reg [1:0] CTS_COM1;
//reg [1:0] DSR_COM1;
//reg [1:0] RI_COM1;
//reg [1:0] DCD_COM1;

reg strb_tx;
reg strb_rx;

reg [20:0] strb_cntr_tx;
reg [20:0] strb_cntr_rx;

wire rx_edge;
wire ier_1_posedge;

//wire parity_error_rising_edge;
//wire framing_error_rising_edge;

//wire CTS_COM1_changed;
//wire DSR_COM1_changed;
//wire RI_COM1_changed;
//wire DCD_COM1_changed;

wire COM1_RESET;

wire int_cond; 
wire int_tx_cond;  
wire int_rx_cond;
wire int_rx_itrig_cond;
wire int_modem_cond;
wire int_line_cond;

reg ier_1_iflag;
reg fifo_tx_empty_iflag;
reg fifo_rx_int_trig_iflag;
reg fifo_rx_timeout_iflag;

reg CTS_COM1_changed_int_flag;
reg DSR_COM1_changed_int_flag;
reg RI_COM1_changed_int_flag;
reg DCD_COM1_changed_int_flag;

reg par_err_iflag;
reg frame_err_iflag;

reg [7:0] ioaddr_dcdr;

reg int_running;

reg strb_rx_en;
reg strb_tx_en;

assign IO_AD = I_OE_WE_DEV ? O_AD : 32'hz;
assign I_AD = !I_OE_WE_DEV ? IO_AD : 32'hz;

always@*
begin
case(I_BE)
4'b0001: adnbyte = I_AD[7:0];
4'b0010: adnbyte = I_AD[15:8];
4'b0100: adnbyte = I_AD[23:16];
4'b1000: adnbyte = I_AD[31:24];
default: 
adnbyte = I_AD[7:0];
endcase
end

/*always@(posedge baudclk_96000kHz)
begin
CTS_COM1[0] <= CTS;
CTS_COM1[1] <= CTS_COM1[0];
DSR_COM1[0] <= DSR;
DSR_COM1[1] <= DSR_COM1[0];
RI_COM1[0] <= RI;
RI_COM1[1] <= RI_COM1[0];
DCD_COM1[0] <= DCD;
DCD_COM1[1] <= DCD_COM1[0];
end*/

always@(posedge I_CLK_BUS or negedge _I_RESET)
begin
if(!_I_RESET)
O_DEVRDY <= 0;
else
O_DEVRDY <= I_DEVSEL & ~O_DEVRDY;
end

assign fifo_tx_empty = (fifo_tx_waddr == fifo_tx_raddr);

assign fifo_rx_empty = (fifo_rx_waddr == fifo_rx_raddr);

always@(posedge I_CLK_DEV or posedge rx_shift_en)
begin
if(rx_shift_en)
strb_rx_en <= 1;
else
if(fifo_rx_empty | !_I_RESET)
strb_rx_en <= 0;
end 

always@(posedge I_CLK_DEV or posedge ioaddr_dcdr[0] & O_DEVRDY & !I_OE_WE_DEV & !LCR_COM1[7])
begin
if(ioaddr_dcdr[0] & O_DEVRDY & !I_OE_WE_DEV & !LCR_COM1[7])
strb_tx_en <= 1;
else
if(fifo_tx_empty & tx_shift_empty | !_I_RESET)
strb_tx_en <= 0;
end

/*always@(posedge I_CLK_DEV) 
begin
parity_error[1] <= parity_error[0];
framing_error[1] <= framing_error[0];
end*/

always@(posedge I_CLK_DEV) //С‡Р°СЃС‚РѕС‚Р° РєСЂР°С‚РЅР°СЏ РёР»Рё Р±РѕР»СЊС€Р°СЏ 115200 РІ 3-4 СЂР°Р·Р° РґР»СЏ РѕС‚СЃР»РµР¶РёРІР°РЅРёСЏ
begin											//РґР°РЅРЅС‹С… РЅР° Р»РёРЅРёРё RX 
rx_in[0] <= I_RX;
rx_in[1] <= rx_in[0];
end
//С„СЂРѕРЅС‚С‹
//assign parity_error_rising_edge = ~parity_error[1] & parity_error[0];
//assign framing_error_rising_edge = ~framing_error[1] & framing_error[0];

assign rx_edge = rx_in[0] ^ rx_in[1]; //РІСЃРµ С„СЂРѕРЅС‚С‹ РґРѕР»Р¶РЅС‹ РїРѕСЏРІР»СЏС‚СЊСЃСЏ РїРѕ СЃРёРіРЅР°Р»Сѓ 221184 РєР“С† 
															//РёР»Рё СЃРёРіРЅР°Р»Сѓ, Р±РѕР»СЊС€РµРјСѓ С‡РµРј 115200 РёР»Рё 1500000 РІ СЂР°Р·Р° 3-4
//assign CTS_COM1_changed = CTS_COM1[1] ^ CTS_COM1[0];
//assign DSR_COM1_changed = DSR_COM1[1] ^ DSR_COM1[0];
//assign RI_COM1_changed = RI_COM1[1] ^ RI_COM1[0];
//assign DCD_COM1_changed = DCD_COM1[1] ^ DCD_COM1[0];

assign RTS = !MCR_COM1[1];
assign DTR = !MCR_COM1[0];

always@(posedge I_CLK_BUS or negedge _I_RESET)
begin
if(!_I_RESET)
begin
O_AD <= 32'h00;
end
else
begin
case({LCR_COM1[7],I_DEVSEL,I_ADDR[2:0]})
5'h18: O_AD <= {DLL_COM1,DLL_COM1,DLL_COM1,DLL_COM1};
5'h08: O_AD <= {RBR_COM1,RBR_COM1,RBR_COM1,RBR_COM1}; 
5'h19: O_AD <= {DLM_COM1,DLM_COM1,DLM_COM1,DLM_COM1};
5'h09: O_AD <= {IER_COM1,IER_COM1,IER_COM1,IER_COM1};
5'h0A: O_AD <= {IIR_COM1,IIR_COM1,IIR_COM1,IIR_COM1};
5'h0B: O_AD <= {LCR_COM1,LCR_COM1,LCR_COM1,LCR_COM1};
5'h0C: O_AD <= {MCR_COM1,MCR_COM1,MCR_COM1,MCR_COM1};
5'h0D: O_AD <= {LSR_COM1,LSR_COM1,LSR_COM1,LSR_COM1};
5'h0E: O_AD <= {MSR_COM1,MSR_COM1,MSR_COM1,MSR_COM1};
5'h0F: O_AD <= {SCR_COM1,SCR_COM1,SCR_COM1,SCR_COM1};
5'h1A: O_AD <= {IIR_COM1,IIR_COM1,IIR_COM1,IIR_COM1};
5'h1B: O_AD <= {LCR_COM1,LCR_COM1,LCR_COM1,LCR_COM1};
5'h1C: O_AD <= {MCR_COM1,MCR_COM1,MCR_COM1,MCR_COM1};
5'h1D: O_AD <= {LSR_COM1,LSR_COM1,LSR_COM1,LSR_COM1};
5'h1E: O_AD <= {MSR_COM1,MSR_COM1,MSR_COM1,MSR_COM1};
5'h1F: O_AD <= {SCR_COM1,SCR_COM1,SCR_COM1,SCR_COM1};
default:
O_AD <= 32'h00;
endcase
end
end

always@*
begin
case(I_ADDR[2:0])
3'h0: ioaddr_dcdr = 8'h01;
3'h1: ioaddr_dcdr = 8'h02;
3'h2: ioaddr_dcdr = 8'h04;
3'h3: ioaddr_dcdr = 8'h08;
3'h4: ioaddr_dcdr = 8'h10;
3'h5: ioaddr_dcdr = 8'h20;
3'h6: ioaddr_dcdr = 8'h40;
3'h7: ioaddr_dcdr = 8'h80;
default:
ioaddr_dcdr = 8'h00;
endcase
end

assign tx_shift_empty = TSR_COM1[11:1] == 11'h0;

assign O_TX = TSR_COM1[0];

always@(posedge I_CLK_DEV or negedge rx_in[1]) ///РѕРїРѕСЂРЅР°СЏ С‡Р°СЃС‚РѕС‚Р° РёР»Рё РґСЂСѓРіР°СЏ Р»СЋР±Р°СЏ Р±РѕР»СЊС€Р°СЏ РІ 3-4 СЂР°Р·Р°, 
begin																//РєСЂР°С‚РЅР°СЏ 115200 Рё РЅРµ РјРµРЅРµРµ 230400
if(!rx_in[1])
rx_shift_en <= 1;
else
if(rx_done & strb_rx | !_I_RESET)
rx_shift_en <= 0;
end

always@*
begin
case(LCR_COM1[3:0])
4'b0000: rx_done = !RSR_COM1[4];
4'b0001: rx_done = !RSR_COM1[3]; 
4'b0010: rx_done = !RSR_COM1[2];
4'b0011: rx_done = !RSR_COM1[1];
4'b0100: rx_done = !RSR_COM1[4];
4'b0101: rx_done = !RSR_COM1[3]; 
4'b0110: rx_done = !RSR_COM1[2];
4'b0111: rx_done = !RSR_COM1[1];
4'b1000: rx_done = !RSR_COM1[3];
4'b1001: rx_done = !RSR_COM1[2];
4'b1010: rx_done = !RSR_COM1[1];
4'b1011: rx_done = !RSR_COM1[0];
4'b1100: rx_done = !RSR_COM1[3];
4'b1101: rx_done = !RSR_COM1[2];
4'b1110: rx_done = !RSR_COM1[1];
4'b1111: rx_done = !RSR_COM1[0];   
endcase
end

always@*
begin
case(FCR_COM1[7:6])
2'b00: fifo_rx_itrig = 4'h1;
2'b01: fifo_rx_itrig = 4'h4;
2'b10: fifo_rx_itrig = 4'h8;
2'b11: fifo_rx_itrig = 4'hE;
endcase
end

////////////////////////////////////////////////////////
///////////////////BEGIN RSR/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge I_CLK_DEV or negedge _I_RESET)
begin
if(!_I_RESET)
RSR_COM1 <= 11'h7FF;
else
if(strb_rx & rx_shift_en)
begin
if(rx_done)
RSR_COM1 <= {rx_in[1],10'h3FF};
else
RSR_COM1 <= {rx_in[1],RSR_COM1[10:1]};
end
end



always@(posedge I_CLK_DEV or negedge _I_RESET)
begin
if(!_I_RESET)
begin
fifo_rx_waddr <= 0;
end
else
begin
if(rx_done & strb_rx)
begin
case(LCR_COM1[3:0])
4'b0000: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:5];
4'b0001: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:4]; 
4'b0010: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:3];
4'b0011: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:2];
4'b0100: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:5];
4'b0101: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:4]; 
4'b0110: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:3];
4'b0111: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[9:2];
4'b1000: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:4];
4'b1001: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:3];
4'b1010: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:2];
4'b1011: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:1];
4'b1100: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:4];
4'b1101: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:3];
4'b1110: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:2];
4'b1111: FIFO_RX_COM1[fifo_rx_waddr] <= RSR_COM1[8:1];   
endcase
fifo_rx_waddr <= fifo_rx_waddr + 1;
/*case(LCR_COM1[5:0])
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
endcase*/
end
end
end

////////////////////////////////////////////////////////
///////////////////END RSR/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge I_CLK_BUS or negedge _I_RESET)
begin
if(!_I_RESET)
RBR_COM1 <= 8'hFF;
else
RBR_COM1 <= FIFO_RX_COM1[fifo_rx_raddr];
end

always@(posedge I_CLK_BUS or negedge _I_RESET)
begin
if(!_I_RESET)
THR_COM1 <= 0;
else
THR_COM1 <= FIFO_TX_COM1[fifo_tx_raddr]; 
end

////////////////////////////////////////////////////////
///////////////////BEGIN CLOCKS/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge I_CLK_DEV or negedge _I_RESET)
begin
if(!_I_RESET) 
strb_tx <= 0;
else
strb_tx <= strb_cntr_tx == {DLM_COM1,DLL_COM1,2'h0};
end

always@(posedge I_CLK_DEV or posedge rx_edge)
begin
if(rx_edge)
strb_rx <= 0;
else
strb_rx <= strb_cntr_rx == {DLM_COM1,DLL_COM1,1'h0};
end

always@(posedge I_CLK_DEV or negedge _I_RESET)
begin
if(!_I_RESET)
strb_cntr_tx <= 18'h1;
else
if(strb_cntr_tx == {DLM_COM1,DLL_COM1,2'h0} | !strb_tx_en)
strb_cntr_tx <= 18'h1;
else
strb_cntr_tx <= strb_cntr_tx + 1;
end

always@(posedge I_CLK_DEV or posedge rx_edge)
begin
if(rx_edge)
strb_cntr_rx <= 18'h1; 
else
if(strb_cntr_rx == {3'h0,DLM_COM1,DLL_COM1,2'h0} | !strb_rx_en)
strb_cntr_rx <= 18'h1; 
else
strb_cntr_rx <= strb_cntr_rx + 1;
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

always@(posedge I_CLK_DEV or negedge _I_RESET)
begin
if(!_I_RESET)
begin
TSR_COM1 <= 12'h01;
fifo_tx_raddr <= 0;
end
else
begin
if(strb_tx)
begin
if(!fifo_tx_empty & tx_shift_empty)
begin 
fifo_tx_raddr <= fifo_tx_raddr + 1; 
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
endcase
end
else
begin
TSR_COM1 <= {1'b0,TSR_COM1[11:1]};
end
end
end
end

////////////////////////////////////////////////////////
///////////////////END TSR/////////////////////////////////
/////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
///////////////////BEGIN INTERRUPTS/////////////////////////////////
/////////////////////////////////////////////////////////

assign is_dev_init = MCR_COM1[3];

assign O_INTX = !(is_dev_init & (((par_err_iflag | frame_err_iflag) & IER_COM1[2]) | (fifo_rx_timeout_iflag & IER_COM1[0]) | 
(fifo_rx_int_trig_iflag & IER_COM1[0]) | 
((ier_1_iflag | fifo_tx_empty_iflag) & IER_COM1[1]) | ((CTS_COM1_changed_int_flag 
| DSR_COM1_changed_int_flag | RI_COM1_changed_int_flag |
DCD_COM1_changed_int_flag)) & IER_COM1[3]));

/*always@(posedge I_CLK_DEV or posedge (com_state == COMF_LSR_READ & is_COM_iospace))
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
end*/

always@(posedge I_CLK_DEV or posedge ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7])
begin
if(ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7])
begin
rx_timeout_cntr <= 0;
end
else
begin
if(strb_rx)
if(!rx_shift_en & fifo_rx_itrig_cntr != fifo_rx_itrig)
rx_timeout_cntr <= rx_timeout_cntr + 1;
else
rx_timeout_cntr <= 0;
end
end

always@(posedge I_CLK_DEV or posedge ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7])
begin
if(ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7])
begin
fifo_rx_timeout_iflag <= 0;
end
else
begin
if(rx_timeout_cntr[4] & rx_timeout_cntr[5])
fifo_rx_timeout_iflag <= 1;  ///РР—-Р—Рђ Р­РўРћР“Рћ Р‘РћР›Р¬РЁР• Р›Р­ Р—РђРќРРњРђР•Рў !!!
end
end

always@(posedge I_CLK_DEV or posedge ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7]) ///РѕРїРѕСЂРЅР°СЏ С‡Р°СЃС‚РѕС‚Р° РёР»Рё РґСЂСѓРіР°СЏ Р»СЋР±Р°СЏ Р±РѕР»СЊС€Р°СЏ РєСЂР°С‚РЅР°СЏ 115200 РґР»СЏ С‚СЂРёРіРіРµСЂР°
begin                             //С‚Р°Рє РєР°Рє RSR_COM1_counter РѕС‚ СЌС‚РѕР№ С‡Р°СЃС‚РѕС‚С‹ СЂР°Р±РѕС‚Р°РµС‚, РїРѕСЌС‚РѕРјСѓ РЅРµ РјРµРЅСЏС‚СЊ !
if(ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7])
fifo_rx_itrig_cntr <= 0;
else
if(rx_done & strb_rx)
fifo_rx_itrig_cntr <= fifo_rx_itrig_cntr + 1;
end

always@(posedge I_CLK_DEV or posedge ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7]) 
begin   ///РѕРїРѕСЂРЅР°СЏ С‡Р°СЃС‚РѕС‚Р° РёР»Рё РґСЂСѓРіР°СЏ Р»СЋР±Р°СЏ Р±РѕР»СЊС€Р°СЏ РєСЂР°С‚РЅР°СЏ 115200 РґР»СЏ С‚СЂРёРіРіРµСЂР°
if(ioaddr_dcdr[0] & I_DEVSEL & I_OE_WE_DEV & !LCR_COM1[7])
fifo_rx_int_trig_iflag <= 0;
else
begin
if(fifo_rx_itrig_cntr == fifo_rx_itrig)
fifo_rx_int_trig_iflag <= 1; 
end
end

/*always@(posedge baudclk_96000kHz or posedge (com_state == COMF_MSR_READ & is_COM_iospace))
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
end*/

always@(posedge fifo_tx_empty or posedge (ioaddr_dcdr[2] | (ioaddr_dcdr[0] & !LCR_COM1[7])) & I_DEVSEL & I_OE_WE_DEV)
begin
if((ioaddr_dcdr[2] | (ioaddr_dcdr[0] & !LCR_COM1[7])) & I_DEVSEL & I_OE_WE_DEV)
fifo_tx_empty_iflag <= 0;//irdy - С‡С‚РѕР±С‹ IIR РЅРµ РёР·РјРµРЅСЏР»СЃСЏ РїРѕ С…РѕРґСѓ РµРіРѕ С‡С‚РµРЅРёСЏ, С‚Рѕ РµСЃС‚СЊ СЃР±СЂРѕСЃ РїСЂРµСЂС‹РІР°РЅРёСЏ
else										//РїРѕСЃР»Рµ С‡С‚РµРЅРёСЏ IIR
begin
//if(fifo_tx_empty)
fifo_tx_empty_iflag <= 1;
end
end

always@(posedge IER_COM1[1] or posedge (ioaddr_dcdr[2] | (ioaddr_dcdr[0] & !LCR_COM1[7])) & I_DEVSEL & I_OE_WE_DEV)
begin
if((ioaddr_dcdr[2] | (ioaddr_dcdr[0] & !LCR_COM1[7])) & I_DEVSEL & I_OE_WE_DEV)
ier_1_iflag <= 0; //irdy - С‡С‚РѕР±С‹ IIR РЅРµ РёР·РјРµРЅСЏР»СЃСЏ РїРѕ С…РѕРґСѓ РµРіРѕ С‡С‚РµРЅРёСЏ, С‚Рѕ РµСЃС‚СЊ СЃР±СЂРѕСЃ РїСЂРµСЂС‹РІР°РЅРёСЏ
else												//РїРѕСЃР»Рµ С‡С‚РµРЅРёСЏ IIR
begin
//if(ier_1_posedge)
ier_1_iflag <= 1;
end
end

////////////////////////////////////////////////////////
///////////////////END INTERRUPTS/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge I_CLK_BUS)
begin
if(ioaddr_dcdr[0] & O_DEVRDY & !I_OE_WE_DEV & !LCR_COM1[7])
FIFO_TX_COM1[fifo_tx_waddr] <= adnbyte; 
end

////////////////////////////////////////////////////////
///////////////////BEGIN COM1 REGISTERS/////////////////////////////////
/////////////////////////////////////////////////////////
assign COM1_RESET = (_I_RESET | !IER_COM1[7]);

always@(posedge I_CLK_BUS or negedge _I_RESET)
begin
if(!_I_RESET)
begin
IIR_COM1 <= 8'h01;
end
else
begin
IIR_COM1[6] <= FCR_COM1[0];
IIR_COM1[7] <= FCR_COM1[0];
if((par_err_iflag | frame_err_iflag) & IER_COM1[2])
begin
IIR_COM1[3:0] <= 4'h6;
end
else if(fifo_rx_timeout_iflag & IER_COM1[0])
begin
IIR_COM1[3:0] <= 4'hC;
end
else if(fifo_rx_int_trig_iflag & IER_COM1[0])
begin
IIR_COM1[3:0] <= 4'h4;
end
else if((ier_1_iflag | fifo_tx_empty_iflag) & IER_COM1[1])
begin
IIR_COM1[3:0] <= 4'h2;
end
else if((CTS_COM1_changed_int_flag |
DSR_COM1_changed_int_flag |
RI_COM1_changed_int_flag |
DCD_COM1_changed_int_flag) & IER_COM1[3])
begin
IIR_COM1[3:0] <=  4'h0;
end
else
begin
IIR_COM1[3:0] <=  4'h1;
end
end
end

always@(posedge I_CLK_BUS or negedge _I_RESET/*COM1_RESET*/)
begin
if(!_I_RESET/*COM1_RESET*/)
begin
IER_COM1 <= 8'h00;
LCR_COM1 <= 8'h00;
MCR_COM1 <= 8'h00;
LSR_COM1 <= 8'h60;
SCR_COM1 <= 8'h00;
DLL_COM1 <= 8'h60;
DLM_COM1 <= 8'h80;
FCR_COM1 <= 8'hC1;
fifo_tx_waddr <= 0;
fifo_rx_raddr <= 0;
end
else
begin
if(ioaddr_dcdr[0] & O_DEVRDY & !I_OE_WE_DEV & LCR_COM1[7])
DLL_COM1 <= adnbyte;
if(ioaddr_dcdr[1] & O_DEVRDY & !I_OE_WE_DEV & LCR_COM1[7])
DLM_COM1 <= adnbyte;
if(ioaddr_dcdr[1] & O_DEVRDY & !I_OE_WE_DEV & !LCR_COM1[7])
IER_COM1 <= adnbyte;
if(ioaddr_dcdr[3]  & O_DEVRDY & !I_OE_WE_DEV)
LCR_COM1 <= adnbyte;
if(ioaddr_dcdr[4]  & O_DEVRDY & !I_OE_WE_DEV)
MCR_COM1 <= adnbyte;
if(ioaddr_dcdr[5]  & O_DEVRDY & !I_OE_WE_DEV)
LSR_COM1 <= adnbyte;
if(ioaddr_dcdr[7] & O_DEVRDY & !I_OE_WE_DEV)
SCR_COM1 <= adnbyte;
//if(ioaddr_dcdr[4] & I_DEVSEL & !I_OE_WE_DEV) //РѕСЃС‚Р°РІРёС‚СЊ - РјРѕР¶РЅРѕ Р±СѓРґРµС‚ СѓР±РёСЂР°С‚СЊ СЂРµР¶РёРј FIFO
//FCR_COM1 <= adnbyte;

if(ioaddr_dcdr[0] & O_DEVRDY & !I_OE_WE_DEV & !LCR_COM1[7])
fifo_tx_waddr <= fifo_tx_waddr + 1;
if(ioaddr_dcdr[0] & O_DEVRDY & I_OE_WE_DEV & !fifo_rx_empty & !LCR_COM1[7])
fifo_rx_raddr <= fifo_rx_raddr + 1;

LSR_COM1[0] <= !fifo_rx_empty;
LSR_COM1[1] <= 0;
LSR_COM1[2] <= par_err[0];
LSR_COM1[3] <= frame_err[0];
LSR_COM1[4] <= 0;
LSR_COM1[5] <= fifo_tx_empty; 
LSR_COM1[6] <= fifo_tx_empty & tx_shift_empty; 
LSR_COM1[7] <= !fifo_tx_empty & (par_err[0] | frame_err[0]);

if(FCR_COM1[2])
begin
fifo_tx_waddr <= fifo_tx_raddr;
fifo_rx_raddr <= fifo_rx_waddr;
end

end
end


////////////////////////////////////////////////////////
///////////////////END COM1 REGISTERS/////////////////////////////////
/////////////////////////////////////////////////////////


endmodule 