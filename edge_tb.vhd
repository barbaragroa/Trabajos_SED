library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_EDGEDTCTR is
end tb_EDGEDTCTR;

architecture test of tb_EDGEDTCTR is
component EDGEDTCTR is
 port (
 CLK : in std_logic;
 SYNC_IN : in std_logic;
 EDGE : out std_logic
 );
end component;

--Inputs
  signal clk : std_logic;
  signal sync_in : std_logic;

--Outputs
  signal edges : std_logic;


  constant CLK_PERIOD: time := 1ns;
  constant DELAY: time := 0.1 * CLK_PERIOD;

begin
  uut:EDGEDTCTR
  port map(
    CLK=>clk,
    SYNC_IN=>sync_in,
    EDGE=>edges
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
    --Comprobamos funcionamiento
    wait until clk='1';
    wait until sync_in='1';
    wait for delay;
    assert edges='1'
      report "[ERROR]"
      severity failure;
    
    wait for delay;
      
    wait until clk='0';
    wait for delay;
    assert edges='1'
      report "[ERROR]"
      severity failure;
    
    assert false
      report "[Buen Funcionamiento]"
      severity failure;
  end process;
end;
