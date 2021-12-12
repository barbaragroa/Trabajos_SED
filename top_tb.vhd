library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.common.all

entity top_tb is
end top_tb;

architecture behavioral of top_tb is
-- Component Declaration for the Unit Under Test (UUT)
	component top
	port (
		CLK100MHZ : in  std_logic; --Señal de reloj
		CPU_RESETN: in  std_logic; --Boton RESET
		BTNC	  : in  std_logic; --Pulsador OK
		BTNU	  :	in	std_logic; --Pulsador +
		CA,CB,CC  : out std_logic; --
		CD,CE,CF  : out std_logic; --Catodos displays
		CG,DP 	  : out std_logic; --
		AN 		  : out std_logic_vector(3 downto 0); --Anodos displays	
	);
	end component;

	--Inputs
	signal CLK  	:	std_logic; --Señal de reloj
	signal OK		:	std_logic; --Pulsador OK
	signal RESET_N  :   std_logic; --Boton RESET
	signal PLUS		:	std_logic; --Pulsador +

	--Outputs
	signal CATH	:   std_logic_vector(0 to 7); --Catodos displays
	signal DISP	: 	std_logic_vector(3 downto 0); --Anodos displays	

	-- Clock period definitions
	constant period: time := 10 ns;

begin
	-- Instantiate the Unit Under Test (UUT)
	uut: top
	port map (
		CLK100MHZ 	=> CLK,
		CPU_RESETN 	=> RESET_N,
		BTNC	  	=> OK,
		BTNU	  	=> PLUS,
		CA 			=> CATH(0),
        CB 			=> CATH(1),
        CC 			=> CATH(2),
        CD 			=> CATH(3),
        CE 			=> CATH(4),
        CF 			=> CATH(5),
        CG 			=> CATH(6),
        DP 			=> CATH(7),
		AN 		    => DISP
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
	
			
		assert false
			report "[SUCCESS]: simulacion correcta"
			severity failure;
	end process;
end;