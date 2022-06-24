module calcfns (
    input[7:0] R0,R1,
    inout[7:0] SREG,
    input [5:0] fs,
    output[7:0] R2
);  
    supply0 GND;
    comparator cmper(R0,R1,fs[0],R2,SREG[5]);
    bwxor8 xorer(R0,R1,    fs[1],R2,SREG[1],SREG[2]);
    sub8 subbr(R0,R1,      fs[2],R2,SREG[0],SREG[1],SREG[2],SREG[3],SREG[4]);
    add8 adder(R0,R1,GND,  fs[3],R2,SREG[0],SREG[1],SREG[2],SREG[3],SREG[4]);
    bwor8 orer(R0,R1,      fs[4],R2,SREG[1],SREG[2]);
    bwand8 ander(R0,R1,    fs[5],R2,SREG[1],SREG[2]);
    
endmodule

module shftfns (
    inout[7:0] databus,SREG,
    input [2:0] fs,            //fs-101 : pseudo read enable
    input en_wr,clk          // write enable for this reg
);  
    supply1 VCC;
    supply0 GND;
    wire[7:0] d_in,Q;
    wire negclk;                            
    shifter SR(d_in,clk,en_wr,t[4:3],Q,SREG[1],SREG[2],SREG[6],SREG[7]);
    wire[4:0] t;

    not n1(t[0],fs[0]),
        n2(t[1],fs[1]),
        n3(t[2],fs[2]),
        n4(negclk,clk);                    //NEG CLK
    and a1(t[3],fs[0],t[1] ,t[2],negclk),  //slr
        a2(t[4],t[0] ,fs[1],t[2],negclk);  //sll
    mux8to1 m7({1'bz,1'bz,databus[7],Q[6],Q[0],Q[6], GND,Q[7]},fs,d_in[7]), //z,z,load,rol,ror,sll,slr,current
            m6({1'bz,1'bz,databus[6],Q[5],Q[7],Q[5],Q[7],Q[6]},fs,d_in[6]),
            m5({1'bz,1'bz,databus[5],Q[4],Q[6],Q[4],Q[6],Q[5]},fs,d_in[5]),
            m4({1'bz,1'bz,databus[4],Q[3],Q[5],Q[3],Q[5],Q[4]},fs,d_in[4]),
            m3({1'bz,1'bz,databus[3],Q[2],Q[4],Q[2],Q[4],Q[3]},fs,d_in[3]),
            m2({1'bz,1'bz,databus[2],Q[1],Q[3],Q[1],Q[3],Q[2]},fs,d_in[2]),
            m1({1'bz,1'bz,databus[1],Q[0],Q[2],Q[0],Q[2],Q[1]},fs,d_in[1]),
            m0({1'bz,1'bz,databus[0],Q[7],Q[1], GND,Q[1],Q[0]},fs,d_in[0]); 
    tristate tt[7:0](Q,en_wr,databus);
endmodule

module ALU (
    inout[7:0] databus,alu_flag,
    input[7:0] dm_word0,dm_word1,
    input[2:0] fs_cal,fs_shft,
    input shft_wr,clk,
    output[7:0] alu_out
);  
    wire[7:0] fs_cal_de;
    supply1 VCC;
    demux1to8 dm(VCC,fs_cal,fs_cal_de);
    calcfns unit1(dm_word0,dm_word1,alu_flag,fs_cal_de[5:0],alu_out);
    shftfns unit2(databus,alu_flag,fs_shft,shft_wr,clk);

    
endmodule