//---------------------------------------------------------------------------
//  sumres8b.v  –  Sumador/Restador estructural de 8 bits
//  • Sel = 0  → A + B
//  • Sel = 1  → A − B
//---------------------------------------------------------------------------
module sumres8b (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       Sel,
    output wire [7:0] So,
    output wire       flag          // carry (suma) / borrow (resta)
);

    wire [7:0] B_xor;
    wire [7:0] So_int;
    wire Co4, Co8;

    /* complemento a uno de B cuando Sel = 1 */
    xor (B_xor[0], Sel, B[0]);
    xor (B_xor[1], Sel, B[1]);
    xor (B_xor[2], Sel, B[2]);
    xor (B_xor[3], Sel, B[3]);
    xor (B_xor[4], Sel, B[4]);
    xor (B_xor[5], Sel, B[5]);
    xor (B_xor[6], Sel, B[6]);
    xor (B_xor[7], Sel, B[7]);

    // Parte baja (bits 3–0)
    sum4b low (
        .A  (A[3:0]),
        .B  (B_xor[3:0]),
        .Ci (Sel),
        .So (So_int[3:0]),
        .Co (Co4)
    );

    // Parte alta (bits 7–4)
    sum4b high (
        .A  (A[7:4]),
        .B  (B_xor[7:4]),
        .Ci (Co4),
        .So (So_int[7:4]),
        .Co (Co8)
    );

    assign So   = So_int;
    assign flag = Co8 ^ Sel;

endmodule
