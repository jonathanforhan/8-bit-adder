`timescale 1ns / 1ps  //
`default_nettype none  //

`include "adder.v"
`include "sseg.v"

module top (
    input  wire        clk,  // 100MHz clock
    input  wire [15:0] sw,   // switches
    output wire [ 7:0] led,  // leds
    output wire [ 6:0] seg,  // cathode 7-segment
    output wire [ 3:0] an    // anode 7-segment, NOTE LOW is ON for an anode
);
  //--------------------------------------------------------------------------//
  // adder
  //--------------------------------------------------------------------------//
  wire [7:0] sum;
  wire cout;

  adder add_8bits (
      .a(sw[7:0]),
      .b(sw[15:8]),
      .cin(0),
      .sum(sum),
      .cout(cout)
  );

  //--------------------------------------------------------------------------//
  // display
  //--------------------------------------------------------------------------//
  assign led = sum;

  sseg sseg_inst (
      .clk(clk),
      .sum(sum),
      .seg(seg),
      .an (an)
  );
endmodule
