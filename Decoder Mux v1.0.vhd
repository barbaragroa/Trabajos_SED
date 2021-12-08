LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY decoder IS
	PORT (
		reloj:      in std_logic;                             --Estado de nuestro reloj interno.
		displays:   OUT std_logic_vector(3 DOWNTO 0);      --Número de displays en este caso pongo 4.   
		segmentos : OUT std_logic_vector(6 DOWNTO 0)     -- los 7 pines del display      
	);
END ENTITY decoder;

ARCHITECTURE multiplexor OF decoder IS (la arquitectura es un poco freestyle pero asi se podrá adaptar mejor)

	signal Cuenta              : integer range 0 to 1000000;               
	signal Seleccion           : std_logic_vector(1 DOWNTO 0) : ="00"; --palde señales que usaré luego que alternaran entre displays
	signal Mostrar             : std_logic_vector(3 DOWNTO 0) : ="0000"; --Ambos inicializados a 0.
	signal Num1,Num2,Num3,Num4 : std_logic_vector(6 DOWNTO 0); --Aquí igual hay que cambiarlo al formato de vector jusjas


BEGIN
	Conteo_Clk: process(reloj)       -- proceso de reloj (a lo mejor tienes tu una hecha ya probablemente pero cualquier cosa vale se puede apañar)
	begin
		if rising_edge(Reloj) then
		   if Cuenta < 100000 then
			Cuenta <= Cuenta+1;
		   else
			Seleccion <= Seleccion + 1;
			Cuenta <= 0;
		   end if;	
		end if;	
	end process;

	Mostrar_Displays: process(Seleccion) --Con estas dos funciones intercalas los displays (muy resumido)
	begin
		case Seleccion is 	           --Cuando Cuenta llega a 100k (por reloj) aumenta Seleccion y da un valor a Mostrar
			when "00" => 		   --En cada valor de Mostrar se mostrará el numero ya que se vuelca a Segmentos.
				Mostrar <= "1110";
			when "01" => 		
				Mostrar <= "1101";	
			when "10" => 		
				Mostrar <= "1011";
			when "11" => 		
				Mostrar <= "0111";
			when others => 		
				Mostrar <= "1111";
		end case;
		case Mostrar is 
			when "1110" =>
				Segmentos <= Num4; --0
			when "1101" =>
				Segmentos <= Num3; --1
			when "1011" =>
				Segmentos <= Num2; --2
			when "0111" =>
				Segmentos <= Num1; --3
			when others =>
				Segmentos <= "1111111"; --por poner algo pero se encenderia todo el display
		end case;
	end process;
	Displays <= Mostrar;
	Num1<="0000001"; --0	si están mal dimelo pero en principio deberian ser asi la numeración segun la documentacion tusabes
	Num2<="1001111"; --1	
	Num3<="0010010"; --2
	Num4<="0000110"; --3 
		
end multiplexor;
