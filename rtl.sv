`timescale 1ns/1ps

module pipeline_reg #(
  parameter int WIDTH = 32
) (
  input  logic              clk,
  input  logic              rst_n,       
  input  logic              in_valid,
  output logic              in_ready,
  input  logic [WIDTH-1:0]  in_data,
  output logic              out_valid,
  input  logic              out_ready,
  output logic [WIDTH-1:0]  out_data
);
  logic              valid_q;
  logic [WIDTH-1:0]  data_q;
  assign in_ready  = ~valid_q || out_ready;

  assign out_valid = valid_q;
  assign out_data  = data_q;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      valid_q <= 1'b0;
      data_q  <= '0;
    end else begin
      if (in_ready && in_valid) begin
        data_q  <= in_data;
        valid_q <= 1'b1;
      end
      else if (out_ready && valid_q && !in_valid) begin
        valid_q <= 1'b0;
      end
    end
  end

endmodule
