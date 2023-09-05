class apb_seq_item extends uvm_sequence_item;
  
  rand bit pwrite;
  rand bit[7:0] paddr;
  rand bit[31:0] pwdata;
  bit [31:0] prdata;
  rand bit psel;
  rand bit penable;
  
  `uvm_object_utils_begin(apb_seq_item)
  `uvm_field_int(pwrite, UVM_ALL_ON)
  `uvm_field_int(paddr, UVM_ALL_ON)
  `uvm_field_int(pwdata, UVM_ALL_ON)
  `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_field_int(psel, UVM_ALL_ON)
  `uvm_field_int(penable, UVM_ALL_ON)
  	
  `uvm_object_utils_end
  
  function new(string name="apb_seq_item");
    super.new(name);    
  endfunction
  
  constraint addr_sel {paddr>8'haa;}
  constraint wdata_sel {pwdata>32'haaaabbbb;}

endclass
