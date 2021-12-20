library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_SYNCHRNZR is
end tb_SYNCHRNZR;

architecture test of tb_SYNCHRNZR is
component SYNCHRNZR is
 port (
   CLK : in std_logic;
   ASYNC_IN : in std_logic;
   SYNC_OUT : out std_logic
 	);
end component;

--Inputs
  signal clk : std_logic;
  signal async_in : std_logic;

--Outputs
  signal sync_out : std_logic;


  constant CLK_PERIOD: time := 10 ns;
  constant DELAY: time := 0.1 * CLK_PERIOD;

begin
  uut:SYNCHRNZR
  port map(
    CLK=>clk,
    ASYNC_IN=>async_in,
    SYNC_OUT=>sync_out
  );
  
--Clock process
 clk_gen:process
  begin
    clk<='0';
    wait for 0.5* CLK_PERIOD;
    clk<='1';
    wait for 0.5* CLK_PERIOD;
  end process;
  
--Stimulus process
sync_in<= '0' after 0.25 * CLK_PERIOD, '1' after 0.75 * CLK_PERIOD;

  stim_proc:process
  begin
    wait until clk='1';
    wait for delay;
      assert false
      report "[Buen Funcionamiento]"
      severity failure;
  end process;
end;
