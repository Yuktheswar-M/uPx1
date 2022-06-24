
module mux2to1 (
    input [1:0] in,
    input sel,
    output out
);
    wire [1:0] w;
    wire n;
    nand  g1(n,sel),
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
    mux2to1 M211(in[1:0],sel[0],t[0]),
         M212(in[3:2],sel[0],t[1]),
         M213(t,sel[1],out);
endmodule

module mux8to1 (
    input [7:0] in,
    input [2:0] sel,
    output out
);
    wire [1:0] t;
    mux4to1 M411(in[3:0],sel[1:0],t[0]),
         M412(in[7:4],sel[1:0],t[1]);
    mux2to1 M211(t,sel[2],out);
endmodule

module mux16to1(
    input [15:0] in,
    input [3:0] sel,
    output out
);
    wire [3:0] t;
    mux4to1 M411(in[3:0],sel[1:0],t[0]),
     M412(in[7:4],sel[1:0],t[1]),
     M413(in[11:8],sel[1:0],t[2]),
     M414(in[15:12],sel[1:0],t[3]),
     M415(t,sel[3:2],out);
endmodule

module tristate (
    input in,en,
    output out
);
  assign  out=en?in:1'bz;  
endmodule

module demux1to2 (
    input in,sel,
    output [1:0] out
);
    wire[2:0] t;
    nand     n1(t[0],sel),
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
    demux1to2 D121(in,sel[1],t),
            D122(t[0],sel[0],out[1:0]),
            D123(t[1],sel[0],out[3:2]);    
endmodule

module demux1to8 (
    input in,
    input[2:0] sel,
    output[7:0] out
);
    wire[1:0] t;
    demux1to2 D141(in  ,sel[2],t);
    demux1to4 D121(t[0],sel[1:0],out[3:0]),
              D122(t[1],sel[1:0],out[7:4]);    
endmodule

module demux1to16 (
    input in,
    input[3:0] sel,
    output[15:0] out
);
    wire[3:0] t;
    demux1to4 D141(in,sel[3:2],t),
            D142(t[0],sel[1:0],out[3:0]),
            D143(t[1],sel[1:0],out[7:4]),
            D144(t[2],sel[1:0],out[11:8]),
            D145(t[3],sel[1:0],out[15:12]);
endmodule

module demux1to256 (
    input in,
    input[7:0] sel,
    output[255:0] out
);
    wire[15:0] t;
    demux1to16 D1161(in,sel[7:4],t);
    genvar i;
    generate 
        for(i=0;i<16;i=i+1) begin: dm1_256
        demux1to16 d_i(t[i],sel[3:0],out[15+16*i:16*i]);    
        end
    endgenerate 
endmodule

module demux1to1024 (
    input in,
    input[9:0] sel,
    output[1023:0] out
);
    wire[3:0] t;
    demux1to4 D141(in,sel[9:8],t);
    genvar i;
    generate
        for(i=0;i<4;i=i+1) begin: dm1_1024
          demux1to256 D256(t[i],sel[7:0],out[255+256*i:256*i]);  
        end    
    endgenerate
endmodule

