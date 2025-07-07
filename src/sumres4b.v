module sumres4b (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Sel,     // 0 = A+B , 1 = A-B
    output wire [3:0] So,      // magnitud (resultado raw de la ALU)
    output wire       flag     // carry (suma) / borrow (resta)
);
    wire [3:0] B_xor;
    wire [3:0] So_int;
    wire       Co_int;

    /* complemento a uno de B cuando Sel=1 */
    xor (B_xor[0], Sel, B[0]);
    xor (B_xor[1], Sel, B[1]);
    xor (B_xor[2], Sel, B[2]);
    xor (B_xor[3], Sel, B[3]);

    /* A + B_xor + Sel */
    sum4b adder4 (
        .A  (A),
        .B  (B_xor),
        .Ci (Sel),
        .So (So_int),
        .Co (Co_int)
    );

    assign So   = So_int;
    assign flag = Co_int ^ Sel;   // carry (Sel=0)  ó  borrow (Sel=1)
endmodule
