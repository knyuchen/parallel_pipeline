module mult (
   input          [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  opa,
   input          [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  opb,
   output logic   [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  out,
   input                clk,
   input                rst_n
);

   logic [`PARALLEL_ORDER - 1 : 0][`MULT_DATA_WIDTH - 1 : 0]  out_w;
   logic [`PARALLEL_ORDER - 1 : 0][7:0]    status_inst;
   genvar i;
   
   generate
      for (i = 0; i < `PARALLEL_ORDER; i = i + 1 ) begin
         mult_pipe mp (
            .a(opa[i]),
            .b(opb[i]),
            .rnd(3'b0),
            .z(out_w[i]),
            .status(status_inst[i]),
            .clk(clk),
            .rst_n(rst_n)
         );
      end
   endgenerate


   always_ff @ (posedge clk or negedge rst_n) begin
      if (rst_n == 0) begin
         out <= 0;
      end
      else begin
         out <= out_w;
      end
   end


endmodule
