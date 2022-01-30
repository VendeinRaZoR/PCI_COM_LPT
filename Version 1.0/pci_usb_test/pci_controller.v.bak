module PCI_controller(
input wire clk, //тактовый сигнал
inout wire [31:0] addr_data, //шина дата-адрес
inout wire [3:0] cbe, //данные – выбор байтов
//output reg [31:0] out_add_data,
//output reg [3:0] out_cbe,
input wire idsel, // для конфигурационных передач
input wire frame, // сигнал начала транзакции
input wire irdy, //сигнал готовности ведущего устройства
output reg devsel, // сигнал, что устройство выбрано
output reg trdy, // сигнал, что устройство готово
input tri par, // контроль четности
input wire reset //сброс устройства (в частности машины состояний)
);

parameter IDLE = 1; // состояния для конечного автомата
parameter READ_IO = 2;
parameter WRITE_IO = 3;
parameter CONFIGURATION_READ = 4;
parameter CONFIGURATION_WRITE = 5; 

reg [7:0] io_data [255:0];//область памяти ввода-вывода
reg [7:0] config_data [255:0]; // область памяти конфигурации

reg [7:0]  BAR0; //базовый адрес байта в пространстве ввода-вывода, которое //размерностью 256 байт. Базовый адрес считывается из конфигурационного //пространства. 
reg [31:0] in_data;
reg [31:0] in_adress; //то, где будем запоминать данные и адреса 
reg [3:0] in_cbe; //то, где будем запоминать команды и сигналы выбора

reg [31:0] out_add_data; //данные на выход
reg [3:0] out_cbe;

wire [31:0] out_addr_data_w;
wire [3:0] out_cbe_w;

wire [31:0] in_addr_data_w;
//wire [3:0] in_cbe_w;

//reg [32:0] tri_add_data_out; 
//reg [32:0] tri_cbe_out; 
  //trireg a;
  reg control;
  
  assign addr_data = (control) ? out_add_data : 32'bz; //связываем с выходом в 3 //состояния
  assign cbe = (control) ? out_cbe : 4'bz; //связываем с выходом в 3 состояния 
  //assign addr_data = out_addr_data_w;
 // assign cbe = out_cbe_w;
  assign in_addr_data_w = (control) ? 32'bz : addr_data; //связываем с выходом в 3 //состояния
  assign in_cbe_w = (control) ? 4'bz : cbe; //связываем с выходом в 3 состояния 

reg [3:0] state; //машина состояний

always @(posedge clk or posedge reset)
begin
if(reset)
begin
state <= IDLE;
BAR0 <= 0;
in_adress <= 0;
in_cbe <= 0;
out_add_data <= 0;
out_cbe <= 0;
control <= 0;
end
else
begin
case(state) //определяем состояние машины состояний
IDLE:
begin //1-ый такт clk
//control <= 1;
BAR0 <= config_data[8'h10]; 
in_adress <= in_addr_data_w;
in_cbe <= in_cbe_w;// Достаем из конфигурационной памяти базовый //адрес 256-байтного пространства ввода-вывода, который ранее записало  //управляющее ПО в виде тестирующих программ или ОС
if(!control && !frame) //не идут ли данные на выход и установлен ли frame
begin 
if(in_cbe == 4'b0010) // дешифрация команды (в зависимости от неё нам надо переходить//в следующее состояние (во 2-ом такте clk)
begin
state <= READ_IO;
end
 if(in_cbe == 4'b0011) 
begin
state <= WRITE_IO;
end
 if(in_cbe == 4'b1010) 
begin
state <= CONFIGURATION_READ;
end
 if(in_cbe == 4'b1011) 
begin
state <= CONFIGURATION_WRITE;
end
end
end

READ_IO:
begin //3-ий такт clk, один такт как раз для ведущего устройства, чтобы он выходы на входы //поменял
if(!irdy) //если ведущее устройство готово
begin
trdy <= 0; // то теперь и целевое устройство готово, чтобы выдать данные 
devsel <= 0; //устройство выбрано
control <= 1; //включаем выходной буфер данных 3-х состояний и отключаем вход
if(!trdy) //если установился trdy
begin
out_add_data  <= io_data[BAR0 + in_adress[7:0] ]; //шлем по //такту CLK (3-ий такт) на выход данные из пространства ввода-вывода по ранее //записанному адресу
state <= IDLE;
end
end
end

WRITE_IO:
begin
if(!irdy) //если ведущее устройство готово
begin 
control <= 0;
trdy <= 0; // то теперь и целевое устройство готово, чтобы в нашу область чего-нибудь записали 
devsel <= 0; //устройство выбрано
if(!trdy) //если установился trdy
begin
in_data <= in_addr_data_w;
io_data[BAR0 + in_adress[7:0] ] <= in_data; ///так как 2 //блокирующих присваивания подряд, запись данных может затянуться на 2 такта 
state <= IDLE;
end
end
end

CONFIGURATION_READ:
begin
if(!irdy) //если ведущее устройство готово
begin
trdy <= 0; // то теперь и целевое устройство готово, чтобы выдать данные 
devsel <= 0; //устройство выбрано
control <= 1; //включаем выходной буфер данных 3-х состояний и отключаем вход
if(!trdy) //если установился trdy
begin
control <= 1;
out_add_data  <= config_data[in_adress[7:0] ]; //шлем по такту CLK (3-ий такт) //на выход данные из пространства конфигурации по ранее записанному адресу
state <= IDLE;
end
end
end

CONFIGURATION_WRITE: //здесь все аналогично, просто записываем куда //прикажет ведущее устройство
begin
if(!irdy)
begin
control <= 0;
trdy <= 0; // то теперь и целевое устройство готово 
devsel <= 0; //устройство выбрано
if(!trdy) //если установился trdy
begin
control <= 0;
in_data <= in_addr_data_w;
config_data[in_adress[7:0] ] <= in_data;
state <= IDLE;
end
end
end // по умолчанию возвращаемся в состояние IDLE
default: state <= IDLE;
endcase
end
end


endmodule // конец модуля контроллера PCI
