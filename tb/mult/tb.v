module test ();
   logic clk, rst_n;
   clk_gen c1 (.*);
   
  
   logic   [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  opa;
   logic   [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  opb;
   logic   [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  out;

   initial opa = 0;
   initial opb = 0;


   mult m1 (.*);

   initial begin
      #(`RESET_CYCLE*`CLK_CYCLE)
      #(3*`CLK_CYCLE)
      @(negedge clk)
      opa[1] = 32'h40A00000;
      opb[1] = 32'h40800000;
      @(negedge clk)
      opa = 0;
      opb = 0;
      @(negedge clk)
      #(20*`CLK_CYCLE)
      $finish();
   end

endmodule
