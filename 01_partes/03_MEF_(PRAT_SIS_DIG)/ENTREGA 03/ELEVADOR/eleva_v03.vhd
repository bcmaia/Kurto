library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity portas is
	port (	clk, master_clr : in std_logic;
			entrada : in integer range 0 to 16;
			andar_atual : out integer range 0 to 16;
			em_movimento : out std_logic);
end portas;

architecture teste of portas is

	type state_t is (E_STANDBY, E_DESCE, E_SOBE);
	signal mystate : state_t := E_STANDBY;

	signal posicao : integer range 0 to 15 := 1;
	signal destino : integer range 0 to 15 := 1;

begin

	process (clk)
	begin
		if (clk'event and clk = '1') then
			
			if (master_clr = '1') then
				mystate <= E_STANDBY;
				destino <= posicao;
				em_movimento <= '0';
			end if;
			
			case mystate is
			
				when E_STANDBY =>
					em_movimento <= '0';
				
					if ( (entrada /= 0) and (entrada /= destino) ) then 
						destino <= entrada;
					end if;
					
					if (posicao < destino) then 
						mystate <= E_SOBE;
					elsif (posicao > destino) then 
						mystate <= E_DESCE;
					else
						mystate <= E_STANDBY;
					end if;
					
				when E_SOBE =>
					em_movimento <= '1';
					posicao <= posicao + 1;
					andar_atual <= posicao;
					
					if (posicao = destino) then 
						mystate <= E_STANDBY;
					end if;
					
				when E_DESCE =>
					em_movimento <= '1';
					posicao <= posicao - 1;
					andar_atual <= posicao;
					
					if (posicao = destino) then 
						mystate <= E_STANDBY;
					end if;
					
			
			end case;
		
		end if;
	end process;
end teste;
