

module sumres4b (
    input [3:0] A,
    input [3:0] B,
    input Sel,
    output [3:0] So,
    output Co
);

    wire Co1, Co2, Co3, Co_wire;
    wire [3:0] B_xor, So_wire;

    xor(B_xor[0], Sel, B[0]);
    xor(B_xor[1], Sel, B[1]);
    xor(B_xor[2], Sel, B[2]);
    xor(B_xor[3], Sel, B[3]);

    sum4b sum (
        .A(A),
        .B(B_xor),
        .Ci(Sel),
        .So(So_wire),
        .Co(Co_wire)
    );
	 
    xor(So_wire_xor[0], Sel, So_wire[0]);
    xor(So_wire_xor[1], Sel, So_wire[1]);
    xor(So_wire_xor[2], Sel, So_wire[2]);
    xor(So_wire_xor[3], Sel, So_wire[3]);
    xor(Co_xor, Sel, Co_wire)
    
	assign So = So_wire_xor;
	assign Co = Co_xor;

endmodule