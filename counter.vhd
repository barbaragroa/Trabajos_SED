library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity counter is
	PORT (
		clk : in std_logic; --Clock
		CE : in std_logic; --Chip Enable
        reset : in std_logic; --Reset
		code : out std_logic_vector(3 downto 0) --Valor de 0 a 9
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
			if CE='1' then
				cuenta <= (cuenta+1) mod 10;
			end if;
		end if;		
	end process;
	code <= std_logic_vector(to_unsigned(cuenta,4));
end behavioral;
