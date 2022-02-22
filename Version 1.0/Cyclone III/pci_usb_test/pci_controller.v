  module PCI_target_controller(
input wire clk,
inout [31:0] addr_data,
input [3:0] cbe,
input wire idsel,
input wire frame, 
input wire irdy, 
inout device_ready, 
input wire reset, 
output par,
output wire [7:0]  in_addr_offset_w_io,
output reg [31:0] out_add_data_cs,
output reg [3:0] in_command,
output reg [7:0] addr_data_buf_in_byte,
output reg [16:0] addr_data_buf_in_word,
output reg [32:0] addr_data_buf_in_dword,
output wire BAR0_DEVICE0_configured,
output wire BAR1_DEVICE0_configured,
output wire BAR2_DEVICE0_configured,
output wire BAR3_DEVICE0_configured,
output wire BAR4_DEVICE0_configured,
output wire BAR5_DEVICE0_configured,
output wire BAR0_DEVICE1_configured,
output wire BAR1_DEVICE1_configured,
output wire BAR2_DEVICE1_configured,
output wire BAR3_DEVICE1_configured,
output wire BAR4_DEVICE1_configured,
output wire BAR5_DEVICE1_configured,
output wire BAR0_DEVICE2_configured,
output wire BAR1_DEVICE2_configured,
output wire BAR2_DEVICE2_configured,
output wire BAR3_DEVICE2_configured,
output wire BAR4_DEVICE2_configured,
output wire BAR5_DEVICE2_configured,
output wire BAR0_DEVICE3_configured,
output wire BAR1_DEVICE3_configured,
output wire BAR2_DEVICE3_configured,
output wire BAR3_DEVICE3_configured,
output wire BAR4_DEVICE3_configured,
output wire BAR5_DEVICE3_configured,
output reg control,
output reg is_config_space,
output reg is_BAR0_DEVICE0_address,
output reg is_BAR1_DEVICE0_address,
output reg is_BAR2_DEVICE0_address,
output reg is_BAR3_DEVICE0_address,
output reg is_BAR4_DEVICE0_address,
output reg is_BAR5_DEVICE0_address,
output reg is_BAR0_DEVICE1_address,
output reg is_BAR1_DEVICE1_address,
output reg is_BAR2_DEVICE1_address,
output reg is_BAR3_DEVICE1_address,
output reg is_BAR4_DEVICE1_address,
output reg is_BAR5_DEVICE1_address,
output reg is_BAR0_DEVICE2_address,
output reg is_BAR1_DEVICE2_address,
output reg is_BAR2_DEVICE2_address,
output reg is_BAR3_DEVICE2_address,
output reg is_BAR4_DEVICE2_address,
output reg is_BAR5_DEVICE2_address,
output reg is_BAR0_DEVICE3_address,
output reg is_BAR1_DEVICE3_address,
output reg is_BAR2_DEVICE3_address,
output reg is_BAR3_DEVICE3_address,
output reg is_BAR4_DEVICE3_address,
output reg is_BAR5_DEVICE3_address
);

reg [31:0] BASE_ADDRESS_0_DEVICE0;
reg [31:0] BASE_ADDRESS_1_DEVICE0;
reg [31:0] BASE_ADDRESS_2_DEVICE0;
reg [31:0] BASE_ADDRESS_3_DEVICE0;
reg [31:0] BASE_ADDRESS_4_DEVICE0;
reg [31:0] BASE_ADDRESS_5_DEVICE0;
reg [31:0] COMMAND_STATUS_DEVICE0;  
reg [31:0] INTERUPT_PIN_LINE_DEVICE0; 

reg [31:0] BASE_ADDRESS_0_DEVICE1;
reg [31:0] BASE_ADDRESS_1_DEVICE1;
reg [31:0] BASE_ADDRESS_2_DEVICE1;
reg [31:0] BASE_ADDRESS_3_DEVICE1;
reg [31:0] BASE_ADDRESS_4_DEVICE1;
reg [31:0] BASE_ADDRESS_5_DEVICE1;
reg [31:0] COMMAND_STATUS_DEVICE1;  
reg [31:0] INTERUPT_PIN_LINE_DEVICE1; 

reg [31:0] BASE_ADDRESS_0_DEVICE2;
reg [31:0] BASE_ADDRESS_1_DEVICE2;
reg [31:0] BASE_ADDRESS_2_DEVICE2;
reg [31:0] BASE_ADDRESS_3_DEVICE2;
reg [31:0] BASE_ADDRESS_4_DEVICE2;
reg [31:0] BASE_ADDRESS_5_DEVICE2;
reg [31:0] COMMAND_STATUS_DEVICE2;  
reg [31:0] INTERUPT_PIN_LINE_DEVICE2; 

reg [31:0] BASE_ADDRESS_0_DEVICE3;
reg [31:0] BASE_ADDRESS_1_DEVICE3;
reg [31:0] BASE_ADDRESS_2_DEVICE3;
reg [31:0] BASE_ADDRESS_3_DEVICE3;
reg [31:0] BASE_ADDRESS_4_DEVICE3;
reg [31:0] BASE_ADDRESS_5_DEVICE3;
reg [31:0] COMMAND_STATUS_DEVICE3;  
reg [31:0] INTERUPT_PIN_LINE_DEVICE3; 

parameter CS_RESET = 0; 
parameter CS_IDLE = 1; 

parameter CS_READ = 2;//parameter CS_VIDPID_READ_USB = 2;
parameter CS_VIDPID_WRITE_DEVICE0 = 18;
parameter CS_STATUSCOMMAND_WRITE_DEVICE0 = 19;
parameter CS_CLASSCODE_WRITE_DEVICE0 = 20;
parameter CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE0 = 21;
parameter CS_BAR0_WRITE_DEVICE0 = 22; 
parameter CS_BAR1_WRITE_DEVICE0 = 23;
parameter CS_BAR2_WRITE_DEVICE0 = 24;
parameter CS_BAR3_WRITE_DEVICE0 = 25;
parameter CS_BAR4_WRITE_DEVICE0 = 26;
parameter CS_BAR5_WRITE_DEVICE0 = 27;
parameter CS_CARDBUS_WRITE_DEVICE0 = 28;
parameter CS_SUBSYSTEM_VENDOR_WRITE_DEVICE0 = 29;
parameter CS_EXPANSION_ROM_BAR_WRITE_DEVICE0 = 30;
parameter CS_CAP_POINTER_WRITE_DEVICE0 = 31;
parameter CS_LAT_INTERRUPT_WRITE_DEVICE0 = 32;

/*parameter CS_VIDPID_READ_DEVICE1 = 35;
parameter CS_STATUSCOMMAND_READ_DEVICE1 = 36;
parameter CS_CLASSCODE_READ_DEVICE1 = 37;
parameter CS_BIST_HEADER_LAT_CACH_READ_DEVICE1 = 38;
parameter CS_BAR0_READ_DEVICE1 = 39; 
parameter CS_BAR1_READ_DEVICE1 = 40;
parameter CS_BAR2_READ_DEVICE1 = 41;
parameter CS_BAR3_READ_DEVICE1 = 42;
parameter CS_BAR4_READ_DEVICE1 = 43;
parameter CS_BAR5_READ_DEVICE1 = 44;
parameter CS_CARDBUS_READ_DEVICE1 = 45;
parameter CS_SUBSYSTEM_VENDOR_READ_DEVICE1 = 46;
parameter CS_EXPANSION_ROM_BAR_READ_DEVICE1 = 47;
parameter CS_CAP_POINTER_READ_DEVICE1 = 48;
parameter CS_LAT_INTERRUPT_READ_DEVICE1 = 49;*/
parameter CS_VIDPID_WRITE_DEVICE1 = 50;
parameter CS_STATUSCOMMAND_WRITE_DEVICE1 = 51;
parameter CS_CLASSCODE_WRITE_DEVICE1 = 52;
parameter CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE1 = 53;
parameter CS_BAR0_WRITE_DEVICE1 = 54; 
parameter CS_BAR1_WRITE_DEVICE1 = 55;
parameter CS_BAR2_WRITE_DEVICE1 = 56;
parameter CS_BAR3_WRITE_DEVICE1 = 57;
parameter CS_BAR4_WRITE_DEVICE1 = 58;
parameter CS_BAR5_WRITE_DEVICE1 = 59;
parameter CS_CARDBUS_WRITE_DEVICE1 = 60;
parameter CS_SUBSYSTEM_VENDOR_WRITE_DEVICE1 = 61;
parameter CS_EXPANSION_ROM_BAR_WRITE_DEVICE1 = 62;
parameter CS_CAP_POINTER_WRITE_DEVICE1 = 63;
parameter CS_LAT_INTERRUPT_WRITE_DEVICE1 = 64;

/*parameter CS_VIDPID_READ_DEVICE1 = 65;
parameter CS_STATUSCOMMAND_READ_DEVICE1 = 66;
parameter CS_CLASSCODE_READ_DEVICE1 = 67;
parameter CS_BIST_HEADER_LAT_CACH_READ_DEVICE1 = 68;
parameter CS_BAR0_READ_DEVICE1 = 69; 
parameter CS_BAR1_READ_DEVICE1 = 70;
parameter CS_BAR2_READ_DEVICE1 = 71;
parameter CS_BAR3_READ_DEVICE1 = 72;
parameter CS_BAR4_READ_DEVICE1 = 73;
parameter CS_BAR5_READ_DEVICE1 = 74;
parameter CS_CARDBUS_READ_DEVICE1 = 75;
parameter CS_SUBSYSTEM_VENDOR_READ_DEVICE1 = 76;
parameter CS_EXPANSION_ROM_BAR_READ_DEVICE1 = 77;
parameter CS_CAP_POINTER_READ_DEVICE1 = 78;
parameter CS_LAT_INTERRUPT_READ_DEVICE1 = 79;
parameter CS_VIDPID_WRITE_DEVICE1 = 80;
parameter CS_STATUSCOMMAND_WRITE_DEVICE1 = 81;
parameter CS_CLASSCODE_WRITE_DEVICE1 = 82;
parameter CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE1 = 83;
parameter CS_BAR0_WRITE_DEVICE1 = 84; 
parameter CS_BAR1_WRITE_DEVICE1 = 85;
parameter CS_BAR2_WRITE_DEVICE1 = 86;
parameter CS_BAR3_WRITE_DEVICE1 = 87;
parameter CS_BAR4_WRITE_DEVICE1 = 88;
parameter CS_BAR5_WRITE_DEVICE1 = 89;
parameter CS_CARDBUS_WRITE_DEVICE1 = 90;
parameter CS_SUBSYSTEM_VENDOR_WRITE_DEVICE1 = 91;
parameter CS_EXPANSION_ROM_BAR_WRITE_DEVICE1 = 92;
parameter CS_CAP_POINTER_WRITE_DEVICE1 = 93;
parameter CS_LAT_INTERRUPT_WRITE_DEVICE1 = 94;*/

/*parameter CS_VIDPID_READ_DEVICE3 = 95;
parameter CS_STATUSCOMMAND_READ_DEVICE3 = 96;
parameter CS_CLASSCODE_READ_DEVICE3 = 97;
parameter CS_BIST_HEADER_LAT_CACH_READ_DEVICE3 = 98;
parameter CS_BAR0_READ_DEVICE3 = 99; 
parameter CS_BAR1_READ_DEVICE3 = 100;
parameter CS_BAR2_READ_DEVICE3 = 101;
parameter CS_BAR3_READ_DEVICE3 = 102;
parameter CS_BAR4_READ_DEVICE3 = 103;
parameter CS_BAR5_READ_DEVICE3 = 104;
parameter CS_CARDBUS_READ_DEVICE3 = 105;
parameter CS_SUBSYSTEM_VENDOR_READ_DEVICE3 = 106;
parameter CS_EXPANSION_ROM_BAR_READ_DEVICE3 = 107;
parameter CS_CAP_POINTER_READ_DEVICE3 = 108;
parameter CS_LAT_INTERRUPT_READ_DEVICE3 = 109;
parameter CS_VIDPID_WRITE_DEVICE3 = 110;
parameter CS_STATUSCOMMAND_WRITE_DEVICE3 = 111;
parameter CS_CLASSCODE_WRITE_DEVICE3 = 112;
parameter CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE3 = 113;
parameter CS_BAR0_WRITE_DEVICE3 = 114; 
parameter CS_BAR1_WRITE_DEVICE3 = 115;
parameter CS_BAR2_WRITE_DEVICE3 = 116;
parameter CS_BAR3_WRITE_DEVICE3 = 117;
parameter CS_BAR4_WRITE_DEVICE3 = 118;
parameter CS_BAR5_WRITE_DEVICE3 = 119;
parameter CS_CARDBUS_WRITE_DEVICE3 = 120;
parameter CS_SUBSYSTEM_VENDOR_WRITE_DEVICE3 = 121;
parameter CS_EXPANSION_ROM_BAR_WRITE_DEVICE3 = 122;
parameter CS_CAP_POINTER_WRITE_DEVICE3 = 123;
parameter CS_LAT_INTERRUPT_WRITE_DEVICE3 = 124;*/

parameter CS_NULL = 125;
parameter CS_RESERVED = 126;

parameter INT_PIN_DEVICE0 = 32'h0200;
parameter INT_PIN_DEVICE1 = 32'h0100;
parameter INT_PIN_DEVICE2 = 32'h0300;
parameter INT_PIN_DEVICE3 = 32'h0400;

parameter STATUS_MASK_DEVICE0 = 16'h0288;
parameter STATUS_MASK_DEVICE1 = 16'h0288;
parameter STATUS_MASK_DEVICE2 = 16'h0288;
parameter STATUS_MASK_DEVICE3 = 16'h0288;

parameter COMMAND_MASK_DEVICE0 = 16'h0003;
parameter COMMAND_MASK_DEVICE1 = 16'h0003;
parameter COMMAND_MASK_DEVICE2 = 16'h0003;
parameter COMMAND_MASK_DEVICE3 = 16'h0003;

parameter TRDY_DELAY = 0; //обновить схемный файл!!!

parameter MULTIFUNCTIONAL_DEVICE0 = 32'h800000;
parameter MULTIFUNCTIONAL_DEVICE1 = 32'h800000;
parameter MULTIFUNCTIONAL_DEVICE2 = 32'h800000;
parameter MULTIFUNCTIONAL_DEVICE3 = 32'h800000;

parameter VIDPID_DEVICE0 = 32'hDEADBEEF;
parameter CLASSCODE_DEVICE0 = 32'h0C030050;

parameter VIDPID_DEVICE1 = 32'h50534348;
parameter CLASSCODE_DEVICE1 = 32'h0700020F;

parameter VIDPID_DEVICE2 = 32'h00;
parameter CLASSCODE_DEVICE2 = 32'h00;

parameter VIDPID_DEVICE3 = 32'h00;
parameter CLASSCODE_DEVICE3 = 32'h00;

assign BAR0_DEVICE0_configured = (BASE_ADDRESS_0_DEVICE0 > 32'h1000 && BASE_ADDRESS_0_DEVICE0 < 32'hFFFF);
assign BAR1_DEVICE0_configured = (BASE_ADDRESS_1_DEVICE0 > 32'h1000 && BASE_ADDRESS_1_DEVICE0 < 32'hFFFF);
assign BAR2_DEVICE0_configured = (BASE_ADDRESS_2_DEVICE0 > 32'h1000 && BASE_ADDRESS_2_DEVICE0 < 32'hFFFF);
assign BAR3_DEVICE0_configured = (BASE_ADDRESS_3_DEVICE0 > 32'h1000 && BASE_ADDRESS_3_DEVICE0 < 32'hFFFF);

assign BAR0_DEVICE1_configured = (BASE_ADDRESS_0_DEVICE1 > 32'h1000 && BASE_ADDRESS_0_DEVICE1 < 32'hFFFF);
assign BAR1_DEVICE1_configured = (BASE_ADDRESS_1_DEVICE1 > 32'h1000 && BASE_ADDRESS_1_DEVICE1 < 32'hFFFF);
assign BAR2_DEVICE1_configured = (BASE_ADDRESS_2_DEVICE1 > 32'h1000 && BASE_ADDRESS_2_DEVICE1 < 32'hFFFF);
assign BAR3_DEVICE1_configured = (BASE_ADDRESS_3_DEVICE1 > 32'h1000 && BASE_ADDRESS_3_DEVICE1 < 32'hFFFF);

assign BAR0_DEVICE2_configured = (BASE_ADDRESS_0_DEVICE2 > 32'h1000 && BASE_ADDRESS_0_DEVICE2 < 32'hFFFF);
assign BAR1_DEVICE2_configured = (BASE_ADDRESS_1_DEVICE2 > 32'h1000 && BASE_ADDRESS_1_DEVICE2 < 32'hFFFF);
assign BAR2_DEVICE2_configured = (BASE_ADDRESS_2_DEVICE2 > 32'h1000 && BASE_ADDRESS_2_DEVICE2 < 32'hFFFF);
assign BAR3_DEVICE2_configured = (BASE_ADDRESS_3_DEVICE2 > 32'h1000 && BASE_ADDRESS_3_DEVICE2 < 32'hFFFF);

assign BAR0_DEVICE3_configured = (BASE_ADDRESS_0_DEVICE3 > 32'h1000 && BASE_ADDRESS_0_DEVICE3 < 32'hFFFF);
assign BAR1_DEVICE3_configured = (BASE_ADDRESS_1_DEVICE3 > 32'h1000 && BASE_ADDRESS_1_DEVICE3 < 32'hFFFF);
assign BAR2_DEVICE3_configured = (BASE_ADDRESS_2_DEVICE3 > 32'h1000 && BASE_ADDRESS_2_DEVICE3 < 32'hFFFF);
assign BAR3_DEVICE3_configured = (BASE_ADDRESS_3_DEVICE3 > 32'h1000 && BASE_ADDRESS_3_DEVICE3 < 32'hFFFF);

reg [31:0] in_adress; 

assign in_addr_offset_w_io = in_adress[7:0];
  
  reg [3:0] cbe_buf_in;
  
  wire [13:0] in_addr_w_cs;
  
  reg data_ready;
  
  reg [2:0] data_ready_delay_counter;
  
  reg [31:0] addr_data_buf_in; 
  
  //reg [31:0] addr_data_buf_in_trig; 
  
  reg [6:0] cs_state;  
  
  reg is_CS_DEVICE0;
  
  reg is_CS_DEVICE1;
  
  reg is_CS_DEVICE2;
  
  reg is_CS_DEVICE3;
  
  always@(posedge clk or negedge reset)
  begin
  if(!reset)
  begin
  is_CS_DEVICE0 <= 0;
  is_CS_DEVICE1 <= 0;
  is_CS_DEVICE2 <= 0;
  is_CS_DEVICE3 <= 0;
  end
  else
  begin
  is_CS_DEVICE0 <= (in_addr_w_cs[13:6] == 8'h00);
  is_CS_DEVICE1 <= (in_addr_w_cs[13:6] == 8'h01);
  is_CS_DEVICE2 <= (in_addr_w_cs[13:6] == 8'h02);  
  is_CS_DEVICE3 <= (in_addr_w_cs[13:6] == 8'h03);  
  end
  end
  
  always@*
  begin
  if(control)
  begin
  cbe_buf_in = cbe;
  addr_data_buf_in = addr_data;
  end
 else
  begin
  cbe_buf_in = 4'bz;
  addr_data_buf_in = 32'bz;
  end
  end

  assign in_addr_w_cs = in_adress[15:2];
  
  //assign trdy = (!devsel & data_ready) ? 1'b0 : 1'b1;
  assign device_ready = (((cs_state != CS_IDLE & cs_state != CS_RESET))) ? 1'b0 : 1'b1;
  assign par = 1'bz;
  
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

wire is_DEVICE;
assign is_DEVICE = is_CS_DEVICE0 | is_CS_DEVICE1 | is_CS_DEVICE2 | is_CS_DEVICE3;
 
 always@(posedge clk)
 begin
 control <= !(cs_state == CS_READ);
 end
 
 always@*
 begin
 case({(cs_state == CS_READ),in_addr_w_cs[7:0]})
9'h100: out_add_data_cs = VIDPID_DEVICE0;//32'h30381106;//32'hDEADBEEF; //98059710; 
9'h101: out_add_data_cs = COMMAND_STATUS_DEVICE0;
9'h102: out_add_data_cs = CLASSCODE_DEVICE0;
9'h103: out_add_data_cs = 32'h00002008 | MULTIFUNCTIONAL_DEVICE0;
9'h104: out_add_data_cs = BASE_ADDRESS_0_DEVICE0;
9'h105: out_add_data_cs = BASE_ADDRESS_1_DEVICE0;
9'h106: out_add_data_cs = BASE_ADDRESS_2_DEVICE0;
9'h107: out_add_data_cs = BASE_ADDRESS_3_DEVICE0;
9'h108: out_add_data_cs = BASE_ADDRESS_4_DEVICE0;
9'h109: out_add_data_cs = BASE_ADDRESS_5_DEVICE0;
9'h10B: out_add_data_cs = 32'h12340925; 
9'h10F: out_add_data_cs = INTERUPT_PIN_LINE_DEVICE0;
9'h140: out_add_data_cs = VIDPID_DEVICE1;//32'h50534348;//32'h98209710;//32'h22731C00;//32'h30381106;//32'hDEADBEEF; //98059710; 
9'h141: out_add_data_cs = COMMAND_STATUS_DEVICE1;
9'h142: out_add_data_cs = CLASSCODE_DEVICE1;
9'h143: out_add_data_cs = 32'h00 | MULTIFUNCTIONAL_DEVICE1;
9'h144: out_add_data_cs = BASE_ADDRESS_0_DEVICE1;
9'h145: out_add_data_cs = BASE_ADDRESS_1_DEVICE1;
9'h146: out_add_data_cs = BASE_ADDRESS_2_DEVICE1;
9'h147: out_add_data_cs = BASE_ADDRESS_3_DEVICE1;
9'h148: out_add_data_cs = BASE_ADDRESS_4_DEVICE1;
9'h149: out_add_data_cs = BASE_ADDRESS_5_DEVICE1;
9'h14B: out_add_data_cs = VIDPID_DEVICE1;//32'h50534348;//32'h00011000;//32'h22731C00; 
9'h14F: out_add_data_cs = INTERUPT_PIN_LINE_DEVICE1;
default:
out_add_data_cs = 32'h00;
endcase
end

always@(posedge clk or negedge reset)
begin
if(!reset)
begin
cs_state <= CS_RESET;
end
else
begin
case(cs_state)
CS_RESET:
begin
cs_state <= CS_IDLE;
end
CS_IDLE:
begin
if({is_DEVICE & !irdy & is_config_space,in_command} == 5'h1A)
cs_state <= CS_READ;
case({is_DEVICE & !irdy & is_config_space,in_command,in_addr_w_cs[7:0]})
13'h1B00: cs_state <= CS_VIDPID_WRITE_DEVICE0;
13'h1B01: cs_state <= CS_STATUSCOMMAND_WRITE_DEVICE0;
13'h1B02: cs_state <= CS_CLASSCODE_WRITE_DEVICE0;
13'h1B03: cs_state <= CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE0;
13'h1B04: cs_state <= CS_BAR0_WRITE_DEVICE0;
13'h1B05: cs_state <= CS_BAR1_WRITE_DEVICE0;
13'h1B06: cs_state <= CS_BAR2_WRITE_DEVICE0;
13'h1B07: cs_state <= CS_BAR3_WRITE_DEVICE0;
13'h1B08: cs_state <= CS_BAR4_WRITE_DEVICE0;
13'h1B09: cs_state <= CS_BAR5_WRITE_DEVICE0;
13'h1B0A: cs_state <= CS_CARDBUS_WRITE_DEVICE0;
13'h1B0B: cs_state <= CS_SUBSYSTEM_VENDOR_WRITE_DEVICE0;
13'h1B0C: cs_state <= CS_EXPANSION_ROM_BAR_WRITE_DEVICE0;
13'h1B0D: cs_state <= CS_CAP_POINTER_WRITE_DEVICE0;
13'h1B0E: cs_state <= CS_RESERVED;
13'h1B0F: cs_state <= CS_LAT_INTERRUPT_WRITE_DEVICE0;

13'h1B40: cs_state <= CS_VIDPID_WRITE_DEVICE1;
13'h1B41: cs_state <= CS_STATUSCOMMAND_WRITE_DEVICE1;
13'h1B42: cs_state <= CS_CLASSCODE_WRITE_DEVICE1;
13'h1B43: cs_state <= CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE1;
13'h1B44: cs_state <= CS_BAR0_WRITE_DEVICE1;
13'h1B45: cs_state <= CS_BAR1_WRITE_DEVICE1;
13'h1B46: cs_state <= CS_BAR2_WRITE_DEVICE1;
13'h1B47: cs_state <= CS_BAR3_WRITE_DEVICE1;
13'h1B48: cs_state <= CS_BAR4_WRITE_DEVICE1;
13'h1B49: cs_state <= CS_BAR5_WRITE_DEVICE1;
13'h1B4A: cs_state <= CS_CARDBUS_WRITE_DEVICE1;
13'h1B4B: cs_state <= CS_SUBSYSTEM_VENDOR_WRITE_DEVICE1;
13'h1B4C: cs_state <= CS_EXPANSION_ROM_BAR_WRITE_DEVICE1;
13'h1B8D: cs_state <= CS_CAP_POINTER_WRITE_DEVICE1;
13'h1B4E: cs_state <= CS_RESERVED;
13'h1B4F: cs_state <= CS_LAT_INTERRUPT_WRITE_DEVICE1;
endcase
end
CS_READ:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_RESERVED:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_VIDPID_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_STATUSCOMMAND_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_CLASSCODE_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR0_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR1_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR2_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR3_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR4_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR5_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_CARDBUS_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_SUBSYSTEM_VENDOR_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_EXPANSION_ROM_BAR_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_CAP_POINTER_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_LAT_INTERRUPT_WRITE_DEVICE0:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_VIDPID_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_STATUSCOMMAND_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_CLASSCODE_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BIST_HEADER_LAT_CACH_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR0_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR1_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR2_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR3_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR4_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_BAR5_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_CARDBUS_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_SUBSYSTEM_VENDOR_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_EXPANSION_ROM_BAR_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_CAP_POINTER_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_LAT_INTERRUPT_WRITE_DEVICE1:
begin
if(irdy)
cs_state <= CS_IDLE;
end
CS_NULL:
begin
if(irdy)
cs_state <= CS_IDLE;
end
default:
cs_state <= CS_IDLE;
endcase
end
end

//ADDRESS LATCH
always@(posedge clk or negedge reset)
begin
if(!reset)
begin
in_command <= 0;
in_adress <= 0;
is_config_space <= 0;
end
else
begin
if(!frame)
begin
in_command <= cbe_buf_in;
is_config_space <= idsel;
in_adress <= addr_data_buf_in;
is_BAR0_DEVICE0_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_0_DEVICE0[31:8];
is_BAR1_DEVICE0_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_1_DEVICE0[31:8];
is_BAR2_DEVICE0_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_2_DEVICE0[31:8];
is_BAR3_DEVICE0_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_3_DEVICE0[31:8];
is_BAR4_DEVICE0_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_4_DEVICE0[31:8];
is_BAR5_DEVICE0_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_5_DEVICE0[31:8];

is_BAR0_DEVICE1_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_0_DEVICE1[31:8];
is_BAR1_DEVICE1_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_1_DEVICE1[31:8];
is_BAR2_DEVICE1_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_2_DEVICE1[31:8];
is_BAR3_DEVICE1_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_3_DEVICE1[31:8];
is_BAR4_DEVICE1_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_4_DEVICE1[31:8];
is_BAR5_DEVICE1_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_5_DEVICE1[31:8];

is_BAR0_DEVICE2_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_0_DEVICE2[31:8];
is_BAR1_DEVICE2_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_1_DEVICE2[31:8];
is_BAR2_DEVICE2_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_2_DEVICE2[31:8];
is_BAR3_DEVICE2_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_3_DEVICE2[31:8];
is_BAR4_DEVICE2_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_4_DEVICE2[31:8];
is_BAR5_DEVICE2_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_5_DEVICE2[31:8];

is_BAR0_DEVICE3_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_0_DEVICE3[31:8];
is_BAR1_DEVICE3_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_1_DEVICE3[31:8];
is_BAR2_DEVICE3_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_2_DEVICE3[31:8];
is_BAR3_DEVICE3_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_3_DEVICE3[31:8];
is_BAR4_DEVICE3_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_4_DEVICE3[31:8];
is_BAR5_DEVICE3_address <= addr_data_buf_in[31:8] == BASE_ADDRESS_5_DEVICE3[31:8];
end
end
end

always@*
begin
case(cbe_buf_in)
4'b1110: addr_data_buf_in_byte = addr_data_buf_in[7:0];
4'b1101: addr_data_buf_in_byte = addr_data_buf_in[15:8];
4'b1011: addr_data_buf_in_byte = addr_data_buf_in[23:16];
4'b0111: addr_data_buf_in_byte = addr_data_buf_in[31:24];
default:
addr_data_buf_in_byte <= addr_data_buf_in[7:0];
endcase
end

////////////////////////////////////////////////////////
///////////////////BEGIN BARS/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge clk or negedge reset)
begin
if(!reset)
begin
//out_add_data <= 0;
BASE_ADDRESS_0_DEVICE0 <= 32'h00;
BASE_ADDRESS_1_DEVICE0 <= 32'h00;
BASE_ADDRESS_2_DEVICE0 <= 32'h00;
BASE_ADDRESS_3_DEVICE0 <= 32'h00;
BASE_ADDRESS_4_DEVICE0 <= 32'h00;
BASE_ADDRESS_5_DEVICE0 <= 32'h00;
BASE_ADDRESS_0_DEVICE1 <= 32'h00;
BASE_ADDRESS_1_DEVICE1 <= 32'h00;
BASE_ADDRESS_2_DEVICE1 <= 32'h00;
BASE_ADDRESS_3_DEVICE1 <= 32'h00;
BASE_ADDRESS_4_DEVICE1 <= 32'h00;
BASE_ADDRESS_5_DEVICE1 <= 32'h00;
COMMAND_STATUS_DEVICE0 <= 0;
COMMAND_STATUS_DEVICE1 <= 0;
INTERUPT_PIN_LINE_DEVICE0 <= 8'h00;
INTERUPT_PIN_LINE_DEVICE1 <= 8'h00;
end
else
begin
if(cs_state == CS_STATUSCOMMAND_WRITE_DEVICE0)
COMMAND_STATUS_DEVICE0 <= {addr_data_buf_in[31:16] & STATUS_MASK_DEVICE0, addr_data_buf_in[15:0] & COMMAND_MASK_DEVICE0};
if(cs_state == CS_STATUSCOMMAND_WRITE_DEVICE1)
COMMAND_STATUS_DEVICE1 <= {addr_data_buf_in[31:16] & STATUS_MASK_DEVICE1, addr_data_buf_in[15:0] & COMMAND_MASK_DEVICE1};
if(cs_state == CS_LAT_INTERRUPT_WRITE_DEVICE0)
INTERUPT_PIN_LINE_DEVICE0 <= addr_data_buf_in[7:0] | INT_PIN_DEVICE0;
if(cs_state == CS_LAT_INTERRUPT_WRITE_DEVICE1)
INTERUPT_PIN_LINE_DEVICE1 <= addr_data_buf_in[7:0] | INT_PIN_DEVICE1;

if(cs_state == CS_BAR4_WRITE_DEVICE0)
begin
BASE_ADDRESS_4_DEVICE0[31:1] <= addr_data_buf_in[31:1] & 31'h7FFFFFF0;
BASE_ADDRESS_4_DEVICE0[0] <= 1;
end

if(cs_state == CS_BAR0_WRITE_DEVICE1)
begin
BASE_ADDRESS_0_DEVICE1[31:1] <= addr_data_buf_in[31:1] & 31'h7FFFFFFC;//BASE_ADDRESS_0_COM_MUX;
BASE_ADDRESS_0_DEVICE1[0] <= 1;
end

if(cs_state == CS_BAR1_WRITE_DEVICE1)
begin
BASE_ADDRESS_1_DEVICE1[31:1] <= addr_data_buf_in[31:1] & 31'h7FFFFFFC;//BASE_ADDRESS_0_COM_MUX;
BASE_ADDRESS_1_DEVICE1[0] <= 1;
end
end
end

////////////////////////////////////////////////////////
///////////////////END BARS/////////////////////////////////
/////////////////////////////////////////////////////////

endmodule 
