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
module Affine_input(
    input [7:0] A,
    output reg [7:0] Z
    );

	reg R1, R2, R3, R4, R5, R6, R7, R8, R9;
	reg [7:0] B;

	always @(*) begin
	
		R1 = A[7] ^ A[5] ;
		R2 = A[7] ~^ A[4] ;
		R3 = A[6] ^ A[0] ;
		R4 = A[5] ~^ R3 ;
		R5 = A[4] ^ R4 ;
		R6 = A[3] ^ A[0] ;
		R7 = A[2] ^ R1 ;
		R8 = A[1] ^ R3 ;
		R9 = A[3] ^ R8 ;


		B[7] = R7 ~^ R8 ;
		B[6] = R5 ;
		B[5] = A[1] ^ R4 ;
		B[4] = R1 ~^ R3 ;
		B[3] = A[1] ^ R2 ^ R6 ;
		B[2] = ~ A[0] ;
		B[1] = R4 ;
		B[0] = A[2] ~^ R9 ;

		Z = ~ B;
	
	end
   
endmodule
