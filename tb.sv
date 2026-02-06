
`timescale 1ns/1ps

module pipeline_reg_tb;
  parameter int WIDTH = 32;
  parameter int TIMEOUT = 1000;

  logic              clk;
  logic              rst_n;
  logic              in_valid;
  logic              in_ready;
  logic [WIDTH-1:0]  in_data;
  logic              out_valid;
  logic              out_ready;
  logic [WIDTH-1:0]  out_data;

  pipeline_reg #(WIDTH) dut (.*);

  // Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  
  initial begin
  
    rst_n    = 0;
    in_valid  = 0;
    in_data   = 0;
    out_ready = 0;

    // Reset Sequence
    repeat (5) @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    /*Back-to-Back Transfers */
    out_ready = 1;
    for (int i = 0; i < 5; i++) begin
      in_valid = 1;
      in_data  = i + 10;
      do @(posedge clk); while (!in_ready);
    end
    in_valid = 0;

    repeat (4) @(posedge clk);
    out_ready = 0; 
    in_valid  = 1;
    in_data   = 32'hDEADBEEF;
    @(posedge clk);
    
   
    wait(in_ready == 0);
    in_valid = 0;
    repeat (5) @(posedge clk);
    
    
    out_ready = 1;
    @(posedge clk);

    /* Handshaking */
       repeat (50) begin
      @(posedge clk);
      in_valid  <= $urandom_range(0, 1);
      out_ready <= $urandom_range(0, 1);
      if (in_ready && in_valid) begin
        in_data <= $urandom;
      end
    end

      end

  
endmodule
