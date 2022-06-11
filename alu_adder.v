// Usage of universal gates are purely for convenience. Comment whatever is realised.
module halfadder (
    input a,b,
    output s,c
);
    xor x1(s,a,b);
    and a1(c,a,b);
endmodule

module CLAG8 (
    input[8:1] p,g,
    input      c_in,
    output[8:2]c,
    output     c_out
);
    wire w1[1:0],w2[2:0],w3[3:0],w4[4:0],w5[5:0],w6[6:0],w7[7:0],w8[8:0];
    nand    a1(w1[0],g[1]),
        a2(w1[1],p[1],c_in),
        a3(c[2],w1[0],w1[1]),                                               //SOP

        b1(w2[0],g[2]),
        b2(w2[1],p[2],g[1]),
        b3(w2[2],p[2],p[1],c_in),
        b4(c[3],w2[0],w2[1],w2[2]),                                         //SOP

        c1(w3[0],g[3]),
        c2(w3[1],p[3],g[2]),
        c3(w3[2],p[3],p[2],g[1]),
        c4(w3[3],p[3],p[2],p[1],c_in),
        c5(c[4],w3[0],w3[1],w3[2],w3[3]),                                   //SOP

        d1(w4[0],g[4]),
        d2(w4[1],p[4],g[3]),
        d3(w4[2],p[4],p[3],g[2]),
        d4(w4[3],p[4],p[3],p[2],g[1]),
        d5(w4[4],p[4],p[3],p[2],p[1],c_in),
        d6(c[5],w4[0],w4[1],w4[2],w4[3],w4[4]),                             //SOP

        e1(w5[0],g[5]),
        e2(w5[1],p[5],g[4]),
        e3(w5[2],p[5],p[4],g[3]),
        e4(w5[3],p[5],p[4],p[3],g[2]),
        e5(w5[4],p[5],p[4],p[3],p[2],g[1]),
        e6(w5[5],p[5],p[4],p[3],p[2],p[1],c_in),
        e7(c[6],w5[0],w5[1],w5[2],w5[3],w5[4],w5[5]),                       //SOP

        f1(w6[0],g[6]),
        f2(w6[1],p[6],g[5]),
        f3(w6[2],p[6],p[5],g[4]),
        f4(w6[3],p[6],p[5],p[4],g[3]),
        f5(w6[4],p[6],p[5],p[4],p[3],g[2]),
        f6(w6[5],p[6],p[5],p[4],p[3],p[2],g[1]),
        f7(w6[6],p[6],p[5],p[4],p[3],p[2],p[1],c_in),
        f8(c[7],w6[0],w6[1],w6[2],w6[3],w6[4],w6[5],w6[6]),                 //SOP

        g1(w7[0],g[7]),
        g2(w7[1],p[7],g[6]),
        g3(w7[2],p[7],p[6],g[5]),
        g4(w7[3],p[7],p[6],p[5],g[4]),
        g5(w7[4],p[7],p[6],p[5],p[4],g[3]),
        g6(w7[5],p[7],p[6],p[5],p[4],p[3],g[2]),
        g7(w7[6],p[7],p[6],p[5],p[4],p[3],p[2],g[1]),
        g8(w7[7],p[7],p[6],p[5],p[4],p[3],p[2],p[1],c_in),
        g9(c[8],w7[0],w7[1],w7[2],w7[3],w7[4],w7[5],w7[6],w7[7]),           //SOP

        h1(w8[0],g[8]),
        h2(w8[1],p[8],g[7]),
        h3(w8[2],p[8],p[7],g[6]),
        h4(w8[3],p[8],p[7],p[6],g[5]),
        h5(w8[4],p[8],p[7],p[6],p[5],g[4]),
        h6(w8[5],p[8],p[7],p[6],p[5],p[4],g[3]),
        h7(w8[6],p[8],p[7],p[6],p[5],p[4],p[3],g[2]),
        h8(w8[7],p[8],p[7],p[6],p[5],p[4],p[3],p[2],g[1]),
        h9(w8[8],p[8],p[7],p[6],p[5],p[4],p[3],p[2],p[1],c_in),
        h10(c_out,w8[0],w8[1],w8[2],w8[3],w8[4],w8[5],w8[6],w8[7],w8[8]);    //SOP

endmodule

module add8 (                     //in and out variables separated from 'internal' ones by tristates
    input[8:1] a_in,b_in,
    input      c_in,en,           //c_in- 0        
    output[8:1]s_out,
    output c_out     
);
    wire[8:1] a,b,s,p,g;                                
    wire[8:2] c;
    wire c9;
    tristate a1(a_in[1],en,a[1]),
        a2(a_in[2],en,a[2]),
        a3(a_in[3],en,a[3]),
        a4(a_in[4],en,a[4]),
        a5(a_in[5],en,a[5]),
        a6(a_in[6],en,a[6]),
        a7(a_in[7],en,a[7]),
        a8(a_in[8],en,a[8]),
        b1(b_in[1],en,b[1]),
        b2(b_in[2],en,b[2]),
        b3(b_in[3],en,b[3]),
        b4(b_in[4],en,b[4]),
        b5(b_in[5],en,b[5]),
        b6(b_in[6],en,b[6]),
        b7(b_in[7],en,b[7]),
        b8(b_in[8],en,b[8]),
        s1(s[1],en,s_out[1]),
        s2(s[2],en,s_out[2]),
        s3(s[3],en,s_out[3]),
        s4(s[4],en,s_out[4]),
        s5(s[5],en,s_out[5]),
        s6(s[6],en,s_out[6]),
        s7(s[7],en,s_out[7]),
        s8(s[8],en,s_out[8]), 
        s9(c9,en,c_out);
    halfadder h1(a[1],b[1],p[1],g[1]),
        h2(a[2],b[2],p[2],g[2]),
        h3(a[3],b[3],p[3],g[3]),
        h4(a[4],b[4],p[4],g[4]),
        h5(a[5],b[5],p[5],g[5]),
        h6(a[6],b[6],p[6],g[6]),
        h7(a[7],b[7],p[7],g[7]),
        h8(a[8],b[8],p[8],g[8]);
    CLAG8 c1(p,g,c_in,c,c9);
    xor x1(s[1],p[1],c_in),
        x2(s[2],p[2],c[2]),
        x3(s[3],p[3],c[3]),
        x4(s[4],p[4],c[4]),
        x5(s[5],p[5],c[5]),
        x6(s[6],p[6],c[6]),
        x7(s[7],p[7],c[7]),
        x8(s[8],p[8],c[8]);
  
endmodule

module sub8 (
    input[8:1] a_in,b_in,
    input      c_in,en,          //c_in - 1
    output[8:1]d_out,
    output c_out                 // subtract with carry- set when a>=b
);
    wire[8:1] b1;
    xor x1(b1[1],b_in[1],c_in),                 //1's complement of B. 1 added using c_in
        x2(b1[2],b_in[2],c_in),
        x3(b1[3],b_in[3],c_in),
        x4(b1[4],b_in[4],c_in),
        x5(b1[5],b_in[5],c_in),
        x6(b1[6],b_in[6],c_in),
        x7(b1[7],b_in[7],c_in),
        x8(b1[8],b_in[8],c_in);
    add8 subtr(a_in,b1,c_in,en,d_out,c_out);    
endmodule
