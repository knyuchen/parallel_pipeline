module mult (
`ifdef MULTI_MULT
   input          [`MULT_DATA_WIDTH*`MULT_ORDER - 1 : 0]  opa,
   input          [`MULT_DATA_WIDTH*`MULT_ORDER - 1 : 0]  opb,
   output logic   [`MULT_DATA_WIDTH*`MULT_ORDER - 1 : 0]  out,
`endif
`ifndef MULTI_MULT
   input          [`MULT_DATA_WIDTH - 1 : 0]  opa,
   input          [`MULT_DATA_WIDTH - 1 : 0]  opb,
   output logic   [`MULT_DATA_WIDTH - 1 : 0]  out,
`endif
   input                clk,
   input                rst_n
);
   parameter sig_width = 23;
   parameter exp_width = 8;
   parameter ieee_compliance = 1;

`ifdef MULTI_MULT
   logic [`MULT_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  real_opa, real_opb;
   logic [`MULT_ORDER - 1 : 0][2*`MULT_DATA_WIDTH - 1 : 0] real_out;
   logic [`MULT_DATA_WIDTH*`MULT_ORDER - 1 : 0]  out_w;
   logic [`MULT_ORDER - 1 : 0][7:0]    status_inst;
   genvar i;
   
   generate
      for (i = 0; i < `MULT_ORDER; i = i + 1 ) begin
         assign real_opa[i] = opa[`MULT_DATA_WIDTH*(i+1) - 1 : `MULT_DATA_WIDTH * i];
         assign real_opb[i] = opb[`MULT_DATA_WIDTH*(i+1) - 1 : `MULT_DATA_WIDTH * i];
//         assign real_out[i] = real_opa[i] * real_opb[i];
         DW_fp_mult #(sig_width, exp_width, ieee_compliance) U1 (
            .a(real_opa[i]),
            .b(real_opb[i]),
            .rnd(3'b0),
            .z(out_w[`MULT_DATA_WIDTH * (i+1) - 1 : `MULT_DATA_WIDTH * i]),
            .status(status_inst[i])
         );
//         assign out_w[2*`MULT_DATA_WIDTH*(i+1) - 1 : 2*`MULT_DATA_WIDTH *i] = real_out[i];
      end
   endgenerate
`endif

`ifndef MULTI_MULT
   logic [`MULT_DATA_WIDTH - 1 : 0]  out_w;
   logic [7:0] status_inst;
/*
   logic [`MULT_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0] out_pipe; 

   DW_fp_mult #(sig_width, exp_width, ieee_compliance) U1 (
      .a(opa),
      .b(opb),
      .rnd(3'b0),
      .z(out_pipe[0]),
      .status(status_inst)
   );
*/

   mult_pipe mp (
      .a(opa),
      .b(opb),
      .rnd(3'b0),
      .z(out_w),
      .status(status_inst),
      .clk(clk),
      .rst_n(rst_n)
   );
/*
   assign out_w = out_pipe[`MULT_ORDER - 1];
   integer i;

   always_ff @ (posedge clk or negedge rst_n) begin
      if (rst_n == 0) begin
         for (i = 0; i < `MULT_ORDER - 1; i = i + 1) begin
            out_pipe[i + 1] <= 0;
         end
      end
      else begin
         for (i = 0; i < `MULT_ORDER - 1; i = i + 1) begin
            out_pipe[i + 1] <= out_pipe[i];
         end
      end
   end
*/
`endif

   always_ff @ (posedge clk or negedge rst_n) begin
      if (rst_n == 0) begin
         out <= 0;
      end
      else begin
         out <= out_w;
      end
   end


endmodule
