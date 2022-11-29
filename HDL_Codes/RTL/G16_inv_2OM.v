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


//inverse in GF(2^4)
module G16_inv_2OM(
    input clk,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
	 input [23:0] r,
//	 input [3:0] remasking_r,
    output [3:0] out1,
    output [3:0] out2,
    output [3:0] out3 );
	 
	wire [1:0] a1, a2, a3, b1, b2, b3, d1, d2, d3;
	wire [1:0] a1_xor_b1, a2_xor_b2, a3_xor_b3;
	wire [1:0] G4_sq_a1_xor_b1, G4_sq_a2_xor_b2, G4_sq_a3_xor_b3;
	wire [1:0] G4_scl_N_G4_sq_a1_xor_b1, G4_scl_N_G4_sq_a2_xor_b2, G4_scl_N_G4_sq_a3_xor_b3;
	wire [1:0] e1, e2, e3, inverse_e1, inverse_e2, inverse_e3;
	wire [1:0] inverse_e1D, inverse_e2D, inverse_e3D;
	
	reg  [1:0] G4_scl_N_G4_sq_a1_xor_b1_reg, G4_scl_N_G4_sq_a2_xor_b2_reg, G4_scl_N_G4_sq_a3_xor_b3_reg;
	reg  [1:0] a1_reg, a2_reg, a3_reg, b1_reg, b2_reg, b3_reg;
	reg  [1:0] a1_reg2, a2_reg2, a3_reg2, b1_reg2, b2_reg2, b3_reg2;
	reg  [1:0] inverse_e1_reg, inverse_e2_reg, inverse_e3_reg;
	reg  [1:0] inverse_e1_regD, inverse_e2_regD, inverse_e3_regD;
	
	assign a1 = x1[3:2];
	assign a2 = x2[3:2];
	assign a3 = x3[3:2];
	
	assign b1 = x1[1:0];
	assign b2 = x2[1:0];
	assign b3 = x3[1:0];
	
	//-----
	
//	XOR_2n #(.WIDTH(2)) XOR_Inst_1 (.a(a1), .b(b1), .z(a1_xor_b1));
//	XOR_2n #(.WIDTH(2)) XOR_Inst_2 (.a(a2), .b(b2), .z(a2_xor_b2));
//	XOR_2n #(.WIDTH(2)) XOR_Inst_3 (.a(a3), .b(b3), .z(a3_xor_b3));
//	
//	assign G4_sq_a1_xor_b1 = {a1_xor_b1[0], a1_xor_b1[1]};
//	assign G4_sq_a2_xor_b2 = {a2_xor_b2[0], a2_xor_b2[1]};
//	assign G4_sq_a3_xor_b3 = {a3_xor_b3[0], a3_xor_b3[1]};
//	
//	assign G4_scl_N_G4_sq_a1_xor_b1[1] = G4_sq_a1_xor_b1[0];
//	assign G4_scl_N_G4_sq_a2_xor_b2[1] = G4_sq_a2_xor_b2[0];
//	assign G4_scl_N_G4_sq_a3_xor_b3[1] = G4_sq_a3_xor_b3[0];
//	
//	XOR_2n #(.WIDTH(1)) XOR_Inst_4 (.a(G4_sq_a1_xor_b1[0]), .b(G4_sq_a1_xor_b1[1]), .z(G4_scl_N_G4_sq_a1_xor_b1[0]));
//	XOR_2n #(.WIDTH(1)) XOR_Inst_5 (.a(G4_sq_a2_xor_b2[0]), .b(G4_sq_a2_xor_b2[1]), .z(G4_scl_N_G4_sq_a2_xor_b2[0]));
//	XOR_2n #(.WIDTH(1)) XOR_Inst_6 (.a(G4_sq_a3_xor_b3[0]), .b(G4_sq_a3_xor_b3[1]), .z(G4_scl_N_G4_sq_a3_xor_b3[0]));
	
	always @(posedge clk) begin
//		G4_scl_N_G4_sq_a1_xor_b1_reg <= G4_scl_N_G4_sq_a1_xor_b1;
//		G4_scl_N_G4_sq_a2_xor_b2_reg <= G4_scl_N_G4_sq_a2_xor_b2;
//		G4_scl_N_G4_sq_a3_xor_b3_reg <= G4_scl_N_G4_sq_a3_xor_b3;
		
		a1_reg <= a1;
		a2_reg <= a2;
		a3_reg <= a3;
		
		b1_reg <= b1;
		b2_reg <= b2;
		b3_reg <= b3;
		
		inverse_e1_reg <= inverse_e1;
		inverse_e2_reg <= inverse_e2;
		inverse_e3_reg <= inverse_e3;
		
		inverse_e1_regD <= inverse_e1D;
		inverse_e2_regD <= inverse_e2D;
		inverse_e3_regD <= inverse_e3D;
		
		a1_reg2 <= a1_reg;
		a2_reg2 <= a2_reg;
		a3_reg2 <= a3_reg;
		
		b1_reg2 <= b1_reg;
		b2_reg2 <= b2_reg;
		b3_reg2 <= b3_reg;
		
	end
	
//	GF4_MUL_2OM Mul1 (
//    .clk(clk), 
//    .x1(a1), 
//    .x2(a2), 
//    .x3(a3), 
//    .y1(b1), 
//    .y2(b2), 
//    .y3(b3), 
//    .r(r[5:0]), 
//    .Mul_result1(d1), 
//    .Mul_result2(d2), 
//    .Mul_result3(d3) );
//	 
//	XOR_2n #(.WIDTH(2)) XOR_Inst_7 (.a(G4_scl_N_G4_sq_a1_xor_b1_reg), .b(d1), .z(e1));
//	XOR_2n #(.WIDTH(2)) XOR_Inst_8 (.a(G4_scl_N_G4_sq_a2_xor_b2_reg), .b(d2), .z(e2));
//	XOR_2n #(.WIDTH(2)) XOR_Inst_9 (.a(G4_scl_N_G4_sq_a3_xor_b3_reg), .b(d3), .z(e3));
//	
//	assign inverse_e1 = {e1[0], e1[1]};
//	assign inverse_e2 = {e2[0], e2[1]};
//	assign inverse_e3 = {e3[0], e3[1]};
	
	Func1_Up_2OM Mult_special1 (
    .clk(clk), 
    .x1(x1), 
    .x2(x2), 
    .x3(x3), 
    .r(r[5:0]), 
    .Mul_result1(inverse_e1), 
    .Mul_result2(inverse_e2), 
    .Mul_result3(inverse_e3)
    );
	 
	 Func1_Down_2OM Mult_special2 (
    .clk(clk), 
    .x1(x1), 
    .x2(x2), 
    .x3(x3), 
    .r(r[11:6]), 
    .Mul_result1(inverse_e1D), 
    .Mul_result2(inverse_e2D), 
    .Mul_result3(inverse_e3D)
    );
	
	
	GF4_MUL_2OM Mul2 (
    .clk(clk), 
    .x1(inverse_e1_reg), 
    .x2(inverse_e2_reg), 
    .x3(inverse_e3_reg), 
    .y1(b1_reg2), 
    .y2(b2_reg2), 
    .y3(b3_reg2), 
    .r(r[23:18]), 
    .Mul_result1(out1[3:2]), 
    .Mul_result2(out2[3:2]), 
    .Mul_result3(out3[3:2]) );
	 
	GF4_MUL_2OM Mul3 (
    .clk(clk), 
    .x1(inverse_e1_regD), 
    .x2(inverse_e2_regD), 
    .x3(inverse_e3_regD), 
    .y1(a1_reg2), 
    .y2(a2_reg2), 
    .y3(a3_reg2), 
    .r(r[17:12]), 
    .Mul_result1(out1[1:0]), 
    .Mul_result2(out2[1:0]), 
    .Mul_result3(out3[1:0]) );


endmodule
