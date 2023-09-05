interface apb_if(input logic clk, reset);
  
  
  logic psel;
  logic penable;
  logic [7:0] paddr;
  logic pwrite;
  logic [31:0] pwdata;
  logic pready;
  logic [31:0] prdata;
  
  clocking driver_cb @(posedge clk);
    input pready;
    input prdata;
    input clk;
    input reset;
    output psel;
    output penable;
    output paddr;
    output pwrite;
    output pwdata;
  endclocking
  
  clocking monitor_cb @(posedge clk);
    input pready;
    input prdata;
    input clk;
    input reset;
    input psel;
    input penable;
    input paddr;
    input pwrite;
    input pwdata;
  endclocking
  
  modport mon_mp (clocking monitor_cb);
    modport drv_mp (clocking driver_cb);
  
  
endinterface
