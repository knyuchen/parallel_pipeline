module register (
//`ifdef MULTI_REG
   input  [`PARALLEL_ORDER - 1 : 0]   r_valid1,
   input  [`PARALLEL_ORDER - 1 : 0]   r_valid2,
   input  [`PARALLEL_ORDER - 1 : 0]   w_valid,

   input  [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr1,
   input  [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr2,
   input  [`PARALLEL_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] w_addr,
   
   input  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] w_data,

   output logic  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data1,
   output logic  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data2,
//`endif
/*
`ifndef MULTI_REG
   input                         r_valid1,
   input                         r_valid2,
   input                         w_valid,

   input  [`REG_ADDR_WIDTH - 1 : 0] r_addr1,
   input  [`REG_ADDR_WIDTH - 1 : 0] r_addr2,
   input  [`REG_ADDR_WIDTH - 1 : 0] w_addr,
   
   input  [`REG_DATA_WIDTH - 1 : 0] w_data,

   output logic  [`REG_DATA_WIDTH - 1 : 0] r_data1,
   output logic  [`REG_DATA_WIDTH - 1 : 0] r_data2,
`endif   
*/
   input   clk,
   input   rst_n		 
);

   logic [`REG_ENTRY - 1 : 0][`REG_DATA_WIDTH - 1 : 0] store, store_w;
//`ifdef MULTI_REG
   logic  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data1_w;
   logic  [`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data2_w;
   logic  [`REG_ENTRY - 1 : 0][`PARALLEL_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] wdata_pre;
   genvar 						i, j;
   integer                                              k;
   generate
      for (i = 0; i < `PARALLEL_ORDER; i = i + 1) begin
         assign r_data1_w[i] = (r_valid1[i] == 1) ? store[r_addr1[i]] : 0;
         assign r_data2_w[i] = (r_valid2[i] == 1) ? store[r_addr2[i]] : 0;
      end
      for (i = 0; i < `REG_ENTRY; i = i + 1) begin
         assign store_w[i] = wdata_pre[i][`PARALLEL_ORDER - 1];
         assign wdata_pre[i][0] = (w_valid[0] == 1 && w_addr[0] == i) ? w_data[0] : store[i];
         if (`PARALLEL_ORDER > 1) begin
         for (j = 1; j < `PARALLEL_ORDER; j = j + 1) begin
            assign wdata_pre [i][j] = (w_valid[j] == 1 && w_addr[j] == i) ? w_data[j] : wdata_pre[i][j-1];
         end
         end
      end
   endgenerate
//`endif
/*
`ifndef MULTI_REG
   logic [`REG_DATA_WIDTH - 1 : 0] r_data1_w;
   logic [`REG_DATA_WIDTH - 1 : 0] r_data2_w;
   assign r_data1_w = (r_valid1 == 1) ? store[r_addr1] : 0;
   assign r_data2_w = (r_valid2 == 1) ? store[r_addr2] : 0;
   always_comb begin
      store_w = store;
      if (w_valid == 1) store_w[w_addr] = w_data;
   end
`endif
*/
   always_ff @ (posedge clk or negedge rst_n) begin
      if (rst_n == 0) begin
         store <= 0;
         r_data1 <= 0;
         r_data2 <= 0;
      end
      else begin
         store <= store_w;
         r_data1 <= r_data1_w;
         r_data2 <= r_data2_w;
      end
   end


endmodule
		
