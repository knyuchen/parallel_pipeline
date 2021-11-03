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

   input  [`REG_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr1,
   input  [`REG_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] r_addr2,
   input  [`REG_ORDER - 1 : 0][`REG_ADDR_WIDTH - 1 : 0] w_addr,
   
   input  [`REG_ORDER - 1 : 0][`REG_DATA_WIDTH - 1 : 0] w_data,
`endif
`ifndef MULTI_REG
   input                         r_valid1,
   input                         r_valid2,
   input                         w_valid,

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
`endif
`ifndef MULTI_REG
   logic  [`REG_DATA_WIDTH - 1 : 0] r_data1;
   logic  [`REG_DATA_WIDTH - 1 : 0] r_data2;
`endif

   assign opa = r_data1;
   assign opb = r_data2;

   register r1 (.*);
   mult m1 (.*);
endmodule
