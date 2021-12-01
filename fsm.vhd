library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.common.all;

entity fsm is
	port (
		RESET_N   : in  std_logic; --Boton RESET
		CLK       : in  std_logic; --Señal de reloj
		OK		  : in  std_logic; --Pulsador OK
		NUM		  : in  integer; --Numero entrante desde counter
		STATE	  : out states_t; --Estado actual de la fsm
		REG 	  : out int_vector --(n1, n2, n1_p, n2_p)
	);
end fsm;

architecture behavioral of fsm is
	signal	current_state	:	 states_t;
	signal	next_state		:	 states_t;
	
	signal	n1_p	:	integer	:=	0; --Num1 programado
	signal	n2_p	:	integer :=	0; --Num2 programado
	signal	n1	:	integer	:=	0; --Num1 actual
	signal	n2	:	integer	:=	0; --Num2 actual
  
begin
	state_register: process (RESET_N, CLK)
	begin
		if RESET_N = '0' then
			current_state <= HOLA;
		elsif rising_edge(CLK) then
			current_state <= next_state;     
		end if;
	end process;
  
	nextstate_decod: process (OK, current_state)
	begin
		next_state <= current_state;
		
		case current_state is
		when HOLA => --Estado de inicio
			if OK = '1' then 
				next_state <= NUM1;
			end if;
		when NUM1 => --Primer numero
			if OK = '1' then
			    next_state <= NUM2;  
				n1 <= NUM;
			end if;
		when NUM2 => --Segundo numero
			if OK = '1' then   
				n2 <= NUM;
				next_state <= CHECK;
			end if;
		when CHECK => --Comprobacion clave
			if n1 = n1_p and n2 = n2_p then      
				next_state <= BIEN;
			else
				next_state <= ERROR;
			end if;
		when BIEN => --Clave correcta
			if OK = '1' then   
				next_state <= PR1;
			end if;
		when ERROR => --Clave incorrecta
			if OK = '1' then   
				next_state <= NUM1;
			end if;
		when PR1 => --Programacion primera cifra
			if OK = '1' then  
				n1_p <= NUM;
				next_state <= PR2;
			end if;
		when PR2 => --Programacion segunda cifra
			if OK = '1' then  
				n2_p <= NUM;
				next_state <= HOLA;
			end if;	
		when others => --Estados indeterminados
			next_state <= HOLA;
		end case;
	end process;

	STATE <= current_state;
	REG <= (0=>n1, 1=>n2, 2=>n1_p, 3=>n2_P);
end behavioral;