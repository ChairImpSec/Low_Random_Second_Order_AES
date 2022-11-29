-----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de) and Amir Moradi (amir.moradi@rub.de) 
-- DOCUMENT: [New First-Order Secure AES Performance Records](IACR Transactions on Cryptographic Hardware and Embeded Systems 2021(2))
-- -----------------------------------------------------------------
--
-- Copyright (c) 2022, Aein Rezaei Shahmirzadi, Amir Moradi, 
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Cipher is
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           InputData0 	: in  STD_LOGIC_VECTOR (127 downto 0);
           InputData1 	: in  STD_LOGIC_VECTOR (127 downto 0);
           InputData2 	: in  STD_LOGIC_VECTOR (127 downto 0);
           Key0 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Key1 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Key2 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Static_r     : in  STD_LOGIC_VECTOR (138 downto 0);
           Guards     : in  STD_LOGIC_VECTOR (39 downto 0);
           Dynamic_r    : in  STD_LOGIC_VECTOR (63 downto 0);
           OutputData0 	: out  STD_LOGIC_VECTOR (127 downto 0);
           OutputData1 	: out  STD_LOGIC_VECTOR (127 downto 0);
           OutputData2 	: out  STD_LOGIC_VECTOR (127 downto 0);
           done 			: out  STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
	
	COMPONENT Sbox_State
	PORT(
		clk : IN std_logic;
		Guards_MUX_sel : IN std_logic;
		Static_r : IN std_logic_vector(138 downto 0);
		Dynamic_r : IN std_logic_vector(63 downto 0);
		Guards : IN std_logic_vector(31 downto 0);
		In_state1 : IN std_logic_vector(127 downto 0);
		In_state2 : IN std_logic_vector(127 downto 0);
		In_state3 : IN std_logic_vector(127 downto 0);          
		result1 : OUT std_logic_vector(127 downto 0);
		result2 : OUT std_logic_vector(127 downto 0);
		result3 : OUT std_logic_vector(127 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Sbox_Key
	PORT(
		clk : IN std_logic;
		Guards_MUX_sel : IN std_logic;
		Guards_Reg_EN : IN std_logic;
		Static_r : IN std_logic_vector(138 downto 0);
		Guards : IN std_logic_vector(7 downto 0);
		In_state1 : IN std_logic_vector(31 downto 0);
		In_state2 : IN std_logic_vector(31 downto 0);
		In_state3 : IN std_logic_vector(31 downto 0);          
		result1 : OUT std_logic_vector(31 downto 0);
		result2 : OUT std_logic_vector(31 downto 0);
		result3 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Controller
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		FinalRound : OUT std_logic;
		Guards_MUX_sel : OUT std_logic;
		Guards_KeyReg_EN : OUT std_logic;
		KeyRegEn : OUT std_logic;
		Rcon : OUT std_logic_vector(7 downto 0);
		done : OUT std_logic
		);
	END COMPONENT;
	
	---------------------------- 
	-- Encryption Process ------
	signal AddRoundKeyOutput0				: STD_LOGIC_VECTOR(127 downto 0);
	signal SBoxOutput0						: STD_LOGIC_VECTOR(127 downto 0);

	signal AddRoundKeyOutput1				: STD_LOGIC_VECTOR(127 downto 0);
	signal SBoxOutput1						: STD_LOGIC_VECTOR(127 downto 0);
	
	signal AddRoundKeyOutput2				: STD_LOGIC_VECTOR(127 downto 0);
	signal SBoxOutput2						: STD_LOGIC_VECTOR(127 downto 0);
	
	---------------------------- 
	-- Key Schedule ------------
	signal KeySboxInput0						: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeySboxOutput0					: STD_LOGIC_VECTOR( 31 downto 0);

	signal KeySboxInput1						: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeySboxOutput1					: STD_LOGIC_VECTOR( 31 downto 0);
	
	signal KeySboxInput2						: STD_LOGIC_VECTOR( 31 downto 0);
	signal KeySboxOutput2					: STD_LOGIC_VECTOR( 31 downto 0);

	---------------------------- 
	-- Control Logic -----------
	signal Guards_KeyReg_EN						: STD_LOGIC;
	signal Guards_MUX_sel						: STD_LOGIC;
	signal FinalRound							: STD_LOGIC;
	signal KeyRegEn							: STD_LOGIC;
	signal Rcon									: STD_LOGIC_VECTOR(7 downto 0);
	
begin

	OutputData0 <= AddRoundKeyOutput0;
	OutputData1 <= AddRoundKeyOutput1;
	OutputData2 <= AddRoundKeyOutput2;
	
	Round0: ENTITY work.round
	PORT MAP(
		clk 					=> clk,
		rst 					=> rst,
		FinalRound			=> FinalRound,
		KeyRegEn				=> KeyRegEn,
		Rcon					=> Rcon,
		InputData 			=> InputData0,
		InputKey 			=> Key0,
		AddRoundKeyOutput	=> AddRoundKeyOutput0,
		SBoxOutput			=> SBoxOutput0,
		KeySboxInput		=> KeySboxInput0,
		KeySboxOutput		=> KeySboxOutput0);
		
	Round1: ENTITY work.round
	PORT MAP(
		clk 					=> clk,
		rst 					=> rst,
		FinalRound			=> FinalRound,
		KeyRegEn				=> KeyRegEn,
		Rcon					=> (others => '0'),
		InputData 			=> InputData1,
		InputKey				=> Key1,
		AddRoundKeyOutput	=> AddRoundKeyOutput1,
		SBoxOutput			=> SBoxOutput1,
		KeySboxInput		=> KeySboxInput1,
		KeySboxOutput		=> KeySboxOutput1);
		
	Round2: ENTITY work.round
	PORT MAP(
		clk 					=> clk,
		rst 					=> rst,
		FinalRound			=> FinalRound,
		KeyRegEn				=> KeyRegEn,
		Rcon					=> (others => '0'),
		InputData 			=> InputData2,
		InputKey				=> Key2,
		AddRoundKeyOutput	=> AddRoundKeyOutput2,
		SBoxOutput			=> SBoxOutput2,
		KeySboxInput		=> KeySboxInput2,
		KeySboxOutput		=> KeySboxOutput2);
	
	Masked_Sbox_State: Sbox_State PORT MAP(
		clk => clk,
		Guards_MUX_sel => Guards_MUX_sel,
		Static_r => Static_r,
		Guards => Guards(31 downto 0),
		Dynamic_r => Dynamic_r,
		In_state1 => AddRoundKeyOutput0,
		In_state2 => AddRoundKeyOutput1,
		In_state3 => AddRoundKeyOutput2,
		result1 => SBoxOutput0,
		result2 => SBoxOutput1,
		result3 => SBoxOutput2
	);
	
	Masked_KeySbox: Sbox_Key PORT MAP(
		clk => clk,
		Guards_MUX_sel => Guards_MUX_sel,
		Guards_Reg_EN => Guards_KeyReg_EN,
		Static_r => Static_r,
		Guards => Guards(39 downto 32),
		In_state1 => KeySboxInput0,
		In_state2 => KeySboxInput1,
		In_state3 => KeySboxInput2,
		result1 => KeySboxOutput0,
		result2 => KeySboxOutput1,
		result3 => KeySboxOutput2
	);

	
	---------------------------- 
	------ FSM -----------------
	
	Controller_FSM: Controller 
	PORT MAP(
		clk 				=> clk,
		rst			 	=> rst,
		FinalRound 		=> FinalRound,
		Guards_MUX_sel 		=> Guards_MUX_sel,
		Guards_KeyReg_EN 		=> Guards_KeyReg_EN,
		Rcon 				=> Rcon,
		KeyRegEn 		=> KeyRegEn,
		done 				=> done
	);
	
end Behavioral;

