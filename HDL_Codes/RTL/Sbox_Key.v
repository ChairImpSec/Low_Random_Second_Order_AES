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


module Sbox_Key(
    input clk,
    input Guards_MUX_sel,
    input Guards_Reg_EN,
    input [138:0] Static_r,
    input [7:0] Guards,
	input [31:0] In_state1,
	input [31:0] In_state2,
	input [31:0] In_state3,
	output [31:0] result1,
	output [31:0] result2,
	output [31:0] result3
	
    );
    
    parameter [63:0] Rand = 64'h75eb0c287699fd157710bee7e700a893fe9c52a41f5f894f5dcee55257934947;

	reg [31:0] state1;
	reg [31:0] state2;
	reg [31:0] state3;

	integer j;
	reg [7:0] Byte1 [3:0];
	reg [7:0] Byte2 [3:0];
	reg [7:0] Byte3 [3:0];
	
	reg [7:0] OutByte1 [3:0];
	reg [7:0] OutByte2 [3:0];
	reg [7:0] OutByte3 [3:0];
	
	wire [138:0] PermutedRandomness [3:0];
	
	reg  [7:0] Guards_Reg;
	wire [7:0] Guards_out [3:0];
	wire [7:0] Guards_MUX_output;
	
	always @(*) begin
	    state1 = In_state1;
		state2 = In_state2;
		state3 = In_state3;
	end

	always @(posedge clk) begin
	
		if(Guards_Reg_EN) begin
		  Guards_Reg <= Guards_out[0];
        end
        
	end
 assign Guards_MUX_output = Guards_MUX_sel ? Guards : Guards_Reg;

 
 assign PermutedRandomness[0] = {Static_r [123 :120],  Static_r[138:124]};
 assign PermutedRandomness[1] = {Static_r [127 :124],  Static_r[138:128]};
 assign PermutedRandomness[2] = {Static_r [131 :128],  Static_r[138:132]};
 assign PermutedRandomness[3] = {Static_r [135 :132],  Static_r[138:136]};

	always @(*) begin 
		for (j=0; j < 4; j=j+1) begin
			Byte1[j] = state1[8*j +: 8];
			Byte2[j] = state2[8*j +: 8];
			Byte3[j] = state3[8*j +: 8];
		end
	end
	
	genvar i;
	generate
      for (i=0; i < 3; i=i+1) 
      begin: SboxInstance
	  AESSbox_2OM Sbox_d2 (
		.clk(clk), 
		.x1(Byte1[i]), 
		.x2(Byte2[i]), 
		.x3(Byte3[i]), 
		.Guards(Guards_out[i+1]),  
		.r(PermutedRandomness[i]), 
		.dr(Rand[16*(i%4) +: 16]), 
		.Guards_out(Guards_out[i]), 
		.out1(result1[8*i +: 8]), 
		.out2(result2[8*i +: 8]), 
		.out3(result3[8*i +: 8])
		);
      end

   endgenerate
   
    AESSbox_2OM Sbox_d2_3 (
		.clk(clk), 
		.x1(Byte1[3]), 
		.x2(Byte2[3]), 
		.x3(Byte3[3]), 
		.Guards(Guards_MUX_output),  
		.r(PermutedRandomness[3]), 
		.dr(Rand[16*3 +: 16]), 
		.Guards_out(Guards_out[3]), 
		.out1(result1[8*3 +: 8]), 
		.out2(result2[8*3 +: 8]), 
		.out3(result3[8*3 +: 8])
		);
   



endmodule
