module inst_dec (
    input[15:8] opc,
    output[6:0] rr,r,
    output[4:0] rv,
    output[3:0] p,
    output[1:0] ra,rp,
    output nop,first
);
    wire[15:8] opcinv;
    not  n1(opcinv[15],opc[15]),
            n2(opcinv[14],opc[14]),
            n3(opcinv[13],opc[13]),
            n4(opcinv[12],opc[12]),
            n5(opcinv[11],opc[11]),
            n6(opcinv[10],opc[10]),
            n7(opcinv[9],opc[9]),
            n8(opcinv[8],opc[8]);
    and     a1(rr[6],opc[15]   ,opcinv[14],opc[13]   ,opc[12]   ,opc[11]   ,opcinv[10]),                    //mov
            a2(rr[5],opc[15]   ,opcinv[14],opc[13]   ,opc[12]   ,opcinv[11],opcinv[10]),                    //and
            a3(rr[4],opc[15]   ,opcinv[14],opc[13]   ,opcinv[12],opcinv[11],opcinv[10]),                    //or
            a4(rr[3],opc[15]   ,opcinv[14],opcinv[13],opc[12]   ,opcinv[11],opcinv[10]),                    //add
            a5(rr[2],opc[15]   ,opcinv[14],opcinv[13],opcinv[12],opc[11]   ,opcinv[10]),                    //sub
            a6(rr[1],opc[15]   ,opcinv[14],opcinv[13],opcinv[12],opcinv[11],opc[10]   ),                    //mul
            a7(rr[0],opc[15]   ,opcinv[14],opcinv[13],opcinv[12],opcinv[11],opcinv[10]),                    //cmp
            b1(r[6] ,opcinv[15],opc[14]   ,opc[13]   ,opc[12]   ,opc   [11],opcinv[10]),                    //clr
            b2(r[5] ,opcinv[15],opc[14]   ,opc[13]   ,opc[12]   ,opcinv[11],opcinv[10]),                    //neg
            b3(r[4] ,opcinv[15],opc[14]   ,opc[13]   ,opcinv[12],opcinv[11],opcinv[10]),                    //sll
            b4(r[3] ,opcinv[15],opc[14]   ,opcinv[13],opc[12]   ,opcinv[11],opcinv[10]),                    //slr
            b5(r[2] ,opcinv[15],opc[14]   ,opcinv[13],opcinv[12],opc[11]   ,opcinv[10]),                    //rol
            b6(r[1] ,opcinv[15],opc[14]   ,opcinv[13],opcinv[12],opcinv[11],opc[10]   ),                    //ror
            b7(r[0] ,opcinv[15],opc[14]   ,opcinv[13],opcinv[12],opcinv[11],opcinv[10]),                    //inc
            c1(rv[4],opc[15]   ,opc[14]   ,opc[13]   ,opc[12]   ,opcinv[11]),                               //ldi
            c2(rv[3],opc[15]   ,opc[14]   ,opc[13]   ,opcinv[12],opcinv[11]),                               //adi
            c3(rv[2],opc[15]   ,opc[14]   ,opcinv[13],opc[12]   ,opcinv[11]),                               //sbi
            c4(rv[1],opc[15]   ,opc[14]   ,opcinv[13],opcinv[12],opc[11]   ),                               //andi
            c5(rv[0],opc[15]   ,opc[14]   ,opcinv[13],opcinv[12],opcinv[11]),                               //ori
            d1(p[3] ,opc[15]   ,opc[14]   ,opc[13]   ,opc[12]   ,opc[11]   ,opc[10]   ),                    //jmp
            d2(p[2] ,opc[15]   ,opc[14]   ,opc[13]   ,opc[12]   ,opc[11]   ,opc[ 9]   ),                    //breq
            d3(p[1] ,opc[15]   ,opc[14]   ,opc[13]   ,opc[12]   ,opc[11]   ,opc[ 8]   ),                    //brz
            d4(p[0] ,opc[15]   ,opc[14]   ,opc[13]   ,opc[12]   ,opc[11]   ,opcinv[10],opcinv[9],opcinv[8]),//jprl
            e1(ra[1],opc[15]   ,opcinv[14],opc[13]   ,opc[12]   ,opc[11]   ,opc[10]   ,opc[9]   ),          //lda
            e2(ra[0],opc[15]   ,opcinv[14],opc[13]   ,opc[12]   ,opc[11]   ,opc[10]   ,opcinv[9]),          //sta
            f1(rp[1],opcinv[15],opc[14]   ,opc[13]   ,opc[12]   ,opc[11]   ,opc[10]   ,opc[9]   ),          //ldp
            f2(rp[0],opcinv[15],opc[14]   ,opc[13]   ,opc[12]   ,opc[11]   ,opc[10]   ,opcinv[9]),          //stp
            g1(nop  ,opcinv[15],opcinv[14],opcinv[13],opc[12]),                                                     //nop
            g2(first,opcinv[15],opcinv[14],opc[13]   );                                                     //begin program
endmodule

module prgrm_mem (
    input[4095:0] code,                                     // Hardcoded. Program written suitably to fill PM words
    input clk,                                    
    input[255:0] sel,
    input[2:0] ld_val_reg,                                  // 000-val 001-reg1 010-reg2 011-reg3 100 - val + reg3 101-addressbus 111-do nothing
    output[15:0] instruction,addbus,                        // reg3-(10:8) reg2-(9:5) reg1-(4:0) val-(7:0) address-(15:0)
    output[7:0]  databus 
);  
    genvar i;
    generate
        for(i=0;i<256;i=i+1) begin: pm
        pmword wd(code[15+16*i:16*i],clk,sel[i],ld_val_reg,instruction,addbus,databus);
        end
    endgenerate
endmodule


module prgrm_cnt(       
    input start,clk,
    input[1:0] mode,                //00-count up //01- hold  //10- add jump
    input[7:0] pm_xxxx,              //11- new pm load
    output[255:0] pm_addr
);  
    wire clr;
    not n1(clr,start);
    supply1 VCC;

    wire[7:0] count;
    wire[7:0] add_out,mux_out;
    wire [7:0] countbar;
    wire[7:0] one_up;
    wire negclk;
    not n1(negclk,clk);

    posdff_ti  f1[7:0](mux_out,clk,VCC,clr,count,countbar);
    pmadd  nxt(count,pm_xxxx,add_out);
    mux4to1 M411({pm_xxxx[0],add_out[0],count[0],one_up[0]},mode,mux_out[0]),
            M412({pm_xxxx[1],add_out[1],count[1],one_up[1]},mode,mux_out[1]),
            M413({pm_xxxx[2],add_out[2],count[2],one_up[2]},mode,mux_out[2]),
            M414({pm_xxxx[3],add_out[3],count[3],one_up[3]},mode,mux_out[3]),
            M415({pm_xxxx[4],add_out[4],count[4],one_up[4]},mode,mux_out[4]),
            M416({pm_xxxx[5],add_out[5],count[5],one_up[5]},mode,mux_out[5]),
            M417({pm_xxxx[6],add_out[6],count[6],one_up[6]},mode,mux_out[6]),
            M418({pm_xxxx[7],add_out[7],count[7],one_up[7]},mode,mux_out[7]);  
    demux1to256 cursor(VCC,count,pm_addr); 
    or o1(one_up[0],pm_addr[0],pm_addr[2],pm_addr[4],pm_addr[6],pm_addr[8],pm_addr[10],pm_addr[12],pm_addr[14],pm_addr[16],pm_addr[18],pm_addr[20],pm_addr[22],pm_addr[24],pm_addr[26],pm_addr[28],pm_addr[30],pm_addr[32],pm_addr[34],pm_addr[36],pm_addr[38],pm_addr[40],pm_addr[42],pm_addr[44],pm_addr[46],pm_addr[48],pm_addr[50],pm_addr[52],pm_addr[54],pm_addr[56],pm_addr[58],pm_addr[60],pm_addr[62],pm_addr[64],pm_addr[66],pm_addr[68],pm_addr[70],pm_addr[72],pm_addr[74],pm_addr[76],pm_addr[78],pm_addr[80],pm_addr[82],pm_addr[84],pm_addr[86],pm_addr[88],pm_addr[90],pm_addr[92],pm_addr[94],pm_addr[96],pm_addr[98],pm_addr[100],pm_addr[102],pm_addr[104],pm_addr[106],pm_addr[108],pm_addr[110],pm_addr[112],pm_addr[114],pm_addr[116],pm_addr[118],pm_addr[120],pm_addr[122],pm_addr[124],pm_addr[126],pm_addr[128],pm_addr[130],pm_addr[132],pm_addr[134],pm_addr[136],pm_addr[138],pm_addr[140],pm_addr[142],pm_addr[144],pm_addr[146],pm_addr[148],pm_addr[150],pm_addr[152],pm_addr[154],pm_addr[156],pm_addr[158],pm_addr[160],pm_addr[162],pm_addr[164],pm_addr[166],pm_addr[168],pm_addr[170],pm_addr[172],pm_addr[174],pm_addr[176],pm_addr[178],pm_addr[180],pm_addr[182],pm_addr[184],pm_addr[186],pm_addr[188],pm_addr[190],pm_addr[192],pm_addr[194],pm_addr[196],pm_addr[198],pm_addr[200],pm_addr[202],pm_addr[204],pm_addr[206],pm_addr[208],pm_addr[210],pm_addr[212],pm_addr[214],pm_addr[216],pm_addr[218],pm_addr[220],pm_addr[222],pm_addr[224],pm_addr[226],pm_addr[228],pm_addr[230],pm_addr[232],pm_addr[234],pm_addr[236],pm_addr[238],pm_addr[240],pm_addr[242],pm_addr[244],pm_addr[246],pm_addr[248],pm_addr[250],pm_addr[252],pm_addr[254]),
               o2(one_up[1],pm_addr[1],pm_addr[2],pm_addr[5],pm_addr[6],pm_addr[9],pm_addr[10],pm_addr[13],pm_addr[14],pm_addr[17],pm_addr[18],pm_addr[21],pm_addr[22],pm_addr[25],pm_addr[26],pm_addr[29],pm_addr[30],pm_addr[33],pm_addr[34],pm_addr[37],pm_addr[38],pm_addr[41],pm_addr[42],pm_addr[45],pm_addr[46],pm_addr[49],pm_addr[50],pm_addr[53],pm_addr[54],pm_addr[57],pm_addr[58],pm_addr[61],pm_addr[62],pm_addr[65],pm_addr[66],pm_addr[69],pm_addr[70],pm_addr[73],pm_addr[74],pm_addr[77],pm_addr[78],pm_addr[81],pm_addr[82],pm_addr[85],pm_addr[86],pm_addr[89],pm_addr[90],pm_addr[93],pm_addr[94],pm_addr[97],pm_addr[98],pm_addr[101],pm_addr[102],pm_addr[105],pm_addr[106],pm_addr[109],pm_addr[110],pm_addr[113],pm_addr[114],pm_addr[117],pm_addr[118],pm_addr[121],pm_addr[122],pm_addr[125],pm_addr[126],pm_addr[129],pm_addr[130],pm_addr[133],pm_addr[134],pm_addr[137],pm_addr[138],pm_addr[141],pm_addr[142],pm_addr[145],pm_addr[146],pm_addr[149],pm_addr[150],pm_addr[153],pm_addr[154],pm_addr[157],pm_addr[158],pm_addr[161],pm_addr[162],pm_addr[165],pm_addr[166],pm_addr[169],pm_addr[170],pm_addr[173],pm_addr[174],pm_addr[177],pm_addr[178],pm_addr[181],pm_addr[182],pm_addr[185],pm_addr[186],pm_addr[189],pm_addr[190],pm_addr[193],pm_addr[194],pm_addr[197],pm_addr[198],pm_addr[201],pm_addr[202],pm_addr[205],pm_addr[206],pm_addr[209],pm_addr[210],pm_addr[213],pm_addr[214],pm_addr[217],pm_addr[218],pm_addr[221],pm_addr[222],pm_addr[225],pm_addr[226],pm_addr[229],pm_addr[230],pm_addr[233],pm_addr[234],pm_addr[237],pm_addr[238],pm_addr[241],pm_addr[242],pm_addr[245],pm_addr[246],pm_addr[249],pm_addr[250],pm_addr[253],pm_addr[254]),
               o3(one_up[2],pm_addr[3],pm_addr[4],pm_addr[5],pm_addr[6],pm_addr[11],pm_addr[12],pm_addr[13],pm_addr[14],pm_addr[19],pm_addr[20],pm_addr[21],pm_addr[22],pm_addr[27],pm_addr[28],pm_addr[29],pm_addr[30],pm_addr[35],pm_addr[36],pm_addr[37],pm_addr[38],pm_addr[43],pm_addr[44],pm_addr[45],pm_addr[46],pm_addr[51],pm_addr[52],pm_addr[53],pm_addr[54],pm_addr[59],pm_addr[60],pm_addr[61],pm_addr[62],pm_addr[67],pm_addr[68],pm_addr[69],pm_addr[70],pm_addr[75],pm_addr[76],pm_addr[77],pm_addr[78],pm_addr[83],pm_addr[84],pm_addr[85],pm_addr[86],pm_addr[91],pm_addr[92],pm_addr[93],pm_addr[94],pm_addr[99],pm_addr[100],pm_addr[101],pm_addr[102],pm_addr[107],pm_addr[108],pm_addr[109],pm_addr[110],pm_addr[115],pm_addr[116],pm_addr[117],pm_addr[118],pm_addr[123],pm_addr[124],pm_addr[125],pm_addr[126],pm_addr[131],pm_addr[132],pm_addr[133],pm_addr[134],pm_addr[139],pm_addr[140],pm_addr[141],pm_addr[142],pm_addr[147],pm_addr[148],pm_addr[149],pm_addr[150],pm_addr[155],pm_addr[156],pm_addr[157],pm_addr[158],pm_addr[163],pm_addr[164],pm_addr[165],pm_addr[166],pm_addr[171],pm_addr[172],pm_addr[173],pm_addr[174],pm_addr[179],pm_addr[180],pm_addr[181],pm_addr[182],pm_addr[187],pm_addr[188],pm_addr[189],pm_addr[190],pm_addr[195],pm_addr[196],pm_addr[197],pm_addr[198],pm_addr[203],pm_addr[204],pm_addr[205],pm_addr[206],pm_addr[211],pm_addr[212],pm_addr[213],pm_addr[214],pm_addr[219],pm_addr[220],pm_addr[221],pm_addr[222],pm_addr[227],pm_addr[228],pm_addr[229],pm_addr[230],pm_addr[235],pm_addr[236],pm_addr[237],pm_addr[238],pm_addr[243],pm_addr[244],pm_addr[245],pm_addr[246],pm_addr[251],pm_addr[252],pm_addr[253],pm_addr[254]),
               o4(one_up[3],pm_addr[7],pm_addr[8],pm_addr[9],pm_addr[10],pm_addr[11],pm_addr[12],pm_addr[13],pm_addr[14],pm_addr[23],pm_addr[24],pm_addr[25],pm_addr[26],pm_addr[27],pm_addr[28],pm_addr[29],pm_addr[30],pm_addr[39],pm_addr[40],pm_addr[41],pm_addr[42],pm_addr[43],pm_addr[44],pm_addr[45],pm_addr[46],pm_addr[55],pm_addr[56],pm_addr[57],pm_addr[58],pm_addr[59],pm_addr[60],pm_addr[61],pm_addr[62],pm_addr[71],pm_addr[72],pm_addr[73],pm_addr[74],pm_addr[75],pm_addr[76],pm_addr[77],pm_addr[78],pm_addr[87],pm_addr[88],pm_addr[89],pm_addr[90],pm_addr[91],pm_addr[92],pm_addr[93],pm_addr[94],pm_addr[103],pm_addr[104],pm_addr[105],pm_addr[106],pm_addr[107],pm_addr[108],pm_addr[109],pm_addr[110],pm_addr[119],pm_addr[120],pm_addr[121],pm_addr[122],pm_addr[123],pm_addr[124],pm_addr[125],pm_addr[126],pm_addr[135],pm_addr[136],pm_addr[137],pm_addr[138],pm_addr[139],pm_addr[140],pm_addr[141],pm_addr[142],pm_addr[151],pm_addr[152],pm_addr[153],pm_addr[154],pm_addr[155],pm_addr[156],pm_addr[157],pm_addr[158],pm_addr[167],pm_addr[168],pm_addr[169],pm_addr[170],pm_addr[171],pm_addr[172],pm_addr[173],pm_addr[174],pm_addr[183],pm_addr[184],pm_addr[185],pm_addr[186],pm_addr[187],pm_addr[188],pm_addr[189],pm_addr[190],pm_addr[199],pm_addr[200],pm_addr[201],pm_addr[202],pm_addr[203],pm_addr[204],pm_addr[205],pm_addr[206],pm_addr[215],pm_addr[216],pm_addr[217],pm_addr[218],pm_addr[219],pm_addr[220],pm_addr[221],pm_addr[222],pm_addr[231],pm_addr[232],pm_addr[233],pm_addr[234],pm_addr[235],pm_addr[236],pm_addr[237],pm_addr[238],pm_addr[247],pm_addr[248],pm_addr[249],pm_addr[250],pm_addr[251],pm_addr[252],pm_addr[253],pm_addr[254]),
               o5(one_up[4],pm_addr[15],pm_addr[16],pm_addr[17],pm_addr[18],pm_addr[19],pm_addr[20],pm_addr[21],pm_addr[22],pm_addr[23],pm_addr[24],pm_addr[25],pm_addr[26],pm_addr[27],pm_addr[28],pm_addr[29],pm_addr[30],pm_addr[47],pm_addr[48],pm_addr[49],pm_addr[50],pm_addr[51],pm_addr[52],pm_addr[53],pm_addr[54],pm_addr[55],pm_addr[56],pm_addr[57],pm_addr[58],pm_addr[59],pm_addr[60],pm_addr[61],pm_addr[62],pm_addr[79],pm_addr[80],pm_addr[81],pm_addr[82],pm_addr[83],pm_addr[84],pm_addr[85],pm_addr[86],pm_addr[87],pm_addr[88],pm_addr[89],pm_addr[90],pm_addr[91],pm_addr[92],pm_addr[93],pm_addr[94],pm_addr[111],pm_addr[112],pm_addr[113],pm_addr[114],pm_addr[115],pm_addr[116],pm_addr[117],pm_addr[118],pm_addr[119],pm_addr[120],pm_addr[121],pm_addr[122],pm_addr[123],pm_addr[124],pm_addr[125],pm_addr[126],pm_addr[143],pm_addr[144],pm_addr[145],pm_addr[146],pm_addr[147],pm_addr[148],pm_addr[149],pm_addr[150],pm_addr[151],pm_addr[152],pm_addr[153],pm_addr[154],pm_addr[155],pm_addr[156],pm_addr[157],pm_addr[158],pm_addr[175],pm_addr[176],pm_addr[177],pm_addr[178],pm_addr[179],pm_addr[180],pm_addr[181],pm_addr[182],pm_addr[183],pm_addr[184],pm_addr[185],pm_addr[186],pm_addr[187],pm_addr[188],pm_addr[189],pm_addr[190],pm_addr[207],pm_addr[208],pm_addr[209],pm_addr[210],pm_addr[211],pm_addr[212],pm_addr[213],pm_addr[214],pm_addr[215],pm_addr[216],pm_addr[217],pm_addr[218],pm_addr[219],pm_addr[220],pm_addr[221],pm_addr[222],pm_addr[239],pm_addr[240],pm_addr[241],pm_addr[242],pm_addr[243],pm_addr[244],pm_addr[245],pm_addr[246],pm_addr[247],pm_addr[248],pm_addr[249],pm_addr[250],pm_addr[251],pm_addr[252],pm_addr[253],pm_addr[254]),
               o6(one_up[5],pm_addr[31],pm_addr[32],pm_addr[33],pm_addr[34],pm_addr[35],pm_addr[36],pm_addr[37],pm_addr[38],pm_addr[39],pm_addr[40],pm_addr[41],pm_addr[42],pm_addr[43],pm_addr[44],pm_addr[45],pm_addr[46],pm_addr[47],pm_addr[48],pm_addr[49],pm_addr[50],pm_addr[51],pm_addr[52],pm_addr[53],pm_addr[54],pm_addr[55],pm_addr[56],pm_addr[57],pm_addr[58],pm_addr[59],pm_addr[60],pm_addr[61],pm_addr[62],pm_addr[95],pm_addr[96],pm_addr[97],pm_addr[98],pm_addr[99],pm_addr[100],pm_addr[101],pm_addr[102],pm_addr[103],pm_addr[104],pm_addr[105],pm_addr[106],pm_addr[107],pm_addr[108],pm_addr[109],pm_addr[110],pm_addr[111],pm_addr[112],pm_addr[113],pm_addr[114],pm_addr[115],pm_addr[116],pm_addr[117],pm_addr[118],pm_addr[119],pm_addr[120],pm_addr[121],pm_addr[122],pm_addr[123],pm_addr[124],pm_addr[125],pm_addr[126],pm_addr[159],pm_addr[160],pm_addr[161],pm_addr[162],pm_addr[163],pm_addr[164],pm_addr[165],pm_addr[166],pm_addr[167],pm_addr[168],pm_addr[169],pm_addr[170],pm_addr[171],pm_addr[172],pm_addr[173],pm_addr[174],pm_addr[175],pm_addr[176],pm_addr[177],pm_addr[178],pm_addr[179],pm_addr[180],pm_addr[181],pm_addr[182],pm_addr[183],pm_addr[184],pm_addr[185],pm_addr[186],pm_addr[187],pm_addr[188],pm_addr[189],pm_addr[190],pm_addr[223],pm_addr[224],pm_addr[225],pm_addr[226],pm_addr[227],pm_addr[228],pm_addr[229],pm_addr[230],pm_addr[231],pm_addr[232],pm_addr[233],pm_addr[234],pm_addr[235],pm_addr[236],pm_addr[237],pm_addr[238],pm_addr[239],pm_addr[240],pm_addr[241],pm_addr[242],pm_addr[243],pm_addr[244],pm_addr[245],pm_addr[246],pm_addr[247],pm_addr[248],pm_addr[249],pm_addr[250],pm_addr[251],pm_addr[252],pm_addr[253],pm_addr[254]),
               o7(one_up[6],pm_addr[63],pm_addr[64],pm_addr[65],pm_addr[66],pm_addr[67],pm_addr[68],pm_addr[69],pm_addr[70],pm_addr[71],pm_addr[72],pm_addr[73],pm_addr[74],pm_addr[75],pm_addr[76],pm_addr[77],pm_addr[78],pm_addr[79],pm_addr[80],pm_addr[81],pm_addr[82],pm_addr[83],pm_addr[84],pm_addr[85],pm_addr[86],pm_addr[87],pm_addr[88],pm_addr[89],pm_addr[90],pm_addr[91],pm_addr[92],pm_addr[93],pm_addr[94],pm_addr[95],pm_addr[96],pm_addr[97],pm_addr[98],pm_addr[99],pm_addr[100],pm_addr[101],pm_addr[102],pm_addr[103],pm_addr[104],pm_addr[105],pm_addr[106],pm_addr[107],pm_addr[108],pm_addr[109],pm_addr[110],pm_addr[111],pm_addr[112],pm_addr[113],pm_addr[114],pm_addr[115],pm_addr[116],pm_addr[117],pm_addr[118],pm_addr[119],pm_addr[120],pm_addr[121],pm_addr[122],pm_addr[123],pm_addr[124],pm_addr[125],pm_addr[126],pm_addr[191],pm_addr[192],pm_addr[193],pm_addr[194],pm_addr[195],pm_addr[196],pm_addr[197],pm_addr[198],pm_addr[199],pm_addr[200],pm_addr[201],pm_addr[202],pm_addr[203],pm_addr[204],pm_addr[205],pm_addr[206],pm_addr[207],pm_addr[208],pm_addr[209],pm_addr[210],pm_addr[211],pm_addr[212],pm_addr[213],pm_addr[214],pm_addr[215],pm_addr[216],pm_addr[217],pm_addr[218],pm_addr[219],pm_addr[220],pm_addr[221],pm_addr[222],pm_addr[223],pm_addr[224],pm_addr[225],pm_addr[226],pm_addr[227],pm_addr[228],pm_addr[229],pm_addr[230],pm_addr[231],pm_addr[232],pm_addr[233],pm_addr[234],pm_addr[235],pm_addr[236],pm_addr[237],pm_addr[238],pm_addr[239],pm_addr[240],pm_addr[241],pm_addr[242],pm_addr[243],pm_addr[244],pm_addr[245],pm_addr[246],pm_addr[247],pm_addr[248],pm_addr[249],pm_addr[250],pm_addr[251],pm_addr[252],pm_addr[253],pm_addr[254]),
               o8(one_up[7],pm_addr[127],pm_addr[128],pm_addr[129],pm_addr[130],pm_addr[131],pm_addr[132],pm_addr[133],pm_addr[134],pm_addr[135],pm_addr[136],pm_addr[137],pm_addr[138],pm_addr[139],pm_addr[140],pm_addr[141],pm_addr[142],pm_addr[143],pm_addr[144],pm_addr[145],pm_addr[146],pm_addr[147],pm_addr[148],pm_addr[149],pm_addr[150],pm_addr[151],pm_addr[152],pm_addr[153],pm_addr[154],pm_addr[155],pm_addr[156],pm_addr[157],pm_addr[158],pm_addr[159],pm_addr[160],pm_addr[161],pm_addr[162],pm_addr[163],pm_addr[164],pm_addr[165],pm_addr[166],pm_addr[167],pm_addr[168],pm_addr[169],pm_addr[170],pm_addr[171],pm_addr[172],pm_addr[173],pm_addr[174],pm_addr[175],pm_addr[176],pm_addr[177],pm_addr[178],pm_addr[179],pm_addr[180],pm_addr[181],pm_addr[182],pm_addr[183],pm_addr[184],pm_addr[185],pm_addr[186],pm_addr[187],pm_addr[188],pm_addr[189],pm_addr[190],pm_addr[191],pm_addr[192],pm_addr[193],pm_addr[194],pm_addr[195],pm_addr[196],pm_addr[197],pm_addr[198],pm_addr[199],pm_addr[200],pm_addr[201],pm_addr[202],pm_addr[203],pm_addr[204],pm_addr[205],pm_addr[206],pm_addr[207],pm_addr[208],pm_addr[209],pm_addr[210],pm_addr[211],pm_addr[212],pm_addr[213],pm_addr[214],pm_addr[215],pm_addr[216],pm_addr[217],pm_addr[218],pm_addr[219],pm_addr[220],pm_addr[221],pm_addr[222],pm_addr[223],pm_addr[224],pm_addr[225],pm_addr[226],pm_addr[227],pm_addr[228],pm_addr[229],pm_addr[230],pm_addr[231],pm_addr[232],pm_addr[233],pm_addr[234],pm_addr[235],pm_addr[236],pm_addr[237],pm_addr[238],pm_addr[239],pm_addr[240],pm_addr[241],pm_addr[242],pm_addr[243],pm_addr[244],pm_addr[245],pm_addr[246],pm_addr[247],pm_addr[248],pm_addr[249],pm_addr[250],pm_addr[251],pm_addr[252],pm_addr[253],pm_addr[254]);    
endmodule

module pmadd (                    
    input[8:1] a,b,                 
    output[8:1]s 
);
    wire[8:1] p,g;                                
    wire[8:2] cy;
    supply0 GND;
    wire c;
    halfadder hf[8:1](a,b,p,g);
    CLAG8 c1(p,g,GND,cy,c);
    xor  xo[8:2](s[8:2],p[8:2],cy[8:2]),
         x1     (s[1],p[1],GND);
    
endmodule
