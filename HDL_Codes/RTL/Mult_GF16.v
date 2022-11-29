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
module Mult_GF16(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output [3:0] y
    );
	 
	 parameter __ADD_CONSTANT = 0;
	 
	 wire [3:0] mult_res;
	 wire x0;
	 wire x1;
	 wire x2;
	 wire x3;
	 wire x4;
	 wire x5;
	 wire x6;
	 wire x7;
	 
	 assign x0 = a[0];
	 assign x1 = a[1];
	 assign x2 = a[2];
	 assign x3 = a[3];
	 
	 assign x4 = b[0];
	 assign x5 = b[1];
	 assign x6 = b[2];
	 assign x7 = b[3];

	 
	assign mult_res[0] = (x0 &x4 ) ^ (x1 &x4 ) ^ (x2 &x4 ) ^ (x0 &x5 ) ^ (x3 &x5 ) ^ (x0 &x6 ) ^ (x2 &x6 ) ^ (x1 &x7 ) ^ (x3 &x7 );
	assign mult_res[1] = (x0 &x4 ) ^ (x3 &x4 ) ^ (x1 &x5 ) ^ (x2 &x5 ) ^ (x3 &x5 ) ^ (x1 &x6 ) ^ (x3 &x6 ) ^ (x0 &x7 ) ^ (x1 &x7 ) ^ (x2 &x7 ) ^ (x3 &x7 );
	assign mult_res[2] = (x0 &x4 ) ^ (x2 &x4 ) ^ (x1 &x5 ) ^ (x3 &x5 ) ^ (x0 &x6 ) ^ (x2 &x6 ) ^ (x3 &x6 ) ^ (x1 &x7 ) ^ (x2 &x7 );
	assign mult_res[3] = (x1 &x4 ) ^ (x3 &x4 ) ^ (x0 &x5 ) ^ (x1 &x5 ) ^ (x2 &x5 ) ^ (x3 &x5 ) ^ (x1 &x6 ) ^ (x2 &x6 ) ^ (x0 &x7 ) ^ (x1 &x7 ) ^ (x3 &x7 );
	
	generate 
	
		if(__ADD_CONSTANT == 1) assign y = mult_res ^ c;
		else 							assign y = mult_res;
	
	endgenerate 


endmodule
