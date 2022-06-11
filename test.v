// ALU test

module test;
    reg[7:0] R0,R1;
    reg [1:0]fs;
    wire[7:0]R2;
    wire[3:0]flag;

    ALUs cpu(R0,R1,fs,R2,flag);
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        $monitor($time," R0=%b, R1=%b, R2=%b, fs=%b, flag=%b",R0,R1,R2,fs,flag);
        #5 R0=8'b00000010;R1=8'b00000001;fs=2'b10;
        #5 R0=8'b00010010;R1=8'b00010010;fs=2'b01;
        #5 R0=8'b00100011;R1=8'b11111101;fs=2'b00;
        #5 $finish;
    end
endmodule