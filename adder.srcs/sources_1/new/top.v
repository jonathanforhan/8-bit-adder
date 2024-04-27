`timescale 1ns / 1ps  //
`default_nettype none

/// add 1 bit
module add1 (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
  wire c = a ^ b;
  assign sum  = c ^ cin;
  assign cout = (a & b) | (c & cin);
endmodule

/// add 8 bits
module add8 (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
);
  wire [7:-1] c;
  assign c[-1] = cin;

  generate
    for (genvar i = 0; i < 8; i = i + 1) begin : add8_block
      add1 add_bit (
          a[i],
          b[i],
          c[i-1],
          sum[i],
          c[i]
      );
    end
  endgenerate

  assign cout = c[7];
endmodule

module top (
    input  wire [15:0] sw,
    output wire [ 7:0] led
);
  wire cout;
  add8 add_8bits (
      sw[7:0],
      sw[15:8],
      0,
      led[7:0],
      cout
  );
  // assign led[8] = cout;
endmodule
