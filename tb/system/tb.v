
module test ();
   logic clk, rst_n;
   clk_gen c1 (.*);

    
   logic [`PARALLEL_ORDER - 1 : 0]   r_valid1;
   logic  [`PARALLEL_ORDER - 1 : 0]   r_valid2;
   logic  [`PARALLEL_ORDER - 1 : 0]   w_valid;

   logic  [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr1;
   logic  [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr2;
   logic  [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] w_addr;
   logic        [`PARALLEL_ORDER - 1 : 0]   w_sel;
   logic        [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] w_data, out;
   
   initial r_valid1 = 0;
   initial r_valid2 = 0;
   initial w_valid = 0;

   initial r_addr1 = 0;
   initial r_addr2 = 0;
   initial w_addr = 0;
   initial w_data = 0;
  
   initial w_sel = 0; 
  
   system s1(.*);
 
   initial begin
      #(`RESET_CYCLE*`CLK_CYCLE)
      #(3*`CLK_CYCLE)
      @(negedge clk)
      w_valid[0] = 1;
      w_valid[1] = 1;
      w_addr[0] = 1;
      w_addr[1] = 2;
      w_data[0] = 32'h40A00000;
      w_data[1] = 32'h40800000;
      @(negedge clk)
      w_valid = 0;
      r_valid1[1] = 1;
      r_valid2[1] = 1;
      r_addr1[1] = 1;
      r_addr2[1] = 2;
      @(negedge clk)
      r_valid1 = 0;
      r_valid2 = 0;
      @(negedge clk)
      w_valid[1] = 1;
      w_addr[1] = 3;
      w_sel[1] = 1;
      @(negedge clk)
      w_valid = 0;
      w_sel = 0;
      #(20*`CLK_CYCLE)
      $finish();
   end

endmodule
