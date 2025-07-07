`timescale 1ns/1ps
`include "src/sum1b_estruc.v"

module sum1b_tb();
    
    reg A_tb;
    reg B_tb;
    reg Cin_tb;

    wire Cout_tb;
    wire S_tb;

    sum1b_estruc uut (
        .A(A_tb),
        .B(B_tb),
        .Ci(Cin_tb),
        .S(S_tb),
        .Cout(Cout_tb)
    );

    initial begin
        // A_tb = 0; incorrecto
        A_tb = 1'b0;
        B_tb = 1'b0;
        Cin_tb = 1'b0;

        #10 // pasarán 10 unidades de tiempo

        A_tb = 1'b1;
        B_tb = 1'b0;
        Cin_tb = 1'b0;

        #10

        A_tb = 1'b1;
        B_tb = 1'b1;
        Cin_tb = 1'b0;

        #10

        A_tb = 1'b1;
        B_tb = 1'b1;
        Cin_tb = 1'b1;


    end

    initial begin
        $dumpfile("sum1b_tb.vcd"); //
        $dumpvars(-1, uut); // 1. nivel de profundidad que llega la simulación, 2. lo que probaré
        #50 $finish;
    end

endmodule