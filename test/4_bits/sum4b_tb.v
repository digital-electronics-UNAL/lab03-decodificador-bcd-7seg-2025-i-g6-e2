`timescale 1ns/1ps
`include "src/sum4b.v"
`include "src/sum1b_estruc.v"

module sum4b_tb();

    reg [3:0] A_tb;
    reg [3:0] B_tb;
    reg Cin_tb;

    wire Cout_tb;
    wire [3:0] S_tb;

    sum4b uut (
        .A(A_tb),
        .B(B_tb),
        .Ci(Cin_tb),
        .So(S_tb),
        .Co(Cout_tb)
    );

    initial begin
        A_tb = 4'b0000;
        B_tb = 4'b0000;
        Cin_tb = 1'b0;

        #10

        A_tb = 4'b1100;
        B_tb = 4'b0011;
        Cin_tb = 1'b0;

        #10

        A_tb = 4'b0011;
        B_tb = 4'b0011;
        Cin_tb = 1'b1;

        #10

        A_tb = 4'b0111;
        B_tb = 4'b0111;
        Cin_tb = 1'b1;

        #10

        A_tb = 4'b1111;
        B_tb = 4'b1111;
        Cin_tb = 1'b0;
    end

    initial begin
        $dumpfile("sum4b_tb.vcd"); //
        $dumpvars(-1, uut); // 1. nivel de profundidad que llega la simulación, 2. lo que probaré
        #50 $finish;
    end

endmodule