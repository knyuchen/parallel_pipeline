module mult_pipe (
   input                clk,
   input                rst_n,
   input [`MULT_DATA_WIDTH - 1 : 0]  a,
   input [`MULT_DATA_WIDTH - 1 : 0]  b,
   output logic [`MULT_DATA_WIDTH - 1 : 0]  z,
   input [2:0]          rnd,
   output logic [7:0]         status
);

parameter sig_width       = 23;
parameter exp_width       = 8;
parameter ieee_compliance = 1;
parameter op_iso_mode     = 0;
parameter id_width        = $clog2(`MULT_ORDER) + 1;
parameter in_reg          = 0;
parameter stages          = `MULT_ORDER;
parameter out_reg         = 0;
parameter no_pm           = 1;
parameter rst_mode        = 0;

   logic launch, pipe_full, pipe_ovf, accept_n, arrive, push_out_n;
   logic [id_width - 1 : 0] launch_id, arrive_id;
   logic [(((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>256)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4096)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16384)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32768)?16:15):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8192)?14:13)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>1024)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2048)?12:11):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>512)?10:9))):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>64)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>128)?8:7):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32)?6:5)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8)?4:3):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2)?2:1)))))-1:0] pipe_census; // Pipe Stages Occupied Output
   
   assign launch = 1;
   assign launch_id = 0;
   assign accept_n = 0;    
   


   DW_lp_piped_fp_mult #(sig_width, exp_width, ieee_compliance, op_iso_mode, id_width, in_reg, stages, out_reg, no_pm, rst_mode) U1 (
      .clk(clk),
      .rst_n(rst_n),
      .a(a),
      .b(b),
      .z(z),
      .rnd(rnd),
      .status(status),
      .launch(launch),
      .pipe_full(pipe_full),
      .pipe_ovf(pipe_ovf),
      .accept_n(accept_n),
      .arrive(arrive),
      .push_out_n(push_out_n),
      .launch_id(launch_id),
      .arrive_id(arrive_id),
      .pipe_census(pipe_census)
   );
endmodule
