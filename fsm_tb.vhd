library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity fsm_tb is
	generic(cifras	:	integer := 2);
	
	type int_vector is array(0 to 2*cifras - 1) of integer;
	type states_t is (HOLA, NUM1, NUM2, CHECK, BIEN, ERROR, PR1, PR2);
end fsm_tb;

architecture behavioral of fsm_tb is 
	-- Component Declaration for the Unit Under Test (UUT)
	component fsm
	port (
		RESET_N   : in  std_logic; --Boton RESET
		CLK       : in  std_logic; --Señal de reloj
		OK		  : in  std_logic; --Pulsador OK
		NUM		  : in  integer; --Numero entrante desde counter
		STATE	  : out states_t; --Estado actual de la fsm
		REG 	  : out int_vector --(n1, n2, n1_p, n2_p)
	);
	end component;

	--Inputs
	signal RESET_N	:	std_logic;
	signal CLK      :	std_logic;
	signal OK		: 	std_logic;
	signal NUM		:	integer;

	--Outputs
	signal STATE    :	states_t;
	signal REG 		:	integer(0 to 3);

	-- Clock period definitions
	constant period: time := 10 ns;

begin
	-- Instantiate the Unit Under Test (UUT)
	uut: fsm
	port map (
		RESET_N => RESET_N,
		CLK => CLK,
		OK => OK,
		NUM => NUM,
		STATE => STATE,
		REG => REG
    );

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for 0.5 * period;
		clk <= '1';
		wait for 0.5 * period;
	end process;

	-- Stimulus process
	stim_proc: process
	begin
		RESET_N <= '0';
		wait for period;
		RESET_N <= '1';
		
		assert STATE = HOLA
			report "[FAIL]: HOLA"
			severity failure;	

			OK <= '1';
			wait for period;
			OK <= '0';
			
		assert STATE = NUM1
			report "[FAIL]: NUM1"
			severity failure;	

			NUM <= 0;
			wait for 0.5*period;
			OK <= '1';
			wait for 0.5*period;
			OK <= '0';
			
		assert REG(0)=0
			report "[FAIL]: REG(n1)"
			severity failure;
		assert STATE = NUM2
			report "[FAIL]: NUM2"
			severity failure;

			OK <= '1';
			wait for period;
			OK <= '0';

		assert REG(1)=0
			report "[FAIL]: REG(n2)"
			severity failure;
		assert STATE = CHECK
			report "[FAIL]: CHECK"
			severity failure;
			
			OK <= '1';
			wait for period;
			OK <= '0';		
			
		assert STATE = BIEN
			report "[FAIL]: BIEN"
			severity failure;	
			
			OK <= '1';
			wait for period;
			OK <= '0';		
			
		assert STATE = PR1
			report "[FAIL]: PR1"
			severity failure;	

			NUM <= 4;
			wait for 0.5*period;
			OK <= '1';
			wait for 0.5*period;
			OK <= '0';	
			
		assert REG(2)=4
			report "[FAIL]: REG(n1_p)"
			severity failure;
		assert STATE = PR2
			report "[FAIL]: PR2"
			severity failure;	

			NUM <= 6;
			wait for 0.5*period;
			OK <= '1';
			wait for 0.5*period;
			OK <= '0';	

		assert REG(3)=6
			report "[FAIL]: REG(n2_p)"
			severity failure;
		assert STATE = HOLA
			report "[FAIL]: HOLA_2"
			severity failure;			
			
			OK <= '1';
			wait for period;
			OK <= '0';
			
		assert STATE = NUM1
			report "[FAIL]: NUM1_2"
			severity failure;	

			NUM <= 4;
			wait for 0.5*period;
			OK <= '1';
			wait for 0.5*period;
			OK <= '0';
			
		assert REG(0)=4
			report "[FAIL]: REG(n1)_2"
			severity failure;
		assert STATE = NUM2
			report "[FAIL]: NUM2_2"
			severity failure;

			NUM <= 6;
			wait for 0.5*period;
			OK <= '1';
			wait for 0.5*period;
			OK <= '0';

		assert REG(1)=6
			report "[FAIL]: REG(n2)_2"
			severity failure;
		assert STATE = CHECK
			report "[FAIL]: CHECK"
			severity failure;
			
			OK <= '1';
			wait for period;
			OK <= '0';		
			
		assert STATE = BIEN
			report "[FAIL]: BIEN"
			severity failure;	
			
		assert false
			report "[SUCCESS]: simulacion correcta"
			severity failure;
	end process;
end;