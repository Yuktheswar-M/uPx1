
module MOV (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr  
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w;
    wire[1:0] t;
    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r ,en,rd),
             t4(rl,en,rd_latch),
             t5(w ,en,wr);

    or  o1(mod,m[0],m[1],m[2]),         //controls PC
        ss2(t[0],m[0],m[2]),        //FF input when enabled
        ss1(t[1],m[1],m[2]);

    or  o2(ldvr[2],m[0],m[3]),
        o3 (ldvr[1],m[0],m[1],m[3]),
        o4 (ldvr[0],m[0],m[2],m[3]),
        o5 (rl     ,m[0],m[1],m[3]),
        o6 (r      ,m[1],m[2]),
        o7 (w      ,m[2]);     

endmodule

module AND (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[0],m[2],m[4],m[5],m[6]),
        o1(ldvr[1],m[0],m[2],m[3],m[4],m[5],m[6]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[1],m[3],m[5],m[6]),
        o4(r      ,m[1],m[2],m[3],m[4],m[6],m[7]),
        o5(w      ,m[2],m[4],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o7(fs_ca[1],m[7]),
        o8(adr[1] ,m[5],m[6]),
        o9(adr[0] ,m[4]),
        o0(ad_en  ,m[2],m[4],m[5],m[6]),
        oo(aw     ,m[5],m[6]);
endmodule

module OR (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[0],m[2],m[4],m[5],m[6]),
        o1(ldvr[1],m[0],m[2],m[3],m[4],m[5],m[6]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[1],m[3],m[5],m[6]),
        o4(r      ,m[1],m[2],m[3],m[4],m[6],m[7]),
        o5(w      ,m[2],m[4],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o7[1:0](fs_ca[1:0],m[7]),
        o8(adr[1] ,m[5],m[6]),
        o9(adr[0] ,m[4]),
        o0(ad_en  ,m[2],m[4],m[5],m[6]),
        oo(aw     ,m[5],m[6]);
endmodule

module ADD (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[0],m[2],m[4],m[5],m[6]),
        o1(ldvr[1],m[0],m[2],m[3],m[4],m[5],m[6]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[1],m[3],m[5],m[6]),
        o4(r      ,m[1],m[2],m[3],m[4],m[6],m[7]),
        o5(w      ,m[2],m[4],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o7(fs_ca[2],m[7]),
        o8(adr[1] ,m[5],m[6]),
        o9(adr[0] ,m[4]),
        o0(ad_en  ,m[2],m[4],m[5],m[6]),
        oo(aw     ,m[5],m[6]);
endmodule

module SUB (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[0],m[2],m[4],m[5],m[6]),
        o1(ldvr[1],m[0],m[2],m[3],m[4],m[5],m[6]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[1],m[3],m[5],m[6]),
        o4(r      ,m[1],m[2],m[3],m[4],m[6],m[7]),
        o5(w      ,m[2],m[4],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o7[1:0]({fs_ca[2],fs_ca[0]},m[7]),
        o8(adr[1] ,m[5],m[6]),
        o9(adr[0] ,m[4]),
        o0(ad_en  ,m[2],m[4],m[5],m[6]),
        oo(aw     ,m[5],m[6]);
endmodule

module XOR (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[0],m[2],m[4],m[5],m[6]),
        o1(ldvr[1],m[0],m[2],m[3],m[4],m[5],m[6]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[1],m[3],m[5],m[6]),
        o4(r      ,m[1],m[2],m[3],m[4],m[6],m[7]),
        o5(w      ,m[2],m[4],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o7[1:0](fs_ca[2:1],m[7]),
        o8(adr[1] ,m[5],m[6]),
        o9(adr[0] ,m[4]),
        o0(ad_en  ,m[2],m[4],m[5],m[6]),
        oo(aw     ,m[5],m[6]);
endmodule

module CMP (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[0],m[2],m[4],m[5],m[6]),
        o1(ldvr[1],m[0],m[2],m[3],m[4],m[5],m[6]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[1],m[3],m[5],m[6]),
        o4(r      ,m[1],m[2],m[3],m[4],m[6],m[7]),
        o5(w      ,m[2],m[4],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o7[2:0](fs_ca,m[7]),
        o8(adr[1] ,m[5],m[6]),
        o9(adr[0] ,m[4]),
        o0(ad_en  ,m[2],m[4],m[5],m[6]),
        oo(aw     ,m[5],m[6]);
endmodule

module CLR (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,                // only lsb
    output clr
);  
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr;
    wire mod;
    wire cl;
    wire[1:0] t;

    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(cl,en,clr);

    or  o1(mod,sb0,sb1),         //controls PC
        o2(t[0],sb0,GND);        //FF input when enabled
    xor x1(t[1],s0 , s1);

    or  o3(cl , s0,sb1);            
    nor n1(ldvr[0],s0,s1),
        n2(ldvr[2],s0,s1);

endmodule

module NEG (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,data_0,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en,dat0,d_en;
    wire[7:0] m;
    
    demux1to8 DM(VCC,{s2,s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    or  ss1(t[0],m[0],m[2],m[4]),
        ss2(t[1],m[1],m[2]),
        ss3(t[2],m[3],m[4]);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write),
             t9(dat0,d_en,data_0);
    or  o1(r,m[1],m[2],m[4],m[5]),
        o2(rl,m[0],m[1],m[3],m[4]),
        o3(w,m[2],m[3],m[5]),
        o4(ldvr[1],VCC),
        o5[1:0]({ldvr[2],ldvr[0]},m[0],m[2],m[3],m[4]),
        o6(adr[0],m[2]),
        o7(adr[1],m[4]),
        o8(ad_en,m[2],m[3],m[4]),
        o9(aw,m[3],m[4],m[5]),
        o0(mod,m[0],m[1],m[2],m[3],m[4]),
        oo(dat0,GND),
        oa(fs_ca[1],VCC),
        ob[1:0]({fs_ca[2],fs_ca[0]},m[5]),
        oc(d_en,m[3]); 
   
endmodule

module SLL (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,shft_wr,alu_write,
    output[2:0] fs_shft
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr,fsht;
    wire mod;
    wire r,rl,w,shwr,aw;
    wire[1:0] t;

    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r ,en,rd),
             t4(rl,en,rd_latch),
             t5(w ,en,wr),
             t6[2:0](fsht,en,fs_shft),
             t7(shwr,en,shft_wr),
             t8(aw,en,alu_write);
    or  ss1(t[1],m[1],m[2]),
        ss2(t[0],m[0],m[2]);
    or  o1(r,m[1]),
        o2(rl,m[0],m[1],m[2],m[3]),
        o3(w,m[3]),
        o4(shwr,m[3]),
        o5(fsht[2],m[0],m[1]),
        o6(fsht[1],m[0],m[2]),
        os(fsht[0],m[0],m[1]),
        o7[1:0]({ldvr[2],ldvr[0]},m[0]),
        o8(ldvr[1],m[0],m[1],m[2],m[3]),
        o9(mod,m[0],m[1],m[2]),
        oo(aw,m[2]);
endmodule

module SLR (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,shft_wr,alu_write,
    output[2:0] fs_shft
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr,fsht;
    wire mod;
    wire r,rl,w,shwr,aw;
    wire[1:0] t;

    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r ,en,rd),
             t4(rl,en,rd_latch),
             t5(w ,en,wr),
             t6[2:0](fsht,en,fs_shft),
             t7(shwr,en,shft_wr),
             t8(aw,en,alu_write);
    or  ss1(t[1],m[1],m[2]),
        ss2(t[0],m[0],m[2]);
    or  o1(r,m[1]),
        o2(rl,m[0],m[1],m[2],m[3]),
        o3(w,m[3]),
        o4(shwr,m[3]),
        o5(fsht[2],m[0],m[1]),
        o6(fsht[1],m[0]),
        os(fsht[0],m[0],m[1],m[2]),
        o7[1:0]({ldvr[2],ldvr[0]},m[0]),
        o8(ldvr[1],m[0],m[1],m[2],m[3]),
        o9(mod,m[0],m[1],m[2]),
        oo(aw,m[2]);
endmodule

module ROL (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,shft_wr,alu_write,
    output[2:0] fs_shft
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr,fsht;
    wire mod;
    wire r,rl,w,shwr,aw;
    wire[1:0] t;

    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r ,en,rd),
             t4(rl,en,rd_latch),
             t5(w ,en,wr),
             t6[2:0](fsht,en,fs_shft),
             t7(shwr,en,shft_wr),
             t8(aw,en,alu_write);
    or  ss1(t[1],m[1],m[2]),
        ss2(t[0],m[0],m[2]);
    or  o1(r,m[1]),
        o2(rl,m[0],m[1],m[2],m[3]),
        o3(w,m[3]),
        o4(shwr,m[3]),
        o5(fsht[2],m[0],m[1],m[2]),
        o6(fsht[1],m[0]),
        os(fsht[0],m[0],m[1]),
        o7[1:0]({ldvr[2],ldvr[0]},m[0]),
        o8(ldvr[1],m[0],m[1],m[2],m[3]),
        o9(mod,m[0],m[1],m[2]),
        oo(aw,m[2]);
endmodule

module ROR (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,shft_wr,alu_write,
    output[2:0] fs_shft
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr,fsht;
    wire mod;
    wire r,rl,w,shwr,aw;
    wire[1:0] t;

    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r ,en,rd),
             t4(rl,en,rd_latch),
             t5(w ,en,wr),
             t6[2:0](fsht,en,fs_shft),
             t7(shwr,en,shft_wr),
             t8(aw,en,alu_write);
    or  ss1(t[1],m[1],m[2]),
        ss2(t[0],m[0],m[2]);
    or  o1(r,m[1]),
        o2(rl,m[0],m[1],m[2],m[3]),
        o3(w,m[3]),
        o4(shwr,m[3]),
        o5(fsht[2],m[0],m[1]),
        o6(fsht[1],m[0],m[2]),
        os(fsht[0],m[0],m[1],m[2]),
        o7[1:0]({ldvr[2],ldvr[0]},m[0]),
        o8(ldvr[1],m[0],m[1],m[2],m[3]),
        o9(mod,m[0],m[1],m[2]),
        oo(aw,m[2]);
endmodule

module INC (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,data_0,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en,dat0,d_en;
    wire[7:0] m;
    
    demux1to8 DM(VCC,{s2,s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    or  ss1(t[0],m[0],m[2],m[4]),
        ss2(t[1],m[1],m[2]),
        ss3(t[2],m[3],m[4]);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write),
             t9(dat0,d_en,data_0);
    or  o1(r,m[1],m[2],m[4],m[5]),
        o2(rl,m[0],m[1],m[3],m[4]),
        o3(w,m[2],m[3],m[5]),
        o4(ldvr[1],VCC),
        o5[1:0]({ldvr[2],ldvr[0]},m[0],m[2],m[3],m[4]),
        o6(adr[0],m[2]),
        o7(adr[1],m[4]),
        o8(ad_en,m[2],m[3],m[4]),
        o9(aw,m[3],m[4],m[5]),
        o0(mod,m[0],m[1],m[2],m[3],m[4]),
        oo(dat0,m[3]),
        oa(fs_ca[2],m[5]),
        ob[1:0]({fs_ca[1],fs_ca[0]},VCC),
        oc(d_en,m[3]); 
   
endmodule

module LDI (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output wr
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr;
    wire mod;
    wire w;
    wire[1:0] t;

    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(w ,en,wr);

    not  no1(mod,s1);         //controls PC
    not  no2(ldvr[1],s0),
         no3(ldvr[0],s0);
    nand na1(ldvr[2],s0 ,s1);
    or   o1 (w      ,s0),
         o2 (t[1]   ,s0);    //FF input when enabled
    nor  n1 (t[0]   ,s0,s1);     

endmodule

module ANDI (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[2],m[1],m[4],m[5],m[7]),
        o1(ldvr[1],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[2],m[3],m[4],m[5],m[7]),
        o4(r      ,m[0],m[1],m[5],m[6]),                     
        o5(w      ,m[1],m[3],m[6]),
        o7(fs_ca[1],m[0],m[7]),
        os[1:0]({fs_ca[2],fs_ca[0]},m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o8(adr[0] ,m[3]),
        o9(adr[1] ,m[4],m[5]),
        o0(ad_en  ,m[1],m[3],m[4],m[5]),
        oo(aw     ,m[4],m[5]);
endmodule

module ORI (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[2],m[1],m[4],m[5],m[7]),
        o1(ldvr[1],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[2],m[3],m[4],m[5],m[7]),
        o4(r      ,m[0],m[1],m[5],m[6]),                     
        o5(w      ,m[1],m[3],m[6]),
        o7[1:0]({fs_ca[1],fs_ca[0]},m[0],m[7]),
        os(fs_ca[2],m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o8(adr[0] ,m[3]),
        o9(adr[1] ,m[4],m[5]),
        o0(ad_en  ,m[1],m[3],m[4],m[5]),
        oo(aw     ,m[4],m[5]);
        
endmodule

module ADI (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[2],m[1],m[4],m[5],m[7]),
        o1(ldvr[1],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[2],m[3],m[4],m[5],m[7]),
        o4(r      ,m[0],m[1],m[5],m[6]),                     
        o5(w      ,m[1],m[3],m[6]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o7(fs_ca[2],m[0],m[7]),
        os[1:0]({fs_ca[1],fs_ca[0]},m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7]),
        o8(adr[0] ,m[3]),
        o9(adr[1] ,m[4],m[5]),
        o0(ad_en  ,m[1],m[3],m[4],m[5]),
        oo(aw     ,m[4],m[5]);
endmodule

module SBI (
    input en,clk,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,alu_write,
    output[2:0] fs_cal,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,s2,sb0,sb1,sb2;
    wire d0,d1,d2;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,aw;
    tri0[15:0] adr;
    wire[2:0] t,fs_ca;
    wire ad_en;
    wire[7:0] m;
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 000
            M212({t[1],GND},en,d1),
            M213({t[2],GND},en,d2);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1),
              D2(d2,clk,VCC,VCC,s2,sb2);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r  ,en,rd ),
             t4(rl ,en,rd_latch),
             t5(w  ,en,wr),
             t6[2:0](fs_ca,en,fs_cal),
             t7[15:0](adr,ad_en,addbus),
             t8(aw ,en,alu_write);
   
    demux1to8 DM(VCC,{s2,s1,s0},m);
    or  ss2(t[2],m[3],m[4],m[5],m[6]),
        ss1(t[1],m[1],m[2],m[5],m[6]),
        ss0(t[0],m[0],m[2],m[4],m[6]);
    or  o (ldvr[2],m[2],m[1],m[4],m[5],m[7]),
        o1(ldvr[1],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o2(ldvr[0],m[0],m[1],m[2],m[4],m[5],m[6],m[7]),
        o3(rl     ,m[0],m[2],m[3],m[4],m[5],m[7]),
        o4(r      ,m[0],m[1],m[5],m[6]),                     
        o5(w      ,m[1],m[3],m[6]),
        o6(mod    ,m[0],m[1],m[2],m[3],m[4],m[5],m[6]),
        o8(adr[0] ,m[3]),
        o9(adr[1] ,m[4],m[5]),
        o0(ad_en  ,m[1],m[3],m[4],m[5]),
        oo(aw     ,m[4],m[5]),
        o7[1:0]({fs_ca[2],fs_ca[0]},m[2],m[7]),
        os(fs_ca[1],m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7]);
endmodule

module JMP (                   
    input en,clk,
    output[2:0] ld_val_reg,
    output[1:0] mode
);
    supply1 VCC;           
    supply0 GND;
    wire s0,sb0;
    wire d0;

    wire[2:0] ldvr;
    wire[1:0] mod;
    wire t;
    wire[1:0] m;
    
    mux2to1 M211({t,GND},en,d0);        //When not enabled - 0

    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2[1:0](mod,en,mode);
    and ss1(t,m[0],en);
    demux1to2 DM(VCC,s0,m);
    or o1[2:0](ldvr,m[0]);
    or aa(mod[0],m[0],m[1]),
        ab(mod[1],m[1]);       
endmodule

module BREQ (
    input en,clk,equal,
    output[2:0] ld_val_reg,
    output[1:0] mode
);
    supply1 VCC;           
    supply0 GND;
    wire s0,sb0;
    wire d0;

    wire[2:0] ldvr;
    wire[1:0] mod;
    wire t,mod_en;
    wire[1:0] m;
    
    mux2to1 M211({t,GND},en,d0);        //When not enabled - 0

    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2[1:0](mod,en,mode);
    and ss1(t,m[0],en);
    demux1to2 DM(VCC,s0,m);
    or o1[2:0](ldvr,m[0]);
    or aa(mod[0],m[0],mod_en),
        ab(mod[1],mod_en); 
    and a1(mod_en,m[1],equal);
endmodule

module BRZ (
    input en,clk,zero,
    output[2:0] ld_val_reg,
    output[1:0] mode
);
    supply1 VCC;           
    supply0 GND;
    wire s0,sb0;
    wire d0;

    wire[2:0] ldvr;
    wire[1:0] mod;
    wire t,mod_en;
    wire[1:0] m;
    
    mux2to1 M211({t,GND},en,d0);        //When not enabled - 0

    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2[1:0](mod,en,mode);
    and ss1(t,m[0],en);
    demux1to2 DM(VCC,s0,m);
    or o1[2:0](ldvr,m[0]);
    or aa(mod[0],m[0],mod_en),
        ab(mod[1],mod_en); 
    and a1(mod_en,m[1],zero);
endmodule

module JPRL (
    input en,clk,
    output[2:0] ld_val_reg,
    output[1:0] mode
);
    supply0 GND;
    supply1 VCC;
    wire s0,sb0,d0;

    wire[2:0] ldvr;
    wire[1:0] mod;
    wire[1:0] m;
    wire t;

    demux1to2 DM(VCC,s0,m);
    mux2to1 M211({t,GND},en,d0);
         //   M212({t[1],GND},en,d1); 
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0); 
    or  ss1(t,m[0]);
       // ss2(t[1],m[1]);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2[1:0](mod,en,mode);
    or  o1[2:0](ldvr,m[0]),
        o2(mod[1],m[1]),
        o3(mod[0],m[0]);
endmodule

module LDA (
    input en,clk,start,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,point_to_26,
    output[15:0] addbus
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,ad_en,pt26;
    wire[1:0] t;
    tri0[15:0] adr;

    wire ena,enb,clr;
    or nn(ena,s0 ,s1 );
    or   oe(enb,en,ena);
    not  no(clr,start);

    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},enb,d0),         //When not enabled - 00
            M212({t[1],GND},enb,d1);
    posdff_ti D0(d0,clk,VCC,clr,s0,sb0),
              D1(d1,clk,VCC,clr,s1,sb1);
    tristate t1[2:0](ldvr,enb,ld_val_reg),
             t2(mod,enb,mode_0),
             t3(r ,enb,rd),
             t4(rl,enb,rd_latch),
             t5(w ,enb,wr),
             t6(pt26,enb,point_to_26),
             t7[15:0](adr,ad_en,addbus);
    or  ss1(t[1],m[1]),
        ss2(t[0],m[0]);
    or  o1(r,m[1],m[2]),
        o2(rl,m[0],m[1]),
        o3(w,m[0],m[2]),
        o4(mod,m[1]),
        o5[1:0]({ldvr[2],ldvr[0]},m[1],m[2]),           //ldvr 000 generally used to copy value to databus
        o6(ldvr[1],m[2]),                               //used here to copy  reg address to databus and stored in reg 26(ptr)
        o7(pt26,m[2]),                                  //care is taken to make last 8 bits of opcode reflect reg address
        o8[2:0]({adr[4],adr[3],adr[1]},m[0]);
    and o9(ad_en,m[0],en);

endmodule

module STA (
    input en,clk,start,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w;
    wire[1:0] t;

    wire ena,enb,clr;
    or nn(ena,s0,s1);
    or   oe(enb,en,ena);
    not  no(clr,start);

    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},enb,d0),         //When not enabled - 0
            M212({t[1],GND},enb,d1);
    posdff_ti D0(d0,clk,VCC,clr,s0,sb0),
              D1(d1,clk,VCC,clr,s1,sb1);
    tristate t1[2:0](ldvr,enb,ld_val_reg),
             t2(mod,enb,mode_0),
             t3(r ,enb,rd),
             t4(rl,enb,rd_latch),
             t5(w ,enb,wr);
    or  ss2(t[0],m[0],m[2]),
        ss1(t[1],m[1],m[2]);
    or  o1(r,m[1],m[2]),
        o2(rl,m[0],m[1]),
        o3(w,m[2]),
        o5(mod,m[0],m[2]),
        o6[1:0]({ldvr[2],ldvr[0]},m[0],m[2],m[3]),
        o7(ldvr[1],m[0],m[1],m[3]);
endmodule

module LDP (
    input en,clk,ins_5,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,
    output[31:28] point_to
);
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0;

    wire[2:0] ldvr;
    wire mod;
    wire r,rl,w,nins_5,pt_en;
    wire[3:0] pt;
    wire[1:0] t;


    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 0
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r ,en,rd),
             t4(rl,en,rd_latch),
             t5(w ,en,wr),
             t6[3:0](pt,pt_en,point_to);
    or  ss1(t[0],m[0],m[2]),
        ss2(t[1],m[1],m[2]);
    not n1 (nins_5,ins_5);
    or  o1(r,m[1],m[2]),
        o2(rl,m[0],m[1]),
        o3(w,m[2]),
        o4(mod,m[0],m[1],m[2]),
        o5[1:0]({ldvr[2],ldvr[0]},m[0],m[1],m[3]),
        o6(ldvr[1],m[0],m[1],m[2],m[3]);
    and o7(pt_en,m[1],en),
        b1[3:0](pt,{ins_5,ins_5,nins_5,nins_5},en);
    
endmodule 


module STP (
    input en,clk,ins_5,
    output[2:0] ld_val_reg,
    output mode_0,
    output rd,rd_latch,wr,
    output[31:28] point_to
);
    
    supply1 VCC;           
    supply0 GND;
    wire s0,s1,sb0,sb1;
    wire d0,d1;

    wire[2:0] ldvr;
    wire[3:0] pt;
    wire mod;
    wire r,rl,w;

    wire[1:0] t;
    wire[3:0] m;
    demux1to4 DM(VCC,{s1,s0},m);
    
    mux2to1 M211({t[0],GND},en,d0),         //When not enabled - 00
            M212({t[1],GND},en,d1);
    posdff_ti D0(d0,clk,VCC,VCC,s0,sb0),
              D1(d1,clk,VCC,VCC,s1,sb1);
    tristate t1[2:0](ldvr,en,ld_val_reg),
             t2(mod,en,mode_0),
             t3(r ,en,rd),
             t4(rl,en,rd_latch),
             t5(w ,en,wr),
             t6[3:0](pt,pt_en,point_to);
    or  ss1(t[1],m[1],m[2]),
        ss2(t[0],m[0],m[2]);
   not n1 (nins_5,ins_5);
   or   o1(r,m[1],m[2]),
        o2(rl,m[0],m[1],m[3]),
        o3(w,m[2]),
        o4(mod,m[0],m[1],m[2]),
        o5[1:0]({ldvr[2],ldvr[0]},m[0],m[2],m[3]),
        o6(ldvr[1],m[0],m[1],m[2],m[3]);
    and o7(pt_en,m[2],en),
        b1[3:0](pt,{ins_5,ins_5,nins_5,nins_5},en);    

endmodule 


