library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity portas is
	port (	entrada : in integer range 0 to 63;
			botao   : in std_logic;
			refri, delvolve : out std_logic
	);
end portas;

architecture teste of portas is

	signal valor : integer range 0 to 63;
	
	type state_t is (refri_idle, refri_give, refri_reset);
	signal mystate : state_t;
	
	signal grana_total : integer range 0 to 63;
	signal pouca_grana : std_logic;
	signal grana_demais : std_logic;
	signal grana_exata : std_logic;
	
begin

	process (entrada, botao, mystate) is
	begin
		
		
		case mystate is
			when refri_idle =>
				delvolve <= '0';
				refri <= '0';
				
				
				grana_total <= valor + entrada;
				
				if (grana_total < 20) then
					pouca_grana <= '1';
				else
					pouca_grana <= '0';
				end if;
				
				if (grana_total > 20) then
					grana_demais <= '1';
				else
					grana_demais <= '0';
				end if;
				
				if (grana_total = 20) then
					grana_exata <= '1';
				else
					grana_exata <= '0';
				end if;
				
				
				if ( ((botao = '1') and (pouca_grana = '1')) or (grana_demais = '1') ) then
					mystate <=  refri_reset;
				elsif ( (botao = '1') and (grana_exata = '1') ) then
					mystate <=  refri_give;	
				else
					valor <= entrada + valor;
				end if;
				
			when refri_give =>
				refri <= '1';
				valor <= 0;
				mystate <= refri_idle;
				
			when refri_reset =>
				delvolve <= '1';
				valor <= 0;
				mystate <= refri_idle;
				
		end case;
	
	end process;
	
end teste;
