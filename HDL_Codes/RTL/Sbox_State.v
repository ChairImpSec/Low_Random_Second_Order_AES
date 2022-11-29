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

module Sbox_State(
	input clk,
	input Guards_MUX_sel,
	input [138:0] Static_r,
	input [31:0] Guards,
	input [63:0] Dynamic_r,
	input [127:0] In_state1,
	input [127:0] In_state2,
	input [127:0] In_state3,
	output [127:0] result1,
	output [127:0] result2,
	output [127:0] result3 );
	
	wire  [31:0] Guards_MUX_output;
	reg [127:0] state1;
	reg [127:0] state2;
	reg [127:0] state3;

	integer j;
	reg [7:0] Byte1 [15:0];
	reg [7:0] Byte2 [15:0];
	reg [7:0] Byte3 [15:0];
	
	reg [7:0] OutByte1 [15:0];
	reg [7:0] OutByte2 [15:0];
	reg [7:0] OutByte3 [15:0];
	
	reg [31:0] Guards_SR [9:0];
	wire [7:0] Guards_out [15:0];
	
	wire [138:0] PermutedRandomness [15:0];
	
	always @(*) begin
	    state1 = In_state1;
		state2 = In_state2;
		state3 = In_state3;
	end

	always @(posedge clk) begin
        for (j=0; j < 9; j=j+1) begin
          Guards_SR[j] <= Guards_SR[j+1];
        end
        Guards_SR[9] <= {Guards_out[12], Guards_out[8], Guards_out[4], Guards_out[0]};
	end
	
	assign Guards_MUX_output = Guards_MUX_sel ? Guards : Guards_SR[0];
	
	MyRotation MyRotation1 (
		.r(Static_r), 
		.r1(PermutedRandomness[1]), 
		.r2(PermutedRandomness[2]), 
		.r3(PermutedRandomness[3]), 
		.r4(PermutedRandomness[4]), 
		.r5(PermutedRandomness[5]), 
		.r6(PermutedRandomness[6]), 
		.r7(PermutedRandomness[7]),
		.r8(PermutedRandomness[8]), 
		.r9(PermutedRandomness[9]), 
		.r10(PermutedRandomness[10]), 
		.r11(PermutedRandomness[11]), 
		.r12(PermutedRandomness[12]), 
		.r13(PermutedRandomness[13]), 
		.r14(PermutedRandomness[14]),
		.r15(PermutedRandomness[15])
	);
 
	assign PermutedRandomness[0] = Static_r;

	always @(*) begin 
		for (j=0; j < 16; j=j+1) begin
			Byte1[j] = state1[8*j +: 8];
			Byte2[j] = state2[8*j +: 8];
			Byte3[j] = state3[8*j +: 8];
		end
	end

	genvar i;
    generate
    for (i=0; i < 16; i=i+1) 
    begin: SboxInstance
        
        if((i == 3) || (i == 7) || (i == 11) || (i == 15)) begin
            AESSbox_2OM Sbox_d2 (
            .clk(clk), 
            .x1(Byte1[i]), 
            .x2(Byte2[i]), 
            .x3(Byte3[i]), 
            .Guards(Guards_MUX_output[8*(i>>2) +: 8]), 
            .r(PermutedRandomness[i]), 
            .dr(Dynamic_r[16*(i%4) +: 16]), 
            .Guards_out(Guards_out[i]), 
            .out1(result1[8*i +: 8]), 
            .out2(result2[8*i +: 8]), 
            .out3(result3[8*i +: 8])
            );
        end
        else begin
            AESSbox_2OM Sbox_d2 (
            .clk(clk), 
            .x1(Byte1[i]), 
            .x2(Byte2[i]), 
            .x3(Byte3[i]),
            .Guards(Guards_out[i+1]), 
            .r(PermutedRandomness[i]), 
            .dr(Dynamic_r[16*(i%4) +: 16]), 
            .Guards_out(Guards_out[i]), 
            .out1(result1[8*i +: 8]), 
            .out2(result2[8*i +: 8]), 
            .out3(result3[8*i +: 8])
            );
        end
    end

   endgenerate
   



endmodule
