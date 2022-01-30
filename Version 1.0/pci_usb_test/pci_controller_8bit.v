module PCI_controller(
input wire clk, //тактовый сигнал
inout [31:0] addr_data, //шина дата-адрес
inout [3:0] cbe, //данные – выбор байтов
//output reg [31:0] out_add_data,
//output reg [3:0] out_cbe,
input wire idsel, // для конфигурационных передач
input wire frame, // сигнал начала транзакции
input wire irdy, //сигнал готовности ведущего устройства
inout devsel, // сигнал, что устройство выбрано
inout trdy, // сигнал, что устройство готово
//inout tri par, // контроль четности
input wire reset //сброс устройства (в частности машины состояний)
);


parameter IDLE = 1; // состояния для конечного автомата
parameter READ_IO = 2;
parameter WRITE_IO = 3;
parameter CONFIGURATION_READ = 4;
parameter CONFIGURATION_WRITE = 5; 
parameter RESET = 6;

parameter ADDR_RANGE = 5;

parameter VIDPID = 32'h66669999;//������ �����������...
parameter CLASSC = 32'h0C032000;
parameter USBBASE = 0;//default
parameter PORTWAKECAP_FLADJ_SBRN = 32'h00002020;
parameter USBLEGSUP = 0;
parameter USBLEGCTLSTS = 0;

//reg [7:0] io_data [255:0];//область памяти ввода-вывода
reg [7:0] config_data [255:0]; // область памяти конфигурации 8 BIT !!!

reg [31:0] in_data;
reg [31:0] in_adress; //то, где будем запоминать данные и адреса 
reg [3:0] in_cbe; //то, где будем запоминать команды и сигналы выбора

reg [31:0] out_add_data; //данные на выход
reg [3:0] out_cbe;

reg [7:0] last_conf_write_addr; //адрес в последней транзакции чтения
reg [31:0] last_conf_write_data; //данные в последней транзакции чтения

tri [31:0] in_addr_data_w;
tri [3:0] in_cbe_w;

  reg control;
  
  reg [7:0] confspace_pointer;
  reg [2:0] byte_to_dword_counter;
  
  reg [7:0] decode_data;
  
  wire [7:0] in_addr_w;
  
  reg [31:0] addr_data_r;
  reg [31:0] addr_data_buf_in; 
  reg [31:0] addr_data_r_in; 
  
  reg [31:0] tempdata;
  
  reg [3:0] cbe_r_in;
  
  assign addr_data = (!control) ? out_add_data : 32'bz; //нихз
  //assign cbe = (!control) ? out_cbe : 32'bz; //нихз
  
  always@*
  begin
  if(control)
  addr_data_buf_in = addr_data;
  else
  addr_data_buf_in = 32'bz;
  end
  
  always@*
  begin
  if(control)
  cbe_r_in = cbe;
  else
  cbe_r_in = 4'bz;
  end
  
  

  assign in_addr_data_w = (state == RESET) ? decode_data : addr_data_buf_in[7:0]; //связываем с выходом в 3 //состояния
  //assign in_cbe_w = (control) ? cbe : 4'bz; //связываем с выходом в 3 состояния 
  assign in_addr_w = (state == RESET) ? confspace_pointer[7:0] : in_adress[7:0];
  
  reg data_ready;
  reg is_config; //конфигурационная ли это транзакция
  assign trdy = (!irdy & !devsel & data_ready) ? 1'b0 : 1'bz;
  assign devsel = (state != IDLE & state != RESET) ? 1'b0 : 1'bz;
  
reg [3:0] state; //машина состояний

always@*
begin
case(in_addr_w)
8'h00: decode_data = 8'hEF; 
8'h01: decode_data = 8'hBE;
8'h02: decode_data = 8'hAD;
8'h03: decode_data = 8'hDE;
8'h04: decode_data = 8'h00;//����� 0
8'h05: decode_data = 8'h00;
8'h06: decode_data = 8'h80;
8'h07: decode_data = 8'h02;
8'h08: decode_data = 8'h00;
8'h09: decode_data = 8'h20;
8'h0A: decode_data = 8'h03;
8'h0B: decode_data = 8'h0C;
8'h0C: decode_data = 8'h08;//����� 0
8'h0D: decode_data = 8'h00;
8'h0E: decode_data = 8'h00;
8'h0F: decode_data = 8'h00;
8'h10: decode_data = 8'h00;
8'h60: decode_data = 8'h20;
8'h61: decode_data = 8'h20;
8'h62: decode_data = 8'h00;
8'h63: decode_data = 8'h00;
default:
decode_data = 8'h00;
endcase
end

always @(posedge clk or negedge reset)
begin
if(!reset)
begin
state <= RESET;
control <= 1;
out_add_data <= 0;
out_cbe <= 0;
in_adress <= 0;
in_cbe <= 0;
confspace_pointer <= 0;
data_ready <= 0;
is_config <= 0;
byte_to_dword_counter <= 0;
end
else
begin
control <= 1; // восстанавливаем прежнее
data_ready <= 0;
byte_to_dword_counter <= 0;
if(!frame)
begin
is_config <= idsel;
in_cbe <= cbe_r_in;
in_adress <= in_addr_data_w;// Достаем из конфигурационной памяти базовый //адрес 256-байтного пространства ввода-вывода, который ранее записало  //управляющее ПО в виде тестирующих программ или ОС
end // чтоб не сразу данные появлялись, так может правильней, фиг знает
else
begin
in_cbe <= 0;
end
case(state) //определяем состояние машины состояний
RESET:
begin
config_data[in_addr_w] <= in_addr_data_w;
if(confspace_pointer >= 8'hFC)
begin
state <= IDLE;
end
else
begin
confspace_pointer <= confspace_pointer + 1;
end
end
IDLE:
begin //1-ый такт clk
case(in_cbe)
4'b0010:
begin
state <= READ_IO;
end
4'b0011:
begin
state <= WRITE_IO;
end
4'b1010:
begin
if(is_config) 
state <= CONFIGURATION_READ;
else
state <= IDLE; 
end
4'b1011:
begin
if(is_config) 
state <= CONFIGURATION_WRITE;
else
state <= IDLE; 
end
default: state <= IDLE; 
endcase
end

CONFIGURATION_READ:
begin//если ведущее устройство готово
//if(last_conf_write_addr == 8'h10)
//out_add_data <= last_conf_write_data - ADDR_RANGE; 
//else
if(byte_to_dword_counter <= 3)
begin
out_add_data[31:0] <= {config_data[in_addr_w + byte_to_dword_counter],out_add_data[31:8]};
byte_to_dword_counter <= byte_to_dword_counter + 1;
end
else
begin
data_ready <= 1;
control <= 0;
end
if(irdy)
state <= IDLE;
end

/*CONFIGURATION_WRITE: //здесь все аналогично, просто записываем куда //прикажет ведущее устройство
begin
control <= 1;
data_ready <= 1;
config_data[in_addr_w] <= in_addr_data_w;
last_conf_write_addr <= in_addr_w;
last_conf_write_data <= in_addr_data_w;
if(irdy)
state <= IDLE;
end // по умолчанию возвращаемся в состояние IDLE*/

default: state <= IDLE;

endcase
end
end


endmodule // конец модуля контроллера PCI
