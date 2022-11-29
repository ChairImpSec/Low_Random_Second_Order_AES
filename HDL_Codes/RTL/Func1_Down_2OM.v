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

module Func1_Down_2OM(
    input clk,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    input [5:0] r,
	 output [1:0] Mul_result1,
	 output [1:0] Mul_result2,
	 output [1:0] Mul_result3
    );

	wire [17:0] CF_Out;
	reg [17:0] CF_Reg;
	
	genvar i,j;
   generate
		//NonLinear Layer
		for (j=0; j < 2; j=j+1) 
		begin: CF_Inst1
			for (i=0; i < 9; i=i+1) 
			begin: CF_Inst2
				Func1_Down_2OM_CF #(.num(i), .Coordinate_Function(j)) ComponentFunctionsInst (
					.x1(x1), 
					.x2(x2), 
					.x3(x3), 
					.r(r), 
					.q(CF_Out[j*9+i])
				);
			end
		end
		//Compression
		for (i=0; i < 2; i=i+1) 
      begin: InstXOR
			XOR_3 Compression1  ( .x0(CF_Reg[9*i]), 	.x1(CF_Reg[9*i+1]), .x2(CF_Reg[9*i+2]), .q(Mul_result1[i]) );
			XOR_3 Compression2  ( .x0(CF_Reg[9*i+3]), .x1(CF_Reg[9*i+4]), .x2(CF_Reg[9*i+5]), .q(Mul_result2[i]) );
			XOR_3 Compression3  ( .x0(CF_Reg[9*i+6]), .x1(CF_Reg[9*i+7]), .x2(CF_Reg[9*i+8]), .q(Mul_result3[i]) );
      end
   endgenerate
	
	always @(posedge clk) begin
		CF_Reg <= CF_Out;
	end


endmodule
