class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)
  
  
  function new(string name= "apb_sequence");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(apb_sequencer)
  
 apb_seq_item request;
  
  virtual task body();
    request = apb_seq_item::type_id::create("request");
//    start_item(request);
//    if(!request.randomize())
//       `uvm_error("body::seq_item", "randomization failure for packet");
//    finish_item(request);
    
    `uvm_do_with(request, {psel == 1; pwrite == 0; penable==1; })

  endtask

endclass
