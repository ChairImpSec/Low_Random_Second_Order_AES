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

//multiply in GF(2^2) --- 2-order masked component functions 
module GF4_MUL_2OM_CF(
    input [1:0] x1,
    input [1:0] x2,
    input [1:0] x3,
    input [1:0] y1,
    input [1:0] y2,
    input [1:0] y3,
    input [5:0] r,
    output q
    );

	wire [3:1] a;
	wire [3:1] b;
	wire [3:1] c;
	wire [3:1] d;
	
	assign a = {x3[1], x2[1], x1[1]};
	assign b = {x3[0], x2[0], x1[0]};
	assign c = {y3[1], y2[1], y1[1]};
	assign d = {y3[0], y2[0], y1[0]};

	parameter num = 1;
	
	parameter Coordinate_Function = 0;
	 
	generate
	
		if(Coordinate_Function==1) begin
			if(num==0) begin
				assign q =   (a[1] ) ^ ( d[1] ) ^ ( b[1]&c[1] ) ^ ( a[1]&d[1] ) ^ ( b[1]&d[1] );
			end             
			if(num==1) begin
				assign q =   (b[2] ) ^ ( c[1] ) ^ ( b[2]&c[1] ) ^ ( a[2]&d[1] ) ^ ( b[2]&d[1] ) ^ ( c[1]&d[1] ) ^ r[0];
			end             
			if(num==2) begin
				assign q =   (a[3] ) ^ ( b[3] ) ^ ( c[1] ) ^ ( d[1] ) ^ ( b[3]&c[1] ) ^ ( a[3]&d[1] ) ^ ( b[3]&d[1] ) ^ ( c[1]&d[1] ) ^ r[1];
			end             
			if(num==3) begin
				assign q =  (b[1] ) ^ ( b[1]&c[2] ) ^ ( a[1]&d[2] ) ^ ( b[1]&d[2] ) ^ r[0];
			end             
			if(num==4) begin
				assign q =  (b[2]&c[2] ) ^ ( a[2]&d[2] ) ^ ( b[2]&d[2] );
			end             
			if(num==5) begin
				assign q =  (a[3] ) ^ ( b[3] ) ^ ( b[3]&c[2] ) ^ ( a[3]&d[2] ) ^ ( b[3]&d[2] ) ^ r[2];
			end             
			if(num==6) begin
				assign q =  (a[1] ) ^ ( b[1] ) ^ ( b[1]&c[3] ) ^ ( a[1]&d[3] ) ^ ( b[1]&d[3] ) ^ r[1];
			end             
			if(num==7) begin
				assign q =  (b[2] ) ^ ( b[2]&c[3] ) ^ ( a[2]&d[3] ) ^ ( b[2]&d[3] ) ^ r[2];
			end             
			if(num==8) begin
				assign q =  (b[3]&c[3] ) ^ ( a[3]&d[3] ) ^ ( b[3]&d[3] );
			end
		end
		
		if(Coordinate_Function==0) begin
			if(num==0) begin
				assign q =  (a[1] ) ^ ( c[1] ) ^ ( d[1] ) ^ ( a[1]&c[1] ) ^ ( b[1]&c[1] ) ^ ( a[1]&d[1] ) ^ ( c[1]&d[1] );
			end             
			if(num==1) begin
				assign q =  (a[2] ) ^ ( b[2] ) ^ ( a[2]&c[1] ) ^ ( b[2]&c[1] ) ^ ( a[2]&d[1] ) 										^ r[3];
			end             
			if(num==2) begin
				assign q =  (b[3] ) ^ ( c[1] ) ^ ( d[1] ) ^ ( a[3]&c[1] ) ^ ( b[3]&c[1] ) ^ ( a[3]&d[1] ) ^ ( c[1]&d[1] ) 	^ r[4];
			end             
			if(num==3) begin
				assign q =  (a[1] ) ^ ( a[1]&c[2] ) ^ ( b[1]&c[2] ) ^ ( a[1]&d[2] ) 														^ r[3];
			end             
			if(num==4) begin
				assign q =  (a[2]&c[2] ) ^ ( b[2]&c[2] ) ^ ( a[2]&d[2] );
			end             
			if(num==5) begin
				assign q =  (a[3] ) ^ ( b[3] ) ^ ( a[3]&c[2] ) ^ ( b[3]&c[2] ) ^ ( a[3]&d[2] ) 										^ r[5];
			end             
			if(num==6) begin
				assign q =  (a[1]&c[3] ) ^ ( b[1]&c[3] ) ^ ( a[1]&d[3] ) ^ ( c[3]&d[3] ) 												^ r[4];
			end             
			if(num==7) begin
				assign q =  (a[2] ) ^ ( b[2] ) ^ ( a[2]&c[3] ) ^ ( b[2]&c[3] ) ^ ( a[2]&d[3] ) 										^ r[5];
			end             
			if(num==8) begin
				assign q =  (a[3] ) ^ ( a[3]&c[3] ) ^ ( b[3]&c[3] ) ^ ( a[3]&d[3] ) ^ ( c[3]&d[3] );
			end
		end

	endgenerate

endmodule
									
