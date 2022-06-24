module datamem (
    inout[7:0] databus,
    input [7:0] alu_out,alu_flag,
    input[1023:0] sel,                         //restricted to 1024 for faster simulation
    input[31:26] point_add,
    input clk,set,clr,rd,rd_latch,wr,alu_write,
    output[15:0] addbus,
    output[8191:0] data_vis
);  
    supply0 GND;
    genvar i;
    generate
        for(i=0;i<2;i=i+1) begin: data1
        dmword    wd(databus,clk,set,clr,rd,rd_latch,wr,sel[i],data_vis[7+8*i:8*i]);
        end
    endgenerate
    dmword_mapdout wd2(databus,alu_out,clk,set,clr,rd_latch,rd,sel[2 ],alu_write,{GND,wr},data_vis[23:16]);
    dmword_mapdout wd32(databus,alu_flag,clk,set,clr,rd_latch,rd,sel[32],alu_write,{GND,wr},data_vis[263:256]);
    generate
        for(i=3;i<26;i=i+1) begin: data2
        dmword    wd(databus,clk,set,clr,rd,rd_latch,wr,sel[i],data_vis[7+8*i:8*i]);
        end
    endgenerate
    generate
        for(i=26;i<32;i=i+2) begin: data3
        dmwordptr  wd(databus,clk,set,clr,rd,rd_latch,wr,sel[i  ],point_add[i  ],addbus[7:0] ,data_vis[ 7+8*i:8*i  ]),
                  wd1(databus,clk,set,clr,rd,rd_latch,wr,sel[i+1],point_add[i+1],addbus[15:8],data_vis[15+8*i:8+8*i]);
        end
    endgenerate
    generate
        for(i=33;i<1024;i=i+1) begin: data4
        dmword    wd(databus,clk,set,clr,rd,rd_latch,wr,sel[i],data_vis[7+8*i:8*i]);
        end
    endgenerate
    
endmodule

module address (
    input[15:0] addbus,
    output[1023:0] sel
);
    supply1 VCC;
    demux1to1024 cursor(VCC,addbus[9:0],sel);   //restricted to 1024 for faster simulation
endmodule