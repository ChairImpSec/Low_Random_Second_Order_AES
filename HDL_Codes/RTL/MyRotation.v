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

module MyRotation(
    input  [138:0] r,
    output [138:0] r1,
    output [138:0] r2,
    output [138:0] r3,
    output [138:0] r4,
    output [138:0] r5,
    output [138:0] r6,
    output [138:0] r7,
	 output [138:0] r8,
    output [138:0] r9,
    output [138:0] r10,
    output [138:0] r11,
    output [138:0] r12,
    output [138:0] r13,
    output [138:0] r14,
	output [138:0] r15
	);
	 
	 
	assign r1   = {r [7 :0],  r[138:8]};
	assign r2   = {r1[7 :0], r1[138:8]};
	assign r3   = {r2[7 :0], r2[138:8]};
	assign r4   = {r3[7 :0], r3[138:8]};
	assign r5   = {r4[7 :0], r4[138:8]};
	assign r6   = {r5[7 :0], r5[138:8]};
	assign r7   = {r6[7 :0], r6[138:8]};
	assign r8   = {r7 [7 :0], r7 [138:8]};
	assign r9   = {r8 [7 :0], r8 [138:8]};
	assign r10  = {r9 [7 :0], r9 [138:8]};
	assign r11  = {r10[7 :0], r10[138:8]};
	assign r12  = {r11[7 :0], r11[138:8]};
	assign r13  = {r12[7 :0], r12[138:8]};
	assign r14  = {r13[7 :0], r13[138:8]};
	assign r15  = {r14[7 :0], r14[138:8]};



endmodule
