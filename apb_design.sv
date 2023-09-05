module apb_slave(
  input clk,
  input reset,
  input psel,
  input penable,
  input [7:0] paddr,
  input pwrite,
  input [31:0] pwdata,
  output reg pready, //by default in system verilog, output ports are wires so cannot assign to them. Need to declare them as reg first.Wires can be used for continuous assignments but not for procedural assignments(like in an always block)...can also use logic instead of reg, that can be driven by both cont and procedural assignments
  output reg [31:0] prdata);
  
  reg [31:0] mem [0:1023]; // define an array to store memory values
  reg [31:0] data_out;     // data to be read by the master
  reg [7:0] addr;         // current address being accessed
  reg write_enable;        // flag to indicate a write operation
  reg read_enable;         // flag to indicate a read operation
  reg psel_internal;       // internal signal to hold psel value
  reg penable_internal;    // internal signal to hold penable value
  
  // assign the internal signals to the input signals to avoid timing issues
  always @ (posedge clk) begin
    psel_internal <= psel;
    penable_internal <= penable;
   // $display("penable is %0d at time %0t",penable, $time);
   // $display("penable_internal is %0d at time %0t",penable_internal, $time);
   // $display("psel_internal is %0d at time %0t", psel_internal, $time);
  end
//-------------------------------------------------------------------------------
  initial
    begin
      for(int i=0; i<1023; i++)
        mem[i] = 'hcacacaca;
    end
  
  // memory read/write logic
  always @ (posedge clk) begin
    if (reset) begin
      write_enable <= 0;
      read_enable <= 0;
      addr <= 0;
      prdata <= 8'h0;
    end else begin
      
      // update the address being accessed
      addr <= paddr;
           
      // handle write operation
      if (write_enable) begin
        mem[addr] <= pwdata;
        write_enable <= 0;
      end
      
      // handle read operation
      if (read_enable) begin
        data_out <= mem[addr];
        @(posedge clk);
        prdata <= data_out;
        read_enable <= 0;
      end
    end
  end
//--------------------------------------------------------------------------------  
  // APB protocol state machine
  reg [1:0] state;
  localparam IDLE = 2'b00;
  localparam SETUP = 2'b01;
  localparam ACCESS = 2'b10;
  //--------------------------------------------------------------------------------
  always @ (*) begin  //this entire block/logic has blocking assignments, as sensitivity list includes *
    case (state)
      IDLE: begin
        pready = 0;
        $display("In IDLE!");
        if (psel_internal) begin
          $display("Debug1 at time %0t, psel_internal %0d, penable %0d", $time, psel_internal, penable);
          state = SETUP;
          write_enable = pwrite;
        //  $display("Write enable in IDLE phase %d", write_enable);
          read_enable = !pwrite;
         // $display("Read enable in IDLE phase %d", read_enable);
        end else begin
         
          state = IDLE;
        end
      end
      SETUP: begin
        #1;
        $display("In SETUP! at time %0t", $time);
        pready = 0;
        if (penable_internal) begin
           //$display("SETUP: value of penable %d, penable_internal %d, psel %d, psel_internal %d", penable, penable_internal, psel, psel_internal);
           //$display("Debug2 at time %0t", $time);
          state = ACCESS;
        end else begin
         // $display("Debug3 at time %0t", $time);
          state = SETUP;
        end
      end
      ACCESS: 
         
        begin
          $display("In ACCESS at time %0t", $time);
          #1;
          if(!penable_internal )
            begin state = IDLE; 
              $display("Inside access state IDLE transition"); 
          end
      
          else if (penable_internal)
          begin
            
          		if (pwrite)           
            		begin
            		//  $display("Debug5 at time %0t", $time);
           			 state = SETUP;
            		write_enable = 1;
            		pready = 1;
                  //    $display("ACCESS: value of penable %d, penable_internal %d, psel %d, psel_internal %d", penable, penable_internal, psel, psel_internal);
              	//	$display("Hi");
            		end 
         		else 
         	    	begin
            		state = SETUP;
           		 read_enable = 1;
            		pready = 1;
             		end
        end
        
         
      end
    endcase
  end
//--------------------------------------------------------------------------------
  
initial begin
        state <= IDLE;
    end
  
endmodule
