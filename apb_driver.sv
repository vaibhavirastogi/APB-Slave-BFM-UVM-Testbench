`define DRV_IF intf.drv_mp.driver_cb
class apb_driver extends uvm_driver#(apb_seq_item);
  
  
  `uvm_component_utils(apb_driver)
  
  function new(string name="apb_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual apb_if intf;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //get virtual interface handle using config db
    if(!uvm_config_db#(virtual apb_if)::get(this,"", "intf", intf))
      `uvm_fatal("Driver build","Failed to get intf")
  endfunction
  
  apb_seq_item req;
    
    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
     forever begin
      seq_item_port.get_next_item(req);
     // $display("DRIVER::Received below packet from sequencer");
     // req.print();
      drive();
       $display("DRIVER:: Driving below packet to DUT");
      req.print(); //printing after driving to the DUT
      seq_item_port.item_done();
    end
 
    endtask

    
       
   virtual task drive;
  @(posedge intf.clk);
  `DRV_IF.paddr <= req.paddr;
  `DRV_IF.pwrite <= req.pwrite;
  
  `DRV_IF.psel <= 1;
     @(posedge intf.clk);
     `DRV_IF.penable <= 1;
  @(posedge intf.clk);
  $display("DRIVER:: Before setting penable to 1");
     #1;
  `DRV_IF.penable <= req.penable;
  $display("DRIVER:: After setting penable to 1");
  if (req.pwrite) begin
    `DRV_IF.pwdata <= req.pwdata;
  end
  @(posedge intf.clk);
  `DRV_IF.psel <= 0;
  `DRV_IF.penable <= 0;
  if (!req.pwrite) begin
        @(posedge intf.clk);
    req.prdata = `DRV_IF.prdata;
    $display("DRIVER::Read data is %0h at time %0t", req.prdata, $time);
  end
endtask


    
      
  
endclass
