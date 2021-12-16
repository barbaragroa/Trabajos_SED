library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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

architecture behavioral of decod is

	signal Cuenta      : integer := 0;               
	signal Seleccion   : std_logic_vector(1 downto 0) := "00";
	signal Mostrar     : std_logic_vector(3 downto 0) := "0000";
	signal D0,D1,D2,D3 : std_logic_vector(7 downto 0);

begin
	process(CLK)
	begin
		if rising_edge(CLK) then
		   if Cuenta < 100000 then
			Cuenta <= Cuenta + 1;
		   else
			Seleccion <= std_logic_vector(to_unsigned(to_integer(unsigned(Seleccion)) + 1, 2));
			Cuenta <= 0;
		   end if;	
		end if;	
	end process;

    with Seleccion select
        Mostrar <= "0001" when "00",
                   "0010" when "01",
                   "0100" when "10",
                   "1000" when "11",
                   "0000" when others;
    with Mostrar select
        SEGMENTS <= D0 when "0001",
                    D1 when "0010",
                    D2 when "0100",
                    D3 when "1000",
                    "11111111" when others;

    process(STATE, NUM, REG)
    begin
		case STATE is 	          
			when HOLA => 		 
				D3 <= "10010001"; --H
				D2 <= "00000011"; --o
				D1 <= "11100011"; --l
				D0 <= "00010001"; --a

			when NUM1 =>
				D3 <= "11111111";	
				D2 <= "11111111";
			    case REG(1) is
			         when 0 =>       D1 <= "00000011";
			         when 1 =>       D1 <= "10011111";
			         when 2 =>       D1 <= "00100101";
			         when 3 =>       D1 <= "00001101";
			         when 4 =>       D1 <= "10011001";
			         when 5 =>       D1 <= "01001001";
			         when 6 =>       D1 <= "01000001";
			         when 7 =>       D1 <= "00011111";
			         when 8 =>       D1 <= "00000001";
			         when 9 =>       D1 <= "00001001";
			         when others =>  D1 <= "11111111";
			    end case;
			    case NUM is
			         when 0 =>       D0 <= "00000010";
			         when 1 =>       D0 <= "10011110";
			         when 2 =>       D0 <= "00100100";
			         when 3 =>       D0 <= "00001100";
			         when 4 =>       D0 <= "10011000";
			         when 5 =>       D0 <= "01001000";
			         when 6 =>       D0 <= "01000000";
			         when 7 =>       D0 <= "00011110";
			         when 8 =>       D0 <= "00000000";
			         when 9 =>       D0 <= "00001000";
			         when others =>  D0 <= "11111111";
			    end case;

			when NUM2 => 	
				D3 <= "11111111";	
				D2 <= "11111111";
			    case NUM is
			         when 0 =>       D1 <= "00000010";
			         when 1 =>       D1 <= "10011110";
			         when 2 =>       D1 <= "00100100";
			         when 3 =>       D1 <= "00001100";
			         when 4 =>       D1 <= "10011000";
			         when 5 =>       D1 <= "01001000";
			         when 6 =>       D1 <= "01000000";
			         when 7 =>       D1 <= "00011110";
			         when 8 =>       D1 <= "00000000";
			         when 9 =>       D1 <= "00001000";
			         when others =>  D1 <= "11111110";
			    end case;
			    case REG(0) is
			         when 0 =>       D0 <= "00000011";
			         when 1 =>       D0 <= "10011111";
			         when 2 =>       D0 <= "00100101";
			         when 3 =>       D0 <= "00001101";
			         when 4 =>       D0 <= "10011001";
			         when 5 =>       D0 <= "01001001";
			         when 6 =>       D0 <= "01000001";
			         when 7 =>       D0 <= "00011111";
			         when 8 =>       D0 <= "00000001";
			         when 9 =>       D0 <= "00001001";
			         when others =>  D0 <= "11111111";
			    end case;

			when CHECK => 		
				D3 <= "11111111";
				D2 <= "11111111";
				D1 <= "11111111";
				D0 <= "11111111";
			when BIEN => 				 
				D3 <= "00000011"; --O
				D2 <= "10100001"; --k
				D1 <= "00010001"; --a
				D0 <= "10001001"; --y

			when ERROR => 		
				D3 <= "01100001"; --E
				D2 <= "11110101"; --r
				D1 <= "11110101"; --r
				D0 <= "11000101"; --o
				
			when PR1 => 		
				D3 <= "11111111";	
				D2 <= "11111111";
			    case REG(3) is
			         when 0 =>       D1 <= "00000011";
			         when 1 =>       D1 <= "10011111";
			         when 2 =>       D1 <= "00100101";
			         when 3 =>       D1 <= "00001101";
			         when 4 =>       D1 <= "10011001";
			         when 5 =>       D1 <= "01001001";
			         when 6 =>       D1 <= "01000001";
			         when 7 =>       D1 <= "00011111";
			         when 8 =>       D1 <= "00000001";
			         when 9 =>       D1 <= "00001001";
			         when others =>  D1 <= "11111111";
			    end case;
			    case NUM is
			         when 0 =>       D0 <= "00000010";
			         when 1 =>       D0 <= "10011110";
			         when 2 =>       D0 <= "00100100";
			         when 3 =>       D0 <= "00001100";
			         when 4 =>       D0 <= "10011000";
			         when 5 =>       D0 <= "01001000";
			         when 6 =>       D0 <= "01000000";
			         when 7 =>       D0 <= "00011110";
			         when 8 =>       D0 <= "00000000";
			         when 9 =>       D0 <= "00001000";
			         when others =>  D0 <= "11111111";
			    end case;

			when PR2 => 		
				D3 <= "11111111";	
				D2 <= "11111111";
			    case NUM is
			         when 0 =>       D1 <= "00000010";
			         when 1 =>       D1 <= "10011110";
			         when 2 =>       D1 <= "00100100";
			         when 3 =>       D1 <= "00001100";
			         when 4 =>       D1 <= "10011000";
			         when 5 =>       D1 <= "01001000";
			         when 6 =>       D1 <= "01000000";
			         when 7 =>       D1 <= "00011110";
			         when 8 =>       D1 <= "00000000";
			         when 9 =>       D1 <= "00001000";
			         when others =>  D1 <= "11111110";
			    end case;
			    case REG(2) is
			         when 0 =>       D0 <= "00000011";
			         when 1 =>       D0 <= "10011111";
			         when 2 =>       D0 <= "00100101";
			         when 3 =>       D0 <= "00001101";
			         when 4 =>       D0 <= "10011001";
			         when 5 =>       D0 <= "01001001";
			         when 6 =>       D0 <= "01000001";
			         when 7 =>       D0 <= "00011111";
			         when 8 =>       D0 <= "00000001";
			         when 9 =>       D0 <= "00001001";
			         when others =>  D0 <= "11111111";
			    end case;

			when others => 			
				D3 <= "11111111";
				D2 <= "11111111";
				D1 <= "11111111";
				D0 <= "11111111";
			           
		end case;
	end process;

	AN <= not Mostrar; --Displays antes ahora se llama AN

end behavioral;
