`include "apb_agent.sv"
class apb_env extends uvm_env;
  
  
  
   `uvm_component_utils(apb_env);

   //ENV class will have agent as its sub component
   apb_agent  agt;
   //virtual interface for APB interface
   virtual apb_if  vif;

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction

   //Build phase - Construct agent and get virtual interface handle from test  and pass it down to agent
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     agt=apb_agent::type_id::create("agt", this);
     
     if(!uvm_config_db#(virtual apb_if)::get(this,"", "vif", vif))
       `uvm_fatal("Env build","Failed to get intf from test")
       
       uvm_config_db#(virtual apb_if)::set(this,"", "vif", vif);
   endfunction
  
  
  
endclass
