library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.common.all;

entity decod is
	port (
		CLK       : in std_logic;                     --Señal de reloj
		AN        : out std_logic_vector(3 downto 0); --Número de displays
		SEGMENTS  : out std_logic_vector(7 downto 0); --Catodos del display
		NUM       : in integer;                       --Numero entrante desde counter
		STATE	  : in states_t;                      --Estado actual de la fsm
		REG 	  : in int_vector                     --(n1, n2, n1_p, n2_p)    
	);
end entity decod;

architecture multiplexor of decod is

	signal Cuenta              : integer range 0 to 1000000 := 0;               
	signal Seleccion           : std_logic_vector(1 downto 0) := "00";
	signal Mostrar             : std_logic_vector(3 downto 0) := "0000";
	signal Num0,Num1,Num2,Num3 : std_logic_vector(7 downto 0);


begin
	Conteo_Clk: process(CLK)
	begin
		if rising_edge(CLK) then
		   if Cuenta < 100000 then
			Cuenta <= Cuenta + 1;
		   else
			Seleccion <= Seleccion + 1;
			Cuenta <= 0;
		   end if;	
		end if;	
	end process;

	Mostrar_Displays: process(Seleccion) --Con estas dos funciones intercalas los displays
	begin
		case Seleccion is 	           --Cuando Cuenta llega a 100k (por reloj) aumenta Seleccion y da un valor a Mostrar
			when "00" => 		   --En cada valor de Mostrar se mostrará el numero ya que se vuelca a Segmentos.
				Mostrar <= "0001";
			when "01" => 		
				Mostrar <= "0010";	
			when "10" => 		
				Mostrar <= "0100";
			when "11" => 		
				Mostrar <= "1000";
			when others => 		
				Mostrar <= "0000";
		end case;
		case Mostrar is 
			when "0001" =>
				SEGMENTS <= Num0; --0
			when "0010" =>
				SEGMENTS <= Num1; --1
			when "0100" =>
				SEGMENTS <= Num2; --2
			when "1000" =>
				SEGMENTS <= Num3; --3
			when others =>
				SEGMENTS <= "11111111";
		end case;
	end process;


Mostra: process(Seleccion) --Con estas dos funciones intercalas los displays (muy resumido)
	begin
		case STATE is 	          
			when HOLA => 		 
				Num3 <=	"10010001"; --Ultimo bit se refiere a la coma
				Num2 <= "00000011";
				Num1 <= "11100011";
				Num0 <= "00010001";

			when NUM1 =>
				with NUM select
					Num3 <= "00000010" when 0,
							"10011110" when 1,
							"00100100" when 2,
							"00001100" when 3,
							"10011000" when 4,
							"01001000" when 5,
							"01000000" when 6,
							"00011110" when 7,
							"00000000" when 8,
							"00001000" when 9,
							"11111111" when others;
				with REG(1) select
					Num2 <= 	"00000011" when 0,
							"10011111" when 1,
							"00100101" when 2,
							"00001101" when 3,
							"10011001" when 4,
							"01001001" when 5,
							"01000001" when 6,
							"00011111" when 7,
							"00000001" when 8,
							"00001001" when 9,
							"11111111" when others;
				Num1 <= "11111111";	
				Num0 <=	"11111111";

					

			when NUM2 => 		
				with REG(0) select
					Num3 <= 	"00000011" when 0,
							"10011111" when 1,
							"00100101" when 2,
							"00001101" when 3,
							"10011001" when 4,
							"01001001" when 5,
							"01000001" when 6,
							"00011111" when 7,
							"00000001" when 8,
							"00001001" when 9,
							"11111111" when others;
				with NUM select
					Num2 <= 	"00000010" when 0,
							"10011110" when 1,
							"00100100" when 2,
							"00001100" when 3,
							"10011000" when 4,
							"01001000" when 5,
							"01000000" when 6,
							"00011110" when 7,
							"00000000" when 8,
							"00001000" when 9,
							"11111111" when others;
				Num1 <= "11111111";	
				Num0 <=	"11111111";

			when CHECK => 		
				Num3 <=	"11111111";
				Num2 <= "11111111";
				Num1 <= "11111111";
				Num0 <= "11111111";
			when BIEN => 				 
				Num3 <=	"00000011";
				Num2 <= "10100001";
				Num1 <= "00010001";
				Num0 <= "10001001";

			when ERROR => 		
				Num3 <=	"01100001";
				Num2 <= "11110101";
				Num1 <= "11110101";
				Num0 <= "11000101";
			when PR1 => 		
				with NUM select
					Num3 <= 	"00000010" when 0,
							"10011110" when 1,
							"00100100" when 2,
							"00001100" when 3,
							"10011000" when 4,
							"01001000" when 5,
							"01000000" when 6,
							"00011110" when 7,
							"00000000" when 8,
							"00001000" when 9,
							"11111111" when others;
				with REG(3) select
					Num2 <= 	"00000011" when 0,
							"10011111" when 1,
							"00100101" when 2,
							"00001101" when 3,
							"10011001" when 4,
							"01001001" when 5,
							"01000001" when 6,
							"00011111" when 7,
							"00000001" when 8,
							"00001001" when 9,
							"11111111" when others;
	
				Num1 <= "11111111";	
				Num0 <=	"11111111";

			when PR2 => 		
				with REG(2) select
					Num3 <= 	"0000001" when 0,
							"1001111" when 1,
							"0010010" when 2,
							"0000110" when 3,
							"1001100" when 4,
							"0100100" when 5,
							"0100000" when 6,
							"0001111" when 7,
							"0000000" when 8,
							"0000100" when 9,
							"1111111" when others;

						Num1 <= "11111111";	

				Num0 <=	"11111111";
				with NUM select
					Num2 <= 	"0000001" when 0,
							"1001111" when 1,
							"0010010" when 2,
							"0000110" when 3,
							"1001100" when 4,
							"0100100" when 5,
							"0100000" when 6,
							"0001111" when 7,
							"0000000" when 8,
							"0000100" when 9,
							"1111111" when others;
				Num1 <= "11111111";	
				Num0 <=	"11111111";
		

			when others => 			
				Num3 <= "11111111";
				Num2 <= "11111111";
				Num1 <= "11111111"	;
				Num0 <=	"11111111";
			           
		end case;
		
	end process;


	AN <= Mostrar; --Displays antes ahora se llama AN

end multiplexor;
