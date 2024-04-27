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
module adder (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
);
  wire [7:-1] c;
  assign c[-1] = cin;

  generate
    for (genvar i = 0; i < 8; i = i + 1) begin : gen_add8_block
      add1 add_bit (
          .a(a[i]),
          .b(b[i]),
          .cin(c[i-1]),
          .sum(sum[i]),
          .cout(c[i])
      );
    end
  endgenerate

  assign cout = c[7];
endmodule

