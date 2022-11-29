/*
* -----------------------------------------------------------------
* AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
* DOCUMENT: "Second-Order Low-Randomness d+1 Hardware Sharing of the AES" CCS'22
* -----------------------------------------------------------------
*
* Copyright (c) 2022, Aein Rezaei Shahmirzadi
*
* All rights reserved.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Please see LICENSE and README for license and further instructions.
*/


module AESSbox_2OM(
    input clk,
    input [7:0] x1,
    input [7:0] x2,
    input [7:0] x3,
    input [7:0] Guards,
	 input [138:0] r,
	 input [15:0] dr,
    output [7:0] Guards_out,
    output reg [7:0] out1,
    output reg [7:0] out2,
    output reg [7:0] out3 );
	 
	
	wire [35:0] Mult1_r;
	wire [23:0] Inv_r;
	wire [71:0] TwoLastMult_r;
	wire [7:0] r2;

    
	assign Mult1_r = r[35:0];
	assign Inv_r   = r[131:108];
	assign TwoLastMult_r   = r[107:36];
	assign r2 = r[138:131];
    
    

	wire [7:0] Sbox_out1, Sbox_out2, Sbox_out3;
	wire [7:0] GF256_Inv1, GF256_Inv2, GF256_Inv3;
	wire [7:0] Aff_x1, Aff_x2, Aff_x3;
	reg [3:0] a1, a2, a3, b1, b2, b3;
	wire [3:0] c1, c2, c3, d1, d2, d3;
	wire [3:0] a1_xor_b1, a2_xor_b2, a3_xor_b3;
	wire [3:0] c1_xor_d1, c2_xor_d2, c3_xor_d3;
	wire [3:0] e1, e2, e3;
	wire [7:0] out1_tmp;
	
	reg  [3:0] c1_reg, c2_reg, c3_reg, c1_reg2, c2_reg2, c3_reg2;
	reg  [3:0] a1_reg, a2_reg, a3_reg, b1_reg, b2_reg, b3_reg;
	reg  [3:0] a1_reg2, a2_reg2, a3_reg2, b1_reg2, b2_reg2, b3_reg2;
	reg  [3:0] c1_xor_d1_reg, c2_xor_d2_reg, c3_xor_d3_reg;
	reg  [3:0] a1_reg3, a2_reg3, a3_reg3, b1_reg3, b2_reg3, b3_reg3;
	reg  [3:0] a1_reg4, a2_reg4, a3_reg4, b1_reg4, b2_reg4, b3_reg4;
	reg  [3:0] a1_reg5, a2_reg5, a3_reg5, b1_reg5, b2_reg5, b3_reg5;
	reg  [3:0] a1_reg6, a2_reg6, a3_reg6, b1_reg6, b2_reg6, b3_reg6;
	reg  [3:0] a1_reg7, a2_reg7, a3_reg7, b1_reg7, b2_reg7, b3_reg7;
	reg  [3:0] e1_refreshed, e2_refreshed, e3_refreshed;
	reg  [7:0] GF256_Inv1_reg, GF256_Inv2_reg, GF256_Inv3_reg;
	
	Affine_input Aff_in1 (.A(x1), .Z(Aff_x1));
	Affine_input Aff_in2 (.A(x2), .Z(Aff_x2));
	Affine_input Aff_in3 (.A(x3), .Z(Aff_x3));
	
	assign Guards_out = {b1_reg5, b2_reg5};
	
	

	
	XOR_2n #(.WIDTH(4)) XOR_Inst_1 (.a(a1), .b(b1), .z(a1_xor_b1));
	XOR_2n #(.WIDTH(4)) XOR_Inst_2 (.a(a2), .b(b2), .z(a2_xor_b2));
	XOR_2n #(.WIDTH(4)) XOR_Inst_3 (.a(a3), .b(b3), .z(a3_xor_b3));
	
	G16_sq_scl G16_sq_scl_Inst1 (.x(a1_xor_b1), .q(c1));
	G16_sq_scl G16_sq_scl_Inst2 (.x(a2_xor_b2), .q(c2));
	G16_sq_scl G16_sq_scl_Inst3 (.x(a3_xor_b3), .q(c3));
	
	always @(posedge clk) begin
	
	    a1 <= Aff_x1[7:4];
		b1 <= Aff_x1[3:0];
		a2 <= Aff_x2[7:4];
		b2 <= Aff_x2[3:0];
		a3 <= Aff_x3[7:4];
		b3 <= Aff_x3[3:0];
		
		//stage 1
		a1_reg <= a1;
		a2_reg <= a2;
		a3_reg <= a3;
		
		b1_reg <= b1;
		b2_reg <= b2;
		b3_reg <= b3;
		
		c1_reg <= c1;
		c2_reg <= c2;
		c3_reg <= c3;
		
		//stage 2
		a1_reg2 <= a1_reg;
		a2_reg2 <= a2_reg;
		a3_reg2 <= a3_reg;
		
		b1_reg2 <= b1_reg;
		b2_reg2 <= b2_reg;
		b3_reg2 <= b3_reg;
		
		//stage 3
		c1_xor_d1_reg <= c1_xor_d1;
		c2_xor_d2_reg <= c2_xor_d2;
		c3_xor_d3_reg <= c3_xor_d3;
		
		a1_reg3 <= a1_reg2;
		a2_reg3 <= a2_reg2;
		a3_reg3 <= a3_reg2;
			        
		b1_reg3 <= b1_reg2;
		b2_reg3 <= b2_reg2;
		b3_reg3 <= b3_reg2;
		
		//stage 4
		a1_reg4 <= a1_reg3;
		a2_reg4 <= a2_reg3;
		a3_reg4 <= a3_reg3;
		b1_reg4 <= b1_reg3;
		b2_reg4 <= b2_reg3;
		b3_reg4 <= b3_reg3;
		
		//stage 5
		a1_reg5 <= a1_reg4;
		a2_reg5 <= a2_reg4;
		a3_reg5 <= a3_reg4;
		b1_reg5 <= b1_reg4;
		b2_reg5 <= b2_reg4;
		b3_reg5 <= b3_reg4;
		
		//stage 6
		a1_reg6 <= a1_reg5;
		a2_reg6 <= a2_reg5;
		a3_reg6 <= a3_reg5;
		b1_reg6 <= b1_reg5;
		b2_reg6 <= b2_reg5;
		b3_reg6 <= b3_reg5;
		
		//stage 7
		e1_refreshed <= e1 ^ {Guards[0] ^ Guards[1], Guards[2] ^ Guards[3], Guards[4] ^ Guards[5], Guards[6] ^ Guards[7]} ^ r2[3:0]; 
		e2_refreshed <= e2 ^ {Guards[1], Guards[3], Guards[5], Guards[7]} ^ r2[7:4]; 
		e3_refreshed <= e3 ^ {Guards[0], Guards[2], Guards[4], Guards[6]} ^ r2[7:4] ^ r2[3:0]; 
		
		a1_reg7 <= a1_reg6;
		a2_reg7 <= a2_reg6;
		a3_reg7 <= a3_reg6;
		b1_reg7 <= b1_reg6;
		b2_reg7 <= b2_reg6;
		b3_reg7 <= b3_reg6;
		
		//stage 8
		GF256_Inv1_reg <= GF256_Inv1;
		GF256_Inv2_reg <= GF256_Inv2;
		GF256_Inv3_reg <= GF256_Inv3;
		
	end
	
	
	Masked_Mult_GF16 GF16_Mul1 (
    .clk(clk), 
    .o1(a1), 
    .o2(a2), 
    .o3(a3), 
    .b1(b1), 
    .b2(b2), 
    .b3(b3), 
    .r(Mult1_r), 
    .y1(d1), 
    .y2(d2), 
    .y3(d3)
    );
	 
	 
//	G16_mul_2OM GF16_Mul1 (
//    .clk(clk), 
//    .x1(a1), 
//    .x2(a2), 
//    .x3(a3), 
//    .y1(b1), 
//    .y2(b2), 
//    .y3(b3), 
//    .r(Mult1_r), 
//    .out1(d1), 
//    .out2(d2), 
//    .out3(d3) );
	 
	XOR_2n #(.WIDTH(4)) XOR_Inst_4 (.a(c1_reg), .b(d1), .z(c1_xor_d1));
	XOR_2n #(.WIDTH(4)) XOR_Inst_5 (.a(c2_reg), .b(d2), .z(c2_xor_d2));
	XOR_2n #(.WIDTH(4)) XOR_Inst_6 (.a(c3_reg), .b(d3), .z(c3_xor_d3));
	
	G16_inv_2OM G16_inv_Inst (
    .clk(clk), 
    .x1(c1_xor_d1_reg), 
    .x2(c2_xor_d2_reg), 
    .x3(c3_xor_d3_reg), 
    .r(Inv_r), 
    .out1(e1), 
    .out2(e2), 
    .out3(e3) );
	 
	 
	TheFifthStage TwoLastMult (
    .clk(clk), 
    .o1(e1_refreshed), 
    .o2(e2_refreshed), 
    .o3(e3_refreshed), 
    .b1(b1_reg6), 
    .b2(b2_reg6), 
    .b3(b3_reg6), 
    .c1(a1_reg6), 
    .c2(a2_reg6), 
    .c3(a3_reg6), 
    .r(TwoLastMult_r), 
    .y1(GF256_Inv1), 
    .y2(GF256_Inv2), 
    .y3(GF256_Inv3) );
	 
	Affine_output OutputAffineInst1 (.C(GF256_Inv1_reg), .Z(out1_tmp) );
	Affine_output OutputAffineInst2 (.C(GF256_Inv2_reg), .Z(Sbox_out2) );
	Affine_output OutputAffineInst3 (.C(GF256_Inv3_reg), .Z(Sbox_out3) );
	
	//add constant
	assign Sbox_out1 = out1_tmp ^ 8'h63;
	
	always @(*) begin
		out1 <= Sbox_out1 ^ dr[7:0];
		out2 <= Sbox_out2 ^ dr[15:8];
		out3 <= Sbox_out3 ^ dr[7:0] ^ dr[15:8];
	end
	
endmodule
