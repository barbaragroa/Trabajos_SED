library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.common.all;

entity decod_tb is
end decod_tb;

architecture behavioral of decod_tb is
-- Component Declaration for the Unit Under Test (UUT)
	component decod
	port (
		CLK 	: in  std_logic; --Señal de reloj
		AN 		: out std_logic_vector(3 downto 0); --Anodos displays
		SEGMENTS: out std_logic_vector(7 downto 0); --Catodos displays		
		NUM		: in integer; --Numero entrante desde counter
		STATE	: in states_t; --Estado de la FSM
		REG 	: in int_vector --(n1, n2, n1_p, n2_p)
	);
	end component;

	--Inputs
	signal CLK  	:	std_logic; --Señal de reloj
	signal STATE	:   states_t; --Estado de la FSM
	signal REG 		:   int_vector; --(n1, n2, n1_p, n2_p)
	signal NUM		:	integer; --Numero entrante desde counter
	
	--Outputs
	signal SEGMENTS	:   std_logic_vector(0 to 7); --Catodos displays
	signal AN		: 	std_logic_vector(3 downto 0); --Anodos displays	

	-- Clock period definitions
	constant period: time := 10 ns;

begin
	-- Instantiate the Unit Under Test (UUT)
	uut: decod
	port map (
		CLK 	 => CLK,
		AN 		 => AN,
		SEGMENTS => SEGMENTS,
		NUM		 => NUM,
		STATE	 => STATE,
		REG 	 => REG
    );

	-- Clock process definitions
	clk_process: process
	begin
		clk <= '0';
		wait for 0.5 * period;
		clk <= '1';
		wait for 0.5 * period;
	end process;

	-- Stimulus process
	stim_proc: process
	begin
	
		REG <= (0=>4, 1=>0, 2=>4, 3=>0);
		STATE <= HOLA;
		wait for 500*period;
		
		
		assert AN="0001"
			report "[FAIL]: Anodo A"
			severity failure;
		assert SEGMENTS="00010001"
			report "[FAIL]: Catodos A"
			severity failure;
			
		wait for 1000*period;
		assert AN="0010"
			report "[FAIL]: Anodo L"
			severity failure;			
		assert SEGMENTS="11100011"
			report "[FAIL]: Catodos L"
			severity failure;

		wait for 1000*period;
		assert AN="0100"
			report "[FAIL]: Anodo O"
			severity failure;
		assert SEGMENTS="00000011"
			report "[FAIL]: Catodos O"
			severity failure;
			
		wait for 1000*period;
		assert AN="1000"
			report "[FAIL]: Anodo H"
			severity failure;
		assert SEGMENTS="10010001"
			report "[FAIL]: Catodos H"
			severity failure;
			
		
		NUM <= 4;
		STATE <= NUM1;
		wait for 1000*period;
		
		
		assert AN="0001"
			report "[FAIL]: Anodo 0 Num1"
			severity failure;
		assert SEGMENTS="10011000"
			report "[FAIL]: Catodos 0 Num1"
			severity failure;
			
		wait for 1000*period;
		assert AN="0010"
			report "[FAIL]: Anodo 1 Num1"
			severity failure;			
		assert SEGMENTS="00000011"
			report "[FAIL]: Catodos 1 Num1"
			severity failure;

		wait for 1000*period;
		assert AN="0100"
			report "[FAIL]: Anodo 2 Num1"
			severity failure;
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 2 Num1"
			severity failure;
			
		wait for 1000*period;
		assert AN="1000"
			report "[FAIL]: Anodo 3 Num1"
			severity failure;
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 3 Num1"
			severity failure;
		
		
		NUM <= 0;
		STATE <= NUM2;
		wait for 1000*period;
		
		
		assert AN="0001"
			report "[FAIL]: Anodo 0 Num2"
			severity failure;
		assert SEGMENTS="10011001"
			report "[FAIL]: Catodos 0 Num2"
			severity failure;
			
		wait for 1000*period;
		assert AN="0010"
			report "[FAIL]: Anodo 1 Num2"
			severity failure;			
		assert SEGMENTS="00000010"
			report "[FAIL]: Catodos 1 Num2"
			severity failure;

		wait for 1000*period;
		assert AN="0100"
			report "[FAIL]: Anodo 2 Num2"
			severity failure;
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 2 Num2"
			severity failure;
			
		wait for 1000*period;
		assert AN="1000"
			report "[FAIL]: Anodo 3 Num2"
			severity failure;
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 3 Num2"
			severity failure;
		
		
		STATE <= CHECK;
		wait for 1000*period;
		
		
		assert AN="0001"
			report "[FAIL]: Anodo 0 Check"
			severity failure;
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 0 Check"
			severity failure;
			
		wait for 1000*period;
		assert AN="0010"
			report "[FAIL]: Anodo 1 Check"
			severity failure;			
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 1 Check"
			severity failure;

		wait for 1000*period;
		assert AN="0100"
			report "[FAIL]: Anodo 2 Check"
			severity failure;
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 2 Check"
			severity failure;
			
		wait for 1000*period;
		assert AN="1000"
			report "[FAIL]: Anodo 3 Check"
			severity failure;
		assert SEGMENTS="11111111"
			report "[FAIL]: Catodos 3 Check"
			severity failure;
		
		
		STATE <= ERROR;
		wait for 1000*period;
		
		
		assert AN="0001"
			report "[FAIL]: Anodo 0 Error"
			severity failure;
		assert SEGMENTS="11000101"
			report "[FAIL]: Catodos 0 Error"
			severity failure;
			
		wait for 1000*period;
		assert AN="0010"
			report "[FAIL]: Anodo 1 Error"
			severity failure;			
		assert SEGMENTS="11110101"
			report "[FAIL]: Catodos 1 Error"
			severity failure;

		wait for 1000*period;
		assert AN="0100"
			report "[FAIL]: Anodo 2 Error"
			severity failure;
		assert SEGMENTS="11110101"
			report "[FAIL]: Catodos 2 Error"
			severity failure;
			
		wait for 1000*period;
		assert AN="1000"
			report "[FAIL]: Anodo 3 Error"
			severity failure;
		assert SEGMENTS="01100001"
			report "[FAIL]: Catodos 3 Error"
			severity failure;
		
		
		assert false
			report "[SUCCESS]: simulacion correcta"
			severity failure;
	end process;
end;