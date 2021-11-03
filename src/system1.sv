module system (
   output logic [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  out,
   input        [`PARALLEL_ORDER - 1 : 0]   r_valid1,
   input        [`PARALLEL_ORDER - 1 : 0]   r_valid2,
   input        [`PARALLEL_ORDER - 1 : 0]   w_valid,
   input        [`PARALLEL_ORDER - 1 : 0]   w_sel,
   input        [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr1,
   input        [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr2,
   input        [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] w_addr,
   input        [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] w_data,
   input                clk,
   input                rst_n
);
   logic       [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  opa, opb;
   logic  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data1;
   logic  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data2;
   logic  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] real_w_data;
   genvar  i;
   generate 
      for (i = 0; i < `PARALLEL_ORDER; i = i + 1) begin
         assign real_w_data[i] = (w_sel[i] == 1) ? out[i] : w_data[i];
         assign opa[i] = r_data1[i];
         assign opb[i] = r_data2[i];
      end
   endgenerate

   register r1 (.*, .w_data(real_w_data));
   mult m1 (.*);

endmodule
