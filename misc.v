
module mux2to1 (
    input [1:0] in,
    input sel,
    output out
);
    wire [1:0] w;
    wire n;
    nand g1(n,sel),
     g2(w[0],in[0],n),
     g3(w[1],in[1],sel),
     g4(out,w[0],w[1]);
endmodule

module mux4to1(
    input [3:0] in,
    input [1:0] sel,
    output out
);
    wire [1:0] t;
    mux2to1 m1(in[1:0],sel[0],t[0]),
         m2(in[3:2],sel[0],t[1]),
         m3(t,sel[1],out);
endmodule

module mux16to1(
    input [15:0] in,
    input [3:0] sel,
    output out
);
    wire [3:0] t;
    mux4to1 M1(in[3:0],sel[1:0],t[0]),
     M2(in[7:4],sel[1:0],t[1]),
     M3(in[11:8],sel[1:0],t[2]),
     M4(in[15:12],sel[1:0],t[3]),
     M5(t,sel[3:2],out);
endmodule

module tristate (
    input in,en,
    output out
);
  assign out=en?in:1'bz;  
endmodule

module demux1to2 (
    input in,sel,
    output [1:0] out
);
    wire[2:0] t;
    nand    n1(t[0],sel),
        n2(t[1],in,t[0]),
        n3(t[2],in,sel),
        n4(out[0],t[1]),
        n5(out[1],t[2]);    
endmodule

module demux1to4 (
    input in,
    input[1:0] sel,
    output[3:0] out
);
    wire[1:0] t;
    demux1to2 d1(in,sel[1],t),
            d2(t[0],sel[0],out[1:0]),
            d3(t[1],sel[0],out[3:2]);    
endmodule