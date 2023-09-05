`include "apb_test.sv"
`include "apb_interface.sv"

module apb_top;
  
 import uvm_pkg::*;
  
  logic [7:0] paddr;
   logic        psel;
   logic        penable;
   logic        pwrite;
   logic [31:0] prdata;
   logic [31:0] pwdata;
bit clk;
  bit reset;
  
always #4 clk = ~clk;
  
  initial begin
    reset=0;
    #1 reset=1;
    #1 reset=0;
  end
 
  //Instantiate a physical interface for APB interface here and connect the pclk input
  apb_if intf(clk, reset);
  apb_slave DUT(.clk(intf.clk), .reset(intf.reset), .psel(intf.psel), .penable(intf.penable), .paddr(intf.paddr), .pwrite(intf.pwrite), .pwdata(intf.pwdata), .pready(intf.pready), .prdata(intf.prdata));
  
  initial begin
    //Pass above physical interface to test top
    //(which will further pass it down to env->agent->drv/sqr/mon
    uvm_config_db#(virtual apb_if)::set(uvm_root::get(), "*", "intf", intf);
    
    
    run_test("apb_test");
     
    #100;
    $finish; // Run for 1000 time units

     
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  

  
endmodule
