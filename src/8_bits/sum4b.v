module sum4b (
    input [3:0] A,
    input [3:0] B,
    input Ci,
    output [3:0] So,
    output Co
);

    wire Co1, Co2, Co3;

    sum1b_estruc s1 (
        .A(A[0]),
        .B(B[0]),
        .Ci(Ci), // Lo que va afuera debe ser el nombre en el modulo sum1b_estruc
        .S(So[0]),
        .Cout(Co1)
    );

    sum1b_estruc s2 (
        .A(A[1]),
        .B(B[1]),
        .Ci(Co1), // Lo que va afuera debe ser el nombre en el modulo sum1b_estruc
        .S(So[1]),
        .Cout(Co2)
    );

    sum1b_estruc s3 (
        .A(A[2]),
        .B(B[2]),
        .Ci(Co2), // Lo que va afuera debe ser el nombre en el modulo sum1b_estruc
        .S(So[2]),
        .Cout(Co3)
    );

    sum1b_estruc s4 (
        .A(A[3]),
        .B(B[3]),
        .Ci(Co3), // Lo que va afuera debe ser el nombre en el modulo sum1b_estruc
        .S(So[3]),
        .Cout(Co)
    );


endmodule