library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.common.all;

entity top is
	port ( 
		CLK100MHZ : in  std_logic; --Señal de reloj
		CPU_RESETN: in  std_logic; --Boton RESET
		BTNC	  : in  std_logic; --Pulsador OK
		BTNU	  :	in	std_logic; --Pulsador +
		CA,CB,CC  : out std_logic; --..
		CD,CE,CF  : out std_logic; --Catodos displays
		CG,DP 	  : out std_logic; --..
		AN 		  : out std_logic_vector(7 downto 0) --Anodos displays	
	);
end top;

architecture structural of top is
	component fsm
		port ( --Maquina de estados
			CLK      : in  std_logic; --Señal de reloj
			RESET_N  : in  std_logic; --Boton RESET
			OK		 : in  std_logic; --Pulsador OK
			NUM		 : in  integer; --Numero entrante desde counter
			STATE	 : out states_t; --Estado actual de la fsm
			REG 	 : out int_vector --(n1, n2, n1_p, n2_p)
		);
	end component;
    component synchrnzr
        port ( --Sincronizador
            CLK 	 : in std_logic;
		    ASYNC_IN : in std_logic;
		    SYNC_OUT : out std_logic
		);
    end component;
    component edgedtctr
        port ( --Detector de flancos
			CLK 	 : in std_logic;
			SYNC_IN  : in std_logic;
			EDGE	 : out std_logic
		);
    end component;
	component counter
        port ( --Contador 0-9
			CLK 	 : in std_logic; --Señal de reloj
			CE 		 : in std_logic; --Chip Enable
			NUM 	 : out integer --Entero 0-9
		);
    end component; 
    component decod
        port ( --Decodificador displays
			CLK 	: in  std_logic; --Señal de reloj+
			AN 		: out std_logic_vector(3 downto 0); --Anodos displays
			SEGMENTS: out std_logic_vector(7 downto 0); --Catodos displays		
			NUM		: in integer; --Numero entrante desde counter
			STATE	: in states_t; --Estado de la FSM
			REG 	: in int_vector --(n1, n2, n1_p, n2_p)
		);
    end component; 
	
    signal SYNC1, EDGE1: std_logic;
    signal SYNC2, EDGE2: std_logic;
	signal NUM		   : integer;
	signal STATE	   : states_t;
	signal REG 		   : int_vector;
	signal SEGMENTS	   : std_logic_vector(7 downto 0);
	signal ANODOS      : std_logic_vector(3 downto 0);
    
begin

synchrnzr1: 	synchrnzr 	port map (CLK100MHZ, BTNC, SYNC1); 
edgedtctr1:   	edgedtctr 	port map (CLK100MHZ, SYNC1, EDGE1);
maquinaestados:	fsm 		port map (CLK100MHZ, CPU_RESETN, EDGE1, NUM, STATE, REG);
synchrnzr2: 	synchrnzr 	port map (CLK100MHZ, BTNU, SYNC2); 
edgedtctr2:   	edgedtctr 	port map (CLK100MHZ, SYNC2, EDGE2);
contador:		counter		port map (CLK100MHZ, EDGE2, NUM);
decodificador:	decod		port map (CLK100MHZ, ANODOS, SEGMENTS, NUM, STATE, REG);

(CA,CB,CC,CD,CE,CF,CG,DP) <= SEGMENTS;

AN(7 downto 4) <= (others => '1');
AN(3 downto 0) <= ANODOS;

end architecture structural;