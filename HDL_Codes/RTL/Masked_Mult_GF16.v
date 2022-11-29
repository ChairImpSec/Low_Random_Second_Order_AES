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
module Masked_Mult_GF16(
	 input clk,
    input [3:0] o1,
    input [3:0] o2,
    input [3:0] o3,
	 input [3:0] b1,
    input [3:0] b2,
    input [3:0] b3,
    input [35:0] r,
    output [3:0] y1,
    output [3:0] y2,
    output [3:0] y3
    );
	 
	integer i;
	 
	reg [3:0] Random [8:0];
	wire [3:0] p [9:1];
	reg [3:0] p_reg [9:1];
	
	always @(*) begin
		for (i=0; i<9; i=i+1) begin
			Random[i] = r[(i*4) +: 4];
		end
	end
	 
	 
	Mult_GF16 #(1) M1 (.a(o1), .b(b1), .c(o1), .y(p[1]));
	Mult_GF16 #(1) M2 (.a(o2), .b(b1), .c(o2), .y(p[2]));
	Mult_GF16 #(0) M3 (.a(o3), .b(b1), .c(4'h0), .y(p[3]));
	
	Mult_GF16 #(0) M4 (.a(o1), .b(b2), .c(4'h0), .y(p[4]));
	Mult_GF16 #(1) M5 (.a(o2), .b(b2), .c(o2), .y(p[5]));
	Mult_GF16 #(1) M6 (.a(o3), .b(b2), .c(o3), .y(p[6]));
	
	Mult_GF16 #(1) M7 (.a(o1), .b(b3), .c(o1), .y(p[7]));
	Mult_GF16 #(0) M8 (.a(o2), .b(b3), .c(4'h0), .y(p[8]));
	Mult_GF16 #(1) M9 (.a(o3), .b(b3), .c(o3), .y(p[9]));
	
	always @(posedge clk) begin 
		for (i=1; i<=9; i=i+1) begin
			p_reg[i] <= p[i] ^ Random[i-1] ^ Random[i % 9];
		end
	end
	
	XOR_3n #(4) compression1 (.x0(p_reg[1]), .x1(p_reg[2]), .x2(p_reg[3]), .Result(y1));
	XOR_3n #(4) compression2 (.x0(p_reg[4]), .x1(p_reg[5]), .x2(p_reg[6]), .Result(y2));
	XOR_3n #(4) compression3 (.x0(p_reg[7]), .x1(p_reg[8]), .x2(p_reg[9]), .Result(y3));

endmodule
