library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity counter is
	PORT (
		CLK	: in std_logic; --Clock
		UP	: in std_logic; 
		DOWN	: in std_logic; 
       		RESET	: in std_logic; --Reset
		NUM	: out integer
	);
end counter;

architecture behavioral of counter is
	signal cuenta : integer range 0 to 9:=0;
begin
	process (clk)
	begin
    	if reset='0' then
          cuenta<=0;
        end if;
		if rising_edge(clk) then
			if UP = '1' then
				cuenta <= (cuenta+1) mod 10;
			elsif DOWN = '1' then
				cuenta <= (cuenta-1) mod 10;
			end if;
		end if;		
	end process;
	NUM <= cuenta;
end behavioral;
