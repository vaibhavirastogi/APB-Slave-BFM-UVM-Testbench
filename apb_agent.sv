`include "apb_seq_item.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"

class apb_agent extends uvm_agent;
  
  
  `uvm_component_utils(apb_agent)
  
  function new(string name="apb_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  apb_driver drv;
  apb_sequencer seq;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=apb_driver::type_id::create("drv", this);
    seq=apb_sequencer::type_id::create("seq", this);
  endfunction
  
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seq.seq_item_export);
 endfunction
  
  
  
  
  
  
endclass
