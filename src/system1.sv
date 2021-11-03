module system (
`ifdef MULTI_MULT
   output logic [`MULT_DATA_WIDTH*`MULT_ORDER - 1 : 0]  out,
`endif
`ifndef MULTI_MULT
   output logic [`MULT_DATA_WIDTH - 1 : 0]  out,
`endif
`ifdef MULTI_REG
   input  [`REG_ORDER - 1 : 0]   r_valid1,
   input  [`REG_ORDER - 1 : 0]   r_valid2,
   input  [`REG_ORDER - 1 : 0]   w_valid,
   input  [`REG_ORDER - 1 : 0]   w_sel,
   input  [`REG_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr1,
   input  [`REG_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr2,
   input  [`REG_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] w_addr,
   
   input  [`REG_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] w_data,
`endif
`ifndef MULTI_REG
   input                         r_valid1,
   input                         r_valid2,
   input                         w_valid,
   input                         w_sel,
   input  [`REG_ADDR_WIDTH - 1 : 0] r_addr1,
   input  [`REG_ADDR_WIDTH - 1 : 0] r_addr2,
   input  [`REG_ADDR_WIDTH - 1 : 0] w_addr,
   
   input  [`REG_DATA_WIDTH - 1 : 0] w_data,
`endif
   input                clk,
   input                rst_n
);
`ifdef MULTI_MULT
   logic [`MULT_DATA_WIDTH*`MULT_ORDER - 1 : 0] opa;
   logic          [`MULT_DATA_WIDTH*`MULT_ORDER - 1 : 0]  opb;
`endif
`ifndef MULTI_MULT
   logic          [`MULT_DATA_WIDTH - 1 : 0]  opa;
   logic          [`MULT_DATA_WIDTH - 1 : 0]  opb;
`endif
`ifdef MULTI_REG
   logic  [`REG_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data1;
   logic  [`REG_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] r_data2;
   logic  [`REG_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] real_w_data;
   genvar  i;
   generate 
      for (i = 0; i < `REG_ORDER; i = i + 1) begin
         assign real_w_data[i] = (w_sel[i] == 1) ? out[(i+1)*`MULT_DATA_WIDTH - 1 : i*`MULT_DATA_WIDTH] : w_data[i];
      end
   endgenerate
`endif
`ifndef MULTI_REG
   logic  [`REG_DATA_WIDTH - 1 : 0] r_data1;
   logic  [`REG_DATA_WIDTH - 1 : 0] r_data2;
   logic  [`REG_DATA_WIDTH - 1 : 0] real_w_data;
   assign real_w_data = (w_sel == 1) ? out : w_data;
`endif

   assign opa = r_data1;
   assign opb = r_data2;

   register r1 (.*, .w_data(real_w_data));
   mult m1 (.*);
endmodule
