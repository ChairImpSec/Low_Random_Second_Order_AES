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

//square & scale
module G16_sq_scl(
    input [3:0] x,
    output [3:0] q
    );

	wire [1:0] a;
	wire [1:0] b;
	wire [1:0] a_xor_b;
	wire [1:0] G4_sq_a_xor_b;
	wire [1:0] G4_sq_b;
	wire [1:0] G4_scl_N2_G4_sq_b;
	
	assign a 						= x[3:2];
	assign b 						= x[1:0];
	assign a_xor_b 				= a ^ b;
	assign G4_sq_a_xor_b 		= {a_xor_b[0], a_xor_b[1]};
	assign G4_sq_b 				= {b[0], b[1]};
	assign G4_scl_N2_G4_sq_b 	= {G4_sq_b[0] ^ G4_sq_b[1], G4_sq_b[1]};
	assign q 						= {G4_sq_a_xor_b, G4_scl_N2_G4_sq_b};
	
endmodule
