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
module Affine_output(
    input [7:0] C,
    output reg [7:0] Z
    );


	reg T1, T2, T3, T4, T5, T6, T7, T8, T9, T10;
	reg [7:0] D;

	always @(*) begin
		T1 = C[7] ^ C[3];
		T2 = C[6] ^ C[4];
		T3 = C[6] ^ C[0];
		T4 = C[5] ~^ C[3] ; 
		T5 = C[5] ~^ T1 ; 
		T6 = C[5] ~^ C[1] ; 
		T7 = C[4] ~^ T6 ; 
		T8 = C[2] ^ T4 ; 
		T9 = C[1] ^ T2 ; 

		D[7] = T4 ;
		D[6] = T1 ;
		D[5] = T3 ;
		D[4] = T5 ;
		D[3] = T2 ^ T5;
		D[2] = T3 ^ T8;
		D[1] = T7 ;
		D[0] = T9 ;
		
		Z[1:0] = D[1:0];
		Z[4:2] = ~ D[4:2];
		Z[6:5] = D[6:5];
		Z[7] = ~ D[7];
		
	end

endmodule


