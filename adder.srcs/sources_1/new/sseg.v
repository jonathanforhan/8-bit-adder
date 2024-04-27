// 200MHz / 200kHz = 1kHz or 1ms refresh (per anode), 4ms total
`define ITER 200_000

module sseg_disp (
    input  wire [3:0] hex,
    output reg  [6:0] seg
);
  always @(*) begin
    case (hex)
      4'h0: seg[6:0] = 7'b1000000;  // digit 0
      4'h1: seg[6:0] = 7'b1111001;  // digit 1
      4'h2: seg[6:0] = 7'b0100100;  // digit 2
      4'h3: seg[6:0] = 7'b0110000;  // digit 3
      4'h4: seg[6:0] = 7'b0011001;  // digit 4
      4'h5: seg[6:0] = 7'b0010010;  // digit 5
      4'h6: seg[6:0] = 7'b0000010;  // digit 6
      4'h7: seg[6:0] = 7'b1111000;  // digit 7
      4'h8: seg[6:0] = 7'b0000000;  // digit 8
      4'h9: seg[6:0] = 7'b0010000;  // digit 9
      4'ha: seg[6:0] = 7'b0001000;  // digit A
      4'hb: seg[6:0] = 7'b0000011;  // digit B
      4'hc: seg[6:0] = 7'b1000110;  // digit C
      4'hd: seg[6:0] = 7'b0100001;  // digit D
      4'he: seg[6:0] = 7'b0000110;  // digit E
      default: seg[6:0] = 7'b0001110;  // digit F
    endcase
  end
endmodule

module sseg (
    input wire clk,
    input wire [7:0] sum,
    output reg [6:0] seg,
    output reg [3:0] an
);
  reg [19:0] rst = 0;
  wire [6:0] hi, lo, nil;

  sseg_disp sseg_lo (
      .hex(sum[3:0]),
      .seg(lo)
  );

  sseg_disp sseg_hi (
      .hex(sum[7:4]),
      .seg(hi)
  );

  sseg_disp sseg_nil (
      .hex(4'h0),
      .seg(nil)
  );

  // iterate the anode of 7-seg
  always @(posedge clk) begin
    if (rst < `ITER) begin
      an  <= 4'b1110;
      seg <= lo;
    end else if (rst < `ITER * 2) begin
      an  <= 4'b1101;
      seg <= hi;
    end else if (rst < `ITER * 3) begin
      an  <= 4'b1011;
      seg <= nil;
    end else begin
      an  <= 4'b0111;
      seg <= nil;
    end

    if (rst < `ITER * 4) rst <= rst + 1;
    else rst <= 0;
  end
endmodule
