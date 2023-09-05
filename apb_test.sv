`include "apb_env.sv"
`include "apb_sequence.sv"

class apb_test extends uvm_test;
  
  `uvm_component_utils(apb_test)
  
  apb_env env;
  apb_sequence seq;
 virtual apb_if vif;
  
  function new(string name = "apb_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_env::type_id::create("env", this);
    seq = apb_sequence::type_id::create("seq", this);
    uvm_config_db#(virtual apb_if)::set(this,"*", "vif", vif);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agt.seq);
    #100;
    phase.drop_objection(this);
  endtask : run_phase
  
  
  
endclass
