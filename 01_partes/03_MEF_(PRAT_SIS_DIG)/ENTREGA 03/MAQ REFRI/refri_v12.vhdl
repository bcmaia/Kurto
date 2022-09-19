library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity maq_refri is
    -- entrada: 0: nada, 1: 5 cent, 2: 10 cent, 3: 25 cent, 4 : 50 cent, 5: 1 real
	port (	entrada : in std_logic_vector(2 downto 0) := "000";
			botao, rst, clk : in std_logic;
			refri, devolve : out std_logic);
end maq_refri;

architecture arch_refri of maq_refri is

    type state_t is (refri_idle, refri_give, refri_reset);

    signal current_state : state_t := refri_idle;
    signal next_state : state_t := refri_idle;
    signal grana_total : integer range 0 to 63 := 0;
    signal moeda_de_entrada : integer range 0 to 63 := 0;

begin
    comb:process (clk) is
    begin
        if falling_edge(clk) then
            next_state <= current_state;
            
            case current_state is
                when refri_idle =>

                    devolve <= '0';
                    refri <= '0';

                    if botao = '1' then

                        if grana_total + moeda_de_entrada = 20 then
                            next_state <= refri_give;
                        else
                            next_state <= refri_reset;
                        end if;

                    else 

                        if grana_total + moeda_de_entrada >= 20 then
                            if moeda_de_entrada = 0 then 
                                next_state <= refri_reset;
                            else 
                                grana_total <= grana_total + moeda_de_entrada;
                                next_state <= refri_idle;
                            end if;
                        else 
                            grana_total <= grana_total + moeda_de_entrada;
                            next_state <= refri_idle;
                        end if;

                    end if;

                    
                when refri_give =>

                    grana_total <= 0;
                    devolve <= '0';
                    refri <= '1';

                    next_state <= refri_idle;
                    
                when refri_reset =>
                    devolve <= '1';
                    grana_total <= 0;
                    next_state <= refri_idle;
            end case;

            report "moeda_de_entrada: " & integer'image(moeda_de_entrada);
            report "grana total: " & integer'image(grana_total);
            report "grana_total + moeda_de_entrada: " & integer'image(grana_total + moeda_de_entrada);

        end if;
    end process comb;

    mem:process(rst, clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                --grana_total <= 0;
                current_state <= refri_idle;
            else
                current_state <= next_state;
            end if;

            case entrada is
                when "001" =>
                    moeda_de_entrada <= 1;
                when "010" =>
                    moeda_de_entrada <= 2;
                when "011" =>
                    moeda_de_entrada <= 5;
                when "100" => 
                    moeda_de_entrada <= 10;
                when "101" => 
                    moeda_de_entrada <= 20;
                when others =>
                    moade_de_entrada <= 0;
            end case;

        end if;
    end process mem;
end arch_refri;

