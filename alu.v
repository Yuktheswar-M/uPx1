
module ALUb (               //behavioural-initial testing
    input [7:0] A,
    input [7:0] B,
    input [1:0] fs,
    output reg [7:0] C,
    output reg [3:0] flag // Cmp|Zero|----|v/c/b
);
    always @(*)  begin
        flag=4'b0;
        C   =4'b0;

        case(fs)
        2'b00:begin     //add
            {flag[0],C}=A+B;
            if(C==0)
                flag[2]=1;
        end
        2'b01:begin     //sub
            {flag[0],C}=A-B;
            if(C==0)
                flag[2]=1;
        end
        2'b10:begin     //cmp
            if(A==B)
                flag[3]=1;
        end
        endcase

    end
endmodule

module ALUs (
    input [7:0] A,                                                  //Mapped Input
    input [7:0] B,                                                  //Mapped Input 2
    input [1:0] fs,
    output  [7:0] C,                                                //Mapped Output
    output  [3:0] flag                                              //Flag
);  
    tri0  [3:0] flag;                                                //Pulled down when not driven.
    supply0 GND;
    supply1 VCC;
    wire[3:0] en;// function enable lines
    demux1to4 Dem1(VCC,fs,en);

    add8 adder(A,B,GND,en[0],C,flag[0]);
    sub8 suber(A,B,VCC,en[1],C,flag[0]);
    comparator cmpr(A,B,en[2],flag[3]);
    nor zckt(flag[2],C[7],C[6],C[5],C[4],C[3],C[2],C[1],C[0]);        //zero flag ckt
endmodule
