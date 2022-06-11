module comparator (                      //in and out variables separated from 'internal' ones by tristates
    input[8:1] a_in,b_in,
    input      en, 
    output     eq_out 
);  
    wire eq;
    wire[8:1] t,a,b;
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
        t1(eq,en,eq_out);                //Output connected to flag only when enabled
    xor x1(t[1],a[1],b[1]),
        x2(t[2],a[2],b[2]),
        x3(t[3],a[3],b[3]),
        x4(t[4],a[4],b[4]),
        x5(t[5],a[5],b[5]),
        x6(t[6],a[6],b[6]),
        x7(t[7],a[7],b[7]),
        x8(t[8],a[8],b[8]);
    nor n1(eq  ,t[1],t[2],t[3],t[4],t[5],t[6],t[7],t[8]);
                                        
endmodule