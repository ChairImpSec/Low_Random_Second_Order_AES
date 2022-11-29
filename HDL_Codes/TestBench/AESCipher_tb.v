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

module AESCipher_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [127:0] InputData0;
	reg [127:0] InputData1;
	reg [127:0] InputData2;
	reg [127:0] Key0;
	reg [127:0] Key1;
	reg [127:0] Key2;
	reg [138:0] Static_r;
	reg [63:0] Dynamic_r;
	reg [39:0] Guards;

	// Outputs
	wire [127:0] OutputData0;
	wire [127:0] OutputData1;
	wire [127:0] OutputData2;
	wire [127:0] OutputData;
	reg [127:0] PlainText;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	Cipher uut (
		.clk(clk), 
		.rst(rst), 
		.InputData0(InputData0), 
		.InputData1(InputData1), 
		.InputData2(InputData2), 
		.Key0(Key0), 
		.Key1(Key1), 
		.Key2(Key2), 
		.Static_r(Static_r), 
		.Guards(Guards), 
		.Dynamic_r(Dynamic_r), 
		.OutputData0(OutputData0), 
		.OutputData1(OutputData1), 
		.OutputData2(OutputData2), 
		.done(done)
	);

	assign OutputData = OutputData0 ^ OutputData1 ^ OutputData2;
	
	initial begin
		// Initialize Inputs
		//$stop;

		clk = 0;
		rst = 0;
		#20
		rst = 1;
		PlainText = 128'h340737e0a29831318d305a88a8f64332;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;

		Key2 = {$random, $random, $random, $random} ;
		Key1 = {$random, $random, $random, $random} ;
		Key0 = 128'h3c4fcf098815f7aba6d2ae2816157e2b ^ Key1 ^ Key2;
		
		Static_r = 0;
		Guards = 0;
		Dynamic_r = 0;
//		#10
//		rst = 0;
		// Wait 100 ns for global reset to finish
		#200;
		PlainText = 128'h0;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h0123456789abcdef0123456789abcdef;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h00112233445566778899aabbccddeeff;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h340737e0a29831318d305a88a8f64332;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h99a3b83af1cc35ae5abb54fdfcae9a7a;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h98b7f0cdab31bd08a87578c5e898277a;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h68799cfef8bb24f5365ddf0b896283eb;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h3bdfeda677b8225724bcd2eb1593d76e;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
		PlainText = 128'h4b52a4f3c66b51ebc9c7950820e1d3cf;
		InputData2 = {$random, $random, $random, $random};
		InputData1 = {$random, $random, $random, $random};
		InputData0 = PlainText ^ InputData1 ^ InputData2;
		#10 
      rst = 0;
		 
		@(posedge done) begin
			
			#5;
		
			if(OutputData == 128'h320b6a19978511dcfb09dc021d842539) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h320b6a19978511dcfb09dc021d842539);
				$stop;
			end
			#10;
			if(OutputData == 128'h6f541bb947f0423eb399b81a0c6bf77d) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h6f541bb947f0423eb399b81a0c6bf77d);
				$stop;
			end
			#10;
			if(OutputData == 128'h67f231d4d67ef497245075cfa63b5ae0) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h67f231d4d67ef497245075cfa63b5ae0);
				$stop;
			end
			#10;
			if(OutputData == 128'hc1b8350e659b5d432f1bb87a1c67492f) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'hc1b8350e659b5d432f1bb87a1c67492f);
				$stop;
			end
			#10;
			if(OutputData == 128'h320b6a19978511dcfb09dc021d842539) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h320b6a19978511dcfb09dc021d842539);
				$stop;
			end
			#10;
			if(OutputData == 128'had7a02a9862bac4e36b649779324ab13) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'had7a02a9862bac4e36b649779324ab13);
				$stop;
			end
			#10;
			if(OutputData == 128'hb6c94686f1f76ab457ff95d16a23150f) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'hb6c94686f1f76ab457ff95d16a23150f);
				$stop;
			end
			#10;
			if(OutputData == 128'ha2b86782588a5ba8cca5fb4b4cb44917) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'ha2b86782588a5ba8cca5fb4b4cb44917);
				$stop;
			end
			#10;
			if(OutputData == 128'ha7443a6f215571ad4ec4f076ea69b78a) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'ha7443a6f215571ad4ec4f076ea69b78a);
				$stop;
			end
			#10;
			if(OutputData == 128'h963e2febb8560f31a2305a8db95aecf6) begin
				$write("------------------PASS---------------\n");
			end
			else begin
				$write("------------------FAIL---------------\n");
				$write("%x\n%x\n",OutputData,128'h963e2febb8560f31a2305a8db95aecf6);
				$stop;
			end
			#10;
			$stop;
		end
		 
		// Add stimulus here

	end
	
	
   always #5 clk = ~clk;
	
//	always @(negedge clk) begin
//		r = {$random, $random, $random, $random, $random};
//	end
endmodule

