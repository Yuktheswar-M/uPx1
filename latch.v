module clock(                   
    output reg clk
);
    initial
    clk=0;
    always  begin
    #5 clk=~clk;   
    end  
endmodule

module s_r_latch(
    input s,r,
    output q,qbar
);
    nand    n1(q,qbar,s),
       n2(qbar,q,r);
endmodule

module dlatch(
    input d,e,
    output q,qbar
);
    wire [2:0] t;
    nand    n1(t[0],d,e),
           n2(t[1],d),
           n3(t[2],t[1],e);
    s_r_latch sr1(t[0],t[2],q,qbar);
endmodule

module posdff_ti(                      
    input d,clk,set,clr,
    output q,qbar
);
    wire[3:0] t;
    nand  n1(t[0],set,t[1],t[3]),
            n2(t[1],clr,t[0],clk),
            n3(t[2],clk,t[1],t[3]),
            n4(t[3],clr,t[2],d),
            n5(q,set,t[1],qbar),
            n6(qbar,clr,t[2],q);
endmodule

module dffdm (
    input d_in,clk,set,clr,rd,rd_latch,sel,
    output q_out,q_vis                                  //q_vis to make contents visible for user
);  
    wire d,qbar;
    wire[6:1] t;
    and a2(t[1],sel,rd);            //read enable- wr enable in regs
    not n1(t[2],sel);
    or  o1(t[3],t[2],set),
        o2(t[4],t[2],clr);
    tristate  g2(q_vis,t[5],q_out);
    dlatch readlatch(t[1],rd_latch,t[5],t[6]);          // to read, set add,set rd,setrd_latch; remove rd_latch; do all ops
    posdff_ti D(d_in,clk,t[3],t[4],q_vis,qbar);         // set rd_latch, remove rd;remove rd_latch
endmodule

module dffpm (
    input d_in,clk,set,clr,
    output q_out
);
    wire qbar;
    posdff_ti D(d_in,clk,set,clr,q_out,qbar);
endmodule

