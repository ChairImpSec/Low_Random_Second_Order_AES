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
module TheFifthStage(
    input clk,
	 input [3:0] o1,
    input [3:0] o2,
    input [3:0] o3,
	 input [3:0] b1,
    input [3:0] b2,
    input [3:0] b3,
	 input [3:0] c1,
    input [3:0] c2,
    input [3:0] c3,
    input [71:0] r,
    output [7:0] y1,
    output [7:0] y2,
    output [7:0] y3
    );
	 
	 
	Masked_Mult_GF16 Mult_up (
    .clk(clk), 
    .o1(o1), 
    .o2(o2), 
    .o3(o3), 
    .b1(b1), 
    .b2(b2), 
    .b3(b3), 
    .r(r[35:0]), 
    .y1(y1[7:4]), 
    .y2(y2[7:4]), 
    .y3(y3[7:4])
    );
	 
	Masked_Mult_GF16 Mult_Down (
    .clk(clk), 
    .o1(c1), 
    .o2(c2), 
    .o3(c3), 
    .b1(o1), 
    .b2(o2), 
    .b3(o3), 
	 .r(r[71:36]), 
    .y1(y1[3:0]), 
    .y2(y2[3:0]), 
    .y3(y3[3:0])
    );


endmodule
