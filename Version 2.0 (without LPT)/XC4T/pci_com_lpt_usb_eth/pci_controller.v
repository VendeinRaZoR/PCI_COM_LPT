module pci_controller(
input I_CLK,
inout [31:0] IO_AD,
input [3:0] I_CBE,
input I_IDSEL,
input _I_FRAME, 
input _I_IRDY, 
input I_DEV0BAR4DATA,
input I_DEV1BAR0DATA,
input I_DEV1BAR1DATA,
input _I_RESET, 
output O_PAR,
output reg [31:0] O_ADDR,
output [3:0] O_BE,
output O_DEV0BAR4SEL,
output O_DEV1BAR0SEL,
output O_DEV1BAR1SEL,
output O_OE_WE_DEV,
output _O_TRDY,
output _O_DEVSEL
);

reg [31:0] O_AD;
wire [31:0] I_AD;

wire oe;

reg [3:0] cmd;

reg [31:0] BAR_0_DEV0;
reg [31:0] BAR_1_DEV0;
reg [31:0] BAR_2_DEV0;
reg [31:0] BAR_3_DEV0;
reg [31:0] BAR_4_DEV0;
reg [31:0] BAR_5_DEV0;
reg [31:0] CMD_STAT_DEV0;  
reg [31:0] INT_PIN_LINE_DEV0; 

reg [31:0] BAR_0_DEV1;
reg [31:0] BAR_1_DEV1;
reg [31:0] BAR_2_DEV1;
reg [31:0] BAR_3_DEV1;
reg [31:0] BAR_4_DEV1;
reg [31:0] BAR_5_DEV1;
reg [31:0] CMD_STAT_DEV1;  
reg [31:0] INT_PIN_LINE_DEV1; 

parameter VIDPID = 16'h01;
parameter STATUSCOMMAND = 16'h02;
parameter CLASSCODE = 16'h04;
parameter BIST_HEADER_LAT_CACH = 16'h08;
parameter BAR0 = 16'h10; 
parameter BAR1 = 16'h20;
parameter BAR2 = 16'h40;
parameter BAR3 = 16'h80;
parameter BAR4 = 16'h100;
parameter BAR5 = 16'h200;
parameter CARDBUS = 16'h400;
parameter SUBSYSTEM_VENDOR = 16'h800;
parameter EXPANSION_ROM_BAR = 16'h1000;
parameter CAP_POINTER = 16'h2000;
parameter LAT_INTERRUPT = 16'h4000;

parameter RESERVED = 16'h8000;

parameter CS_INT_PIN_DEV0 = 32'h0200;
parameter CS_INT_PIN_DEV1 = 32'h0100;
parameter CS_INT_PIN_DEV2 = 32'h0300;
parameter CS_INT_PIN_DEV3 = 32'h0400;

parameter CS_STAT_MASK_DEV0 = 16'h0288;
parameter CS_STAT_MASK_DEV1 = 16'h0288;
parameter CS_STAT_MASK_DEV2 = 16'h0288;
parameter CS_STAT_MASK_DEV3 = 16'h0288;

parameter CS_CMD_MASK_DEV0 = 16'h0003;
parameter CS_CMD_MASK_DEV1 = 16'h0003;
parameter CS_CMD_MASK_DEV2 = 16'h0003;
parameter CS_CMD_MASK_DEV3 = 16'h0003;

parameter CS_MULTIFUNC_DEV = 32'h800000;

parameter CS_VIDPID_DEV0 = 32'hDEADBEEF;
parameter CS_CLASSCODE_DEV0 = 32'h0C030050;

parameter CS_VIDPID_DEV1 = 32'h50534348;
parameter CS_CLASSCODE_DEV1 = 32'h0700020F;

parameter CS_VIDPID_DEV2 = 32'h00;
parameter CS_CLASSCODE_DEV2 = 32'h00;

parameter CS_VIDPID_DEV3 = 32'h00;
parameter CS_CLASSCODE_DEV3 = 32'h00;

parameter ST_IDLE = 0;
parameter ST_DECODED = 1;
parameter ST_READCS = 2;
parameter ST_WRITECS = 3;
parameter ST_READIO = 4;
parameter ST_WRITEIO = 5;
parameter ST_SUSTAIN = 6;

wire is_BAR4_DEV0_cfgd; 
wire is_BAR0_DEV1_cfgd;
wire is_BAR1_DEV1_cfgd;

wire dev_ack;
wire cs_ack;

assign is_BAR4_DEV0_cfgd = (BAR_4_DEV0[15:0] > 16'h1000 && BAR_4_DEV0[15:0] < 16'hFFFF);

assign is_BAR0_DEV1_cfgd = (BAR_0_DEV1[15:0] > 16'h1000 && BAR_0_DEV1[15:0] < 16'hFFFF);
assign is_BAR1_DEV1_cfgd = (BAR_1_DEV1[15:0] > 16'h1000 && BAR_1_DEV1[15:0] < 16'hFFFF);
 
  reg [15:0] cmd_csaddr_dcdr;
  
  reg is_dev0cs;
  
  reg is_dev1cs;
  
  reg is_dev2cs;
  
  reg is_dev3cs;
  
  wire is_devcs;
  
  reg _is_burst;
  
  reg is_cfg_space;
  
  reg [2:0] ST;
  
  assign IO_AD = oe ? O_AD : 32'hz;
  assign I_AD = !oe ? IO_AD : 32'hz;
  
  assign oe = ST == ST_READCS;
  
  assign O_OE_WE_DEV = ST == ST_READIO;
 
  always@*
  begin
  case(O_ADDR[15:8])
  8'h00:
  begin
  is_dev0cs = 1;
  is_dev1cs = 0;
  is_dev2cs = 0;
  is_dev3cs = 0;
  end
  8'h01:
  begin
  is_dev0cs = 0;
  is_dev1cs = 1;
  is_dev2cs = 0;
  is_dev3cs = 0;
  end
  8'h02:
  begin
  is_dev0cs = 0;
  is_dev1cs = 0;
  is_dev2cs = 1;
  is_dev3cs = 0;
  end
  8'h03:
  begin
  is_dev0cs = 0;
  is_dev1cs = 0;
  is_dev2cs = 0;
  is_dev3cs = 1;
  end
  default:
  begin
  is_dev0cs = 0;
  is_dev1cs = 0;
  is_dev2cs = 0;
  is_dev3cs = 0;
  end
  endcase
  end
  

  assign dev_ack = (ST == ST_READCS | ST == ST_WRITECS | ST == ST_READIO | ST == ST_WRITEIO | ST == ST_DECODED);
  assign cs_ack = (ST == ST_READCS | ST == ST_WRITECS);
  
  assign O_PAR = 1'bz;

assign is_devcs = is_dev0cs | is_dev1cs | is_dev2cs | is_dev3cs;

assign _O_TRDY = (I_DEV0BAR4DATA | I_DEV1BAR0DATA | I_DEV1BAR1DATA | cs_ack ) ? 1'b0 : ST == ST_SUSTAIN ? 1'b1 : 1'bz;
assign _O_DEVSEL = dev_ack ? 1'b0 : (ST == ST_SUSTAIN ? 1'b1 : 1'bz);
 
always@(posedge I_CLK or negedge _I_RESET)
begin
if(!_I_RESET)
O_AD <= 0;
else
case(O_ADDR[15:8])
8'h00:
begin
case(O_ADDR[6:2])
4'h0: O_AD <= CS_VIDPID_DEV0;
4'h1: O_AD <= CMD_STAT_DEV0;
4'h2: O_AD <= CS_CLASSCODE_DEV0;
4'h3: O_AD <= 32'h00002008 | CS_MULTIFUNC_DEV;
4'h4: O_AD <= BAR_0_DEV0;
4'h5: O_AD <= BAR_1_DEV0;
4'h6: O_AD <= BAR_2_DEV0;
4'h7: O_AD <= BAR_3_DEV0;
4'h8: O_AD <= BAR_4_DEV0;
4'h9: O_AD <= BAR_5_DEV0;
4'hB: O_AD <= 32'h12340925; 
4'hF: O_AD <= INT_PIN_LINE_DEV0;
default:
O_AD <= 0;
endcase
end
8'h01:
begin
case(O_ADDR[6:2])
4'h0: O_AD <= CS_VIDPID_DEV1;
4'h1: O_AD <= CMD_STAT_DEV1;
4'h2: O_AD <= CS_CLASSCODE_DEV1;
4'h3: O_AD <= 32'h00 | CS_MULTIFUNC_DEV;
4'h4: O_AD <= BAR_0_DEV1;
4'h5: O_AD <= BAR_1_DEV1;
4'h6: O_AD <= BAR_2_DEV1;
4'h7: O_AD <= BAR_3_DEV1;
4'h8: O_AD <= BAR_4_DEV1;
4'h9: O_AD <= BAR_5_DEV1;
4'hB: O_AD <= CS_VIDPID_DEV1;
4'hF: O_AD <= INT_PIN_LINE_DEV1;
default:
O_AD <= 0;
endcase
end

default:
begin
case(O_ADDR[6:2])
4'h0: O_AD <= CS_VIDPID_DEV0;
4'h1: O_AD <= CMD_STAT_DEV0;
4'h2: O_AD <= CS_CLASSCODE_DEV0;
4'h3: O_AD <= 32'h00002008 | CS_MULTIFUNC_DEV;
4'h4: O_AD <= BAR_0_DEV0;
4'h5: O_AD <= BAR_1_DEV0;
4'h6: O_AD <= BAR_2_DEV0;
4'h7: O_AD <= BAR_3_DEV0;
4'h8: O_AD <= BAR_4_DEV0;
4'h9: O_AD <= BAR_5_DEV0;
4'hB: O_AD <= 32'h12340925; 
4'hF: O_AD <= INT_PIN_LINE_DEV0;
default:
O_AD <= 0;
endcase
end
endcase
end

always@*
begin
case(O_ADDR[6:2])
4'h0: cmd_csaddr_dcdr = VIDPID;
4'h1: cmd_csaddr_dcdr = STATUSCOMMAND;
4'h2: cmd_csaddr_dcdr = CLASSCODE;
4'h3: cmd_csaddr_dcdr = BIST_HEADER_LAT_CACH;
4'h4: cmd_csaddr_dcdr = BAR0;
4'h5: cmd_csaddr_dcdr = BAR1;
4'h6: cmd_csaddr_dcdr = BAR2;
4'h7: cmd_csaddr_dcdr = BAR3;
4'h8: cmd_csaddr_dcdr = BAR4;
4'h9: cmd_csaddr_dcdr = BAR5;
4'hA: cmd_csaddr_dcdr = CARDBUS;
4'hB: cmd_csaddr_dcdr = SUBSYSTEM_VENDOR;
4'hC: cmd_csaddr_dcdr = EXPANSION_ROM_BAR;
4'hD: cmd_csaddr_dcdr = CAP_POINTER;
4'hE: cmd_csaddr_dcdr = RESERVED;
4'hF: cmd_csaddr_dcdr = LAT_INTERRUPT;
default:
cmd_csaddr_dcdr = 32'h00;
endcase
end

initial
begin
O_ADDR <= 0;
is_cfg_space <= 0;
_is_burst <= 0;
ST <= ST_IDLE;
end

assign O_DEV0BAR4SEL = (O_ADDR[31:8] == BAR_4_DEV0[31:8]) & (ST == ST_READIO | ST == ST_WRITEIO | ST == ST_DECODED);
assign O_DEV1BAR0SEL = (O_ADDR[31:8] == BAR_0_DEV1[31:8]) & (ST == ST_READIO | ST == ST_WRITEIO | ST == ST_DECODED);
assign O_DEV1BAR1SEL = (O_ADDR[31:8] == BAR_1_DEV1[31:8]) & (ST == ST_READIO | ST == ST_WRITEIO | ST == ST_DECODED);

//ADDRESS LATCH
always@(posedge I_CLK or negedge _I_RESET)
begin
if(!_I_RESET)
begin
O_ADDR <= 0;
_is_burst <= 0;
ST <= ST_IDLE;
cmd <= 0;
end
else
begin
_is_burst <= _I_FRAME;
if(!_I_FRAME & _is_burst)
begin
cmd <= I_CBE;
O_ADDR <= I_AD;
end

case(ST)
ST_IDLE:
begin
if(!_I_FRAME & I_IDSEL & (I_CBE == 8'hA | I_CBE == 8'hB) & (I_AD[15:8] == 8'h00 | I_AD[15:8] == 8'h01)
| !_I_FRAME & ((I_AD[31:8] == BAR_4_DEV0[31:8]) & is_BAR4_DEV0_cfgd
| (I_AD[31:8] == BAR_0_DEV1[31:8]) & is_BAR0_DEV1_cfgd 
| (I_AD[31:8] == BAR_1_DEV1[31:8]) & is_BAR1_DEV1_cfgd))
ST <= ST_DECODED; //придумать способ как декодировать проще !!!
else
ST <= ST_IDLE;
end

ST_DECODED:
begin
case(cmd)
4'hA:ST <= ST_READCS;
4'hB:ST <= ST_WRITECS;
4'h2:ST <= ST_READIO;
4'h3:ST <= ST_WRITEIO;
default:
ST <= ST_IDLE;
endcase
end

ST_WRITECS:
begin
ST <= ST_SUSTAIN;
end

ST_READCS:
begin
ST <= ST_SUSTAIN;
end

ST_READIO:
begin
ST <= ST_SUSTAIN;
end

ST_WRITEIO:
begin
ST <= ST_SUSTAIN;
end

ST_SUSTAIN:
begin
ST <= ST_IDLE;
end

endcase
end
end

assign O_BE = ~I_CBE;


////////////////////////////////////////////////////////
///////////////////BEGIN BARS/////////////////////////////////
/////////////////////////////////////////////////////////

always@(posedge I_CLK or negedge _I_RESET)
begin
if(!_I_RESET)
begin
BAR_4_DEV0 <= 32'h00;
BAR_0_DEV1 <= 32'h00;
BAR_1_DEV1 <= 32'h00;
CMD_STAT_DEV0 <= 0;
CMD_STAT_DEV1 <= 0;
INT_PIN_LINE_DEV0 <= 8'h00;
INT_PIN_LINE_DEV1 <= 8'h00;
end
else
begin
if(cmd_csaddr_dcdr[1] & ST == ST_WRITECS & is_dev0cs)
CMD_STAT_DEV0 <= {I_AD[31:16] & CS_STAT_MASK_DEV0, I_AD[15:0] & CS_CMD_MASK_DEV0};
if(cmd_csaddr_dcdr[1] & ST == ST_WRITECS & is_dev1cs)
CMD_STAT_DEV1 <= {I_AD[31:16] & CS_STAT_MASK_DEV1, I_AD[15:0] & CS_CMD_MASK_DEV1};
if(cmd_csaddr_dcdr[14] & ST == ST_WRITECS & is_dev0cs)
INT_PIN_LINE_DEV0 <= I_AD[7:0] | CS_INT_PIN_DEV0;
if(cmd_csaddr_dcdr[14] & ST == ST_WRITECS & is_dev1cs)
INT_PIN_LINE_DEV1 <= I_AD[7:0] | CS_INT_PIN_DEV1;

if(cmd_csaddr_dcdr[8] & ST == ST_WRITECS & is_dev0cs)
begin
BAR_4_DEV0[31:1] <= I_AD[31:1] & 31'h7FFFFFF0;
BAR_4_DEV0[0] <= 1;
end

if(cmd_csaddr_dcdr[4] & ST == ST_WRITECS & is_dev1cs)
begin
BAR_0_DEV1[31:1] <= I_AD[31:1] & 31'h7FFFFFFC; 
BAR_0_DEV1[0] <= 1;
end

if(cmd_csaddr_dcdr[5] & ST == ST_WRITECS & is_dev1cs)
begin
BAR_1_DEV1[31:1] <= I_AD[31:1] & 31'h7FFFFFFC;
BAR_1_DEV1[0] <= 1;
end 
end
end

////////////////////////////////////////////////////////
///////////////////END BARS/////////////////////////////////
/////////////////////////////////////////////////////////

endmodule 
