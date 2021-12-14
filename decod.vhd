LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use work.common.all;

ENTITY decod IS
	PORT (
		CLK       : IN std_logic;                             --Estado de nuestro reloj interno.
		AN        : OUT std_logic_vector(3 DOWNTO 0);         --Número de displays en este caso pongo 4.   
		SEGMENTS  : OUT std_logic_vector(7 DOWNTO 0)          -- los 7 pines del display y la coma
		NUM       : IN integer;                               --Numero entrante desde counter
		STATE	  : IN states_t;                              --Estado actual de la fsm
		REG 	  : IN int_vector                             --(n1, n2, n1_p, n2_p)    
	);
END ENTITY decod;

ARCHITECTURE multiplexor OF decod IS (la arquitectura es un poco freestyle pero asi se podrá adaptar mejor)

	signal Cuenta              : integer range 0 to 1000000 := 0;               
	signal Seleccion           : std_logic_vector(1 DOWNTO 0) : ="00"; --palde señales que usaré luego que alternaran entre displays
	signal Mostrar             : std_logic_vector(3 DOWNTO 0) : ="0000"; --Ambos inicializados a 0.
	signal Num1,Num2,Num3,Num4 : std_logic_vector(7 DOWNTO 0); --Aquí igual hay que cambiarlo al formato de vector jusjas


BEGIN
	Conteo_Clk: process(CLK)       -- proceso de reloj
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


Mostrar_Displays: process(Seleccion) --Con estas dos funciones intercalas los displays (muy resumido)
	begin
		case STATE is 	          
			when HOLA => 		 
				Num4 <=	"10010001" --Ultimo bit se refiere a la coma
				Num3 <= "00000011"
				Num2 <= "11100011"
				Num1 <= "00010001"

			when NUM1 => 		--
				WITH NUM SELECT
					Num3 <= 	"00000010" WHEN 0,
							"10011110" WHEN 1,
							"00100100" WHEN 2,
							"00001100" WHEN 3,
							"10011000" WHEN 4,
							"01001000" WHEN 5,
							"01000000" WHEN 6,
							"00011110" WHEN 7,
							"00000000" WHEN 8,
							"00001000" WHEN 9,
							"11111111" WHEN others;
				WITH REG(1) SELECT
					Num2 <= 	"00000011" WHEN 0,
							"10011111" WHEN 1,
							"00100101" WHEN 2,
							"00001101" WHEN 3,
							"10011001" WHEN 4,
							"01001001" WHEN 5,
							"01000001" WHEN 6,
							"00011111" WHEN 7,
							"00000001" WHEN 8,
							"00001001" WHEN 9,
							"11111111" WHEN others;
					Num1 <= "11111111"	
					Num0 <=	"11111111"

					

			when NUM2 => 		
				WITH REG(0) SELECT
					Num3 <= 	"00000011" WHEN 0,
							"10011111" WHEN 1,
							"00100101" WHEN 2,
							"00001101" WHEN 3,
							"10011001" WHEN 4,
							"01001001" WHEN 5,
							"01000001" WHEN 6,
							"00011111" WHEN 7,
							"00000001" WHEN 8,
							"00001001" WHEN 9,
							"11111111" WHEN others;
				WITH NUM SELECT
					Num2 <= 	"00000010" WHEN 0,
							"10011110" WHEN 1,
							"00100100" WHEN 2,
							"00001100" WHEN 3,
							"10011000" WHEN 4,
							"01001000" WHEN 5,
							"01000000" WHEN 6,
							"00011110" WHEN 7,
							"00000000" WHEN 8,
							"00001000" WHEN 9,
							"11111111" WHEN others;
					Num1 <= "11111111"	
					Num0 <=	"11111111"

			when CHECK => 		
				Num4 <=	"11111111"
				Num3 <= "11111111"
				Num2 <= "11111111"
				Num1 <= "11111111"
			when BIEN => 				 
				Num4 <=	"00000011"
				Num3 <= "10100001"
				Num2 <= "00010001"
				Num1 <= "10001001"

			when ERROR => 		
				Num4 <=	"01100001"
				Num3 <= "11110101"
				Num2 <= "11110101"
				Num1 <= "11000101"
			when PR1 => 		
				WITH NUM SELECT
					Num3 <= 	"00000010" WHEN 0,
							"10011110" WHEN 1,
							"00100100" WHEN 2,
							"00001100" WHEN 3,
							"10011000" WHEN 4,
							"01001000" WHEN 5,
							"01000000" WHEN 6,
							"00011110" WHEN 7,
							"00000000" WHEN 8,
							"00001000" WHEN 9,
							"11111111" WHEN others;
				WITH REG(3) SELECT
					Num2 <= 	"00000011" WHEN 0,
							"10011111" WHEN 1,
							"00100101" WHEN 2,
							"00001101" WHEN 3,
							"10011001" WHEN 4,
							"01001001" WHEN 5,
							"01000001" WHEN 6,
							"00011111" WHEN 7,
							"00000001" WHEN 8,
							"00001001" WHEN 9,
							"11111111" WHEN others;
	
					Num1 <= "11111111"	
					Num0 <=	"11111111"

			when PR2 => 		
				WITH REG(2) SELECT
					Num3 <= 	"0000001" WHEN 0,
							"1001111" WHEN 1,
							"0010010" WHEN 2,
							"0000110" WHEN 3,
							"1001100" WHEN 4,
							"0100100" WHEN 5,
							"0100000" WHEN 6,
							"0001111" WHEN 7,
							"0000000" WHEN 8,
							"0000100" WHEN 9,
							"1111111" WHEN others;

	
				Num0 <=	"11111111"
				WITH NUM SELECT
					Num2 <= 	"0000001" WHEN 0,
							"1001111" WHEN 1,
							"0010010" WHEN 2,
							"0000110" WHEN 3,
							"1001100" WHEN 4,
							"0100100" WHEN 5,
							"0100000" WHEN 6,
							"0001111" WHEN 7,
							"0000000" WHEN 8,
							"0000100" WHEN 9,
							"1111111" WHEN others;
					Num1 <= "11111111"	
					Num0 <=	"11111111"
		

			when others => 			
				Num3 <= "11111111"
				Num2 <= "11111111"
				Num1 <= "11111111"	
				Num0 <=	"11111111"
			           
		end case;
		
	end process;


	AN <= Mostrar; --Displays antes ahora se llama AN


		
end multiplexor;
