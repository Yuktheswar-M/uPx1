// Usage of universal gates are purely for convenience. Comment whatever is realised.
module halfadder (
    input a,b,
    output s,cy
);
    xor  x1(s,a,b);
    and  a1(cy,a,b);
endmodule

module CLAG8 (
    input[8:1] p,g,
    input      c_in,
    output[8:2]cy,
    output     c_fin
);
    wire w1[1:0],w2[2:0],w3[3:0],w4[4:0],w5[5:0],w6[6:0],w7[7:0],w8[8:0];
    nand     a1(w1[0],g[1]),
        a2(w1[1],p[1],c_in),
        a3(cy[2],w1[0],w1[1]),                                               //SOP

        b1(w2[0],g[2]),
        b2(w2[1],p[2],g[1]),
        b3(w2[2],p[2],p[1],c_in),
        b4(cy[3],w2[0],w2[1],w2[2]),                                         //SOP

        c1(w3[0],g[3]),
        c2(w3[1],p[3],g[2]),
        c3(w3[2],p[3],p[2],g[1]),
        c4(w3[3],p[3],p[2],p[1],c_in),
        c5(cy[4],w3[0],w3[1],w3[2],w3[3]),                                   //SOP

        d1(w4[0],g[4]),
        d2(w4[1],p[4],g[3]),
        d3(w4[2],p[4],p[3],g[2]),
        d4(w4[3],p[4],p[3],p[2],g[1]),
        d5(w4[4],p[4],p[3],p[2],p[1],c_in),
        d6(cy[5],w4[0],w4[1],w4[2],w4[3],w4[4]),                             //SOP

        e1(w5[0],g[5]),
        e2(w5[1],p[5],g[4]),
        e3(w5[2],p[5],p[4],g[3]),
        e4(w5[3],p[5],p[4],p[3],g[2]),
        e5(w5[4],p[5],p[4],p[3],p[2],g[1]),
        e6(w5[5],p[5],p[4],p[3],p[2],p[1],c_in),
        e7(cy[6],w5[0],w5[1],w5[2],w5[3],w5[4],w5[5]),                       //SOP

        f1(w6[0],g[6]),
        f2(w6[1],p[6],g[5]),
        f3(w6[2],p[6],p[5],g[4]),
        f4(w6[3],p[6],p[5],p[4],g[3]),
        f5(w6[4],p[6],p[5],p[4],p[3],g[2]),
        f6(w6[5],p[6],p[5],p[4],p[3],p[2],g[1]),
        f7(w6[6],p[6],p[5],p[4],p[3],p[2],p[1],c_in),
        f8(cy[7],w6[0],w6[1],w6[2],w6[3],w6[4],w6[5],w6[6]),                 //SOP

        g1(w7[0],g[7]),
        g2(w7[1],p[7],g[6]),
        g3(w7[2],p[7],p[6],g[5]),
        g4(w7[3],p[7],p[6],p[5],g[4]),
        g5(w7[4],p[7],p[6],p[5],p[4],g[3]),
        g6(w7[5],p[7],p[6],p[5],p[4],p[3],g[2]),
        g7(w7[6],p[7],p[6],p[5],p[4],p[3],p[2],g[1]),
        g8(w7[7],p[7],p[6],p[5],p[4],p[3],p[2],p[1],c_in),
        g9(cy[8],w7[0],w7[1],w7[2],w7[3],w7[4],w7[5],w7[6],w7[7]),           //SOP

        h1(w8[0],g[8]),
        h2(w8[1],p[8],g[7]),
        h3(w8[2],p[8],p[7],g[6]),
        h4(w8[3],p[8],p[7],p[6],g[5]),
        h5(w8[4],p[8],p[7],p[6],p[5],g[4]),
        h6(w8[5],p[8],p[7],p[6],p[5],p[4],g[3]),
        h7(w8[6],p[8],p[7],p[6],p[5],p[4],p[3],g[2]),
        h8(w8[7],p[8],p[7],p[6],p[5],p[4],p[3],p[2],g[1]),
        h9(w8[8],p[8],p[7],p[6],p[5],p[4],p[3],p[2],p[1],c_in),
        h10(c_fin,w8[0],w8[1],w8[2],w8[3],w8[4],w8[5],w8[6],w8[7],w8[8]);    //SOP

endmodule

module add8 (                     //in and out variables separated from 'internal' ones by tristates
    input[8:1] a_in,b_in,
    input     c_in, en,           //c_in- 0        
    output[8:1]s_out,
    output carry,zero,negative,overflow,sign     
);
    wire[8:1] a,b,s,p,g;                                
    wire[8:2] cy;
    wire c,z,n,v,sg;
    wire Rd7b,Rr7b,R7b,t1,t2;
    supply0 GND;

    tristate a0[8:1](a_in,en,a),
             b0[8:1](b_in,en,b),
             s0(s[1],en,s_out[1]),
             s1(s[2],en,s_out[2]),
             s2(s[3],en,s_out[3]),
             s3(s[4],en,s_out[4]),
             s4(s[5],en,s_out[5]),
             s5(s[6],en,s_out[6]),
             s6(s[7],en,s_out[7]),
             s7(s[8],en,s_out[8]), 
             f[5:1]({c,z,n,v,sg},en,{carry,zero,negative,overflow,sign});
    halfadder hf[8:1](a,b,p,g);
    xor  xo[8:1](s,p,{cy,c_in});

    CLAG8 c1(p,g,c_in,cy,c);   //carry    
    nor na(z,s[8],s[7],s[6],s[5],s[4],s[3],s[2],s[1]); //zero
    buf bu(n,s[8]);             //negative
    not no1(R7b,s[8]),                  //overflow
        no2(Rr7b,b[8]),
        no3(Rd7b,a[8]);
    and ov1(t1,R7b,a[8],b[8]),
        ov2(t2,s[8],Rd7b,Rr7b);
    or  ov3(v,t1,t2);
    xor sgn(sg,n,v);            //sign
endmodule

module sub8 (
    input[8:1] a_in,b_in,
    input      en,          //c_in - 1
    output[8:1]d_out,
    output carry,zero,negative,overflow,sign                
);
    wire[8:1] b1;
    supply1 VCC;
    wire carrybar,c;
    xor  xo[8:1](b1,b_in,VCC);                 //1's complement of B. 1 added using c_in
    add8 subtr(a_in,b1,VCC,en,d_out,carrybar,zero,negative,overflow,sign);    
    not no(c,carrybar);
    tristate tt(c,en,carry);
endmodule

module comparator (                      //in and out variables separated from 'internal' ones by tristates
    input[8:1] a_in,b_in,
    input      en, 
    output[8:1] a_out,
    output     eq_out 
);  
    wire eq;
    wire[8:1] t,a,b;
    tristate a0[8:1](a_in,en,a),
             b0[8:1](b_in,en,b),
             a1[8:1](a   ,en,a_out),
             t1(eq,en,eq_out);                //Output connected to flag only when enabled
    xor x1[8:1](t,a,b);
    nor n1(eq  ,t[1],t[2],t[3],t[4],t[5],t[6],t[7],t[8]);
                                        
endmodule

module bwand8 (
    input[8:1] a_in,b_in,
    input      en,
    output[8:1] c_out, 
    output    zero,negative
);
    wire eq,z,n;
    wire[8:1] t,a,b;
    tristate aa[8:1](a_in,en,a),
             bb[8:1](b_in,en,b),
             cc[8:1](t   ,en,c_out),
             f[2:1] ({z,n},en,{zero,negative}); 
    and fn[8:1](t,a,b);

    nor na(z,t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1]); //zero
    buf bu(n,t[8]);             //negative
endmodule

module bwor8 (
    input[8:1] a_in,b_in,
    input      en,
    output[8:1] c_out, 
    output    zero,negative
);
    wire eq,z,n;
    wire[8:1] t,a,b;
    tristate aa[8:1](a_in,en,a),
             bb[8:1](b_in,en,b),
             cc[8:1](t   ,en,c_out),
             f[2:1] ({z,n},en,{zero,negative}); 
    or fn[8:1](t,a,b);

    nor na(z,t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1]); //zero
    buf bu(n,t[8]);             //negative
endmodule

module bwxor8 (
    input[8:1] a_in,b_in,
    input      en,
    output[8:1] c_out, 
    output    zero,negative
);
    wire eq,z,n;
    wire[8:1] t,a,b;
    tristate aa[8:1](a_in,en,a),
             bb[8:1](b_in,en,b),
             cc[8:1](t   ,en,c_out),
             f[2:1] ({z,n},en,{zero,negative}); 
    xor fn[8:1](t,a,b);

    nor na(z,t[8],t[7],t[6],t[5],t[4],t[3],t[2],t[1]); //zero
    buf bu(n,t[8]);             //negative
endmodule

module shifter (
    input[7:0] d_in,
    input clk,en,                               //only to write into databus
    input[1:0] shftd_out_en,                    //00- disabled; 01-shifted_r enabled; 10-shifted_l enabled;
    output[7:0] q_out,
    output zero,negative,shifted_r,shifted_l
);
    wire[7:0] not_out,q_out;
    supply0 GND;
    supply1 VCC;

    wire z,n;

    tristate f[1:0] ({z,n},en,{zero,negative}),
             rr     ( q_out[0],shftd_out_en[0],shifted_r),
             ll     ( q_out[7],shftd_out_en[1],shifted_l);
    
    posdff_ti   b[7:0](d_in,clk,VCC,VCC,q_out,not_out);
    
    nor na(z,q_out[8],q_out[7],q_out[6],q_out[5],q_out[4],q_out[3],q_out[2],q_out[1]); //zero
    buf  bu(n,q_out[8]);             //negative
endmodule
