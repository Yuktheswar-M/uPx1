
module pmword (
	input[15:0] code,
    input clk,ld_inst,
    input[2:0] ld_val_reg,
    output[15:0] instruction,addbus,
    output[7:0]  databus
);
	supply1 VCC;
    supply0 GND;
    wire[15:0] wd;
    wire[7:0] dm_out;
    wire[7:0] loadenable;
    wire t1,t2;
	dffpm word[15:0] (code,clk,VCC,VCC,wd);
    tristate inst[15:0](wd     ,ld_inst,instruction);
    

    and A[7:0] (loadenable,ld_inst,dm_out);             //reg3-(10:8) reg2-(9:5) reg1-(4:0) val-(7:0)
    demux1to8 D(VCC,ld_val_reg,dm_out);                 //Choose if and what to load into DM buses
    or  o1(t1,loadenable[0],loadenable[4]),
        o2(t2,loadenable[3],loadenable[4]);
    tristate val [7:0] (wd[7:0],t1           ,databus);             //val
    tristate reg1[4:0] (wd[9:5],loadenable[1],addbus[4:0]);         //reg1
    tristate reg2[4:0] (wd[4:0],loadenable[2],addbus[4:0]);         //reg2
    tristate reg3[3:0] ({VCC,wd[10:8]},t2    ,addbus[3:0]);         //reg3
    tristate addr[15:0](wd     ,loadenable[5] ,addbus);             //address

endmodule



module dmword (
    inout[7:0] databus,
    input clk,set,clr,rd,rd_latch,wr,sel,
    output[7:0] word_vis
);
    wire[7:0] mux_out;
    wire t;

    dffdm word[7:0] (mux_out,clk,set,clr,rd,rd_latch,sel,databus,word_vis);
    and a1(t,wr,sel);                                           // write enable
    genvar i;
    generate
        for(i=0;i<8;i=i+1) begin: dmw
        mux2to1 M({databus[i],word_vis[i]},t,mux_out[i]);
        end
    endgenerate
endmodule

module dmwordptr (
    inout[7:0] databus,
    input clk,set,clr,rd,rd_latch,wr,sel,point_to,
    output[7:0] addbus,word_vis
);
    wire[7:0] mux_out;
    wire t;
    dffdm word[7:0] (mux_out,clk,set,clr,rd,rd_latch,sel,databus,word_vis);   
    tristate t1[7:0] (word_vis,point_to,addbus);                          //to be loaded without getting slected
    and a1(t,wr,sel);                                           // write enable
    genvar i;
    generate
        for(i=0;i<8;i=i+1) begin: dmw
        mux2to1 M({databus[i],word_vis[i]},t,mux_out[i]);
        end
    endgenerate
endmodule

module dmword_mapdout (
    inout[7:0] databus,
    input[7:0] alu_out,                         //used for flag as well
    input clk,set,clr,rd_latch,rd,sel,alu_write,
    input[1:0] wr,
    output[7:0] word_vis
);
    wire[7:0] mux_out;
    wire t1,t2,t3;

    dffdm word[7:0] (mux_out,clk,set,clr,rd,rd_latch,sel,databus,word_vis);
    not n1(t3,wr[1]);
    and a1(t1,wr[0],sel),                                           // write enable
        a2(t2,alu_write,t3);

    genvar i;
    generate
        for(i=0;i<8;i=i+1) begin: dmw
        mux4to1 M({1'bz,alu_out[i],databus[i],word_vis[i]},{t2,t1},mux_out[i]);
        end
    endgenerate
endmodule