library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity elevador is
    port (
        andar_requisitado: in std_logic_vector(3 downto 0);
        --requisitado indica se tem alguem chamando o elevador
        clk, requisitado: in std_logic;
        --posicao atual do elevador
        posicao: out std_logic_vector(3 downto 0) := "0000";
        --direcao: '0' indica descendo, '1' indica subindo
        direcao: out std_logic := '0';
        --andando: '0' indica parado, '1' indica que esta andando
        andando: out std_logic := '0'
    );

end elevador;

architecture arch_elevador of elevador is

    type state_t is (up, down, stop);

    --signal andar : integer range 0 to 15 := 0;
    signal current_state : state_t := stop;
    signal next_state : state_t;
    signal destino : std_logic_vector(3 downto 0) := "0000";

    constant subindo : std_logic := '1';
    constant descendo : std_logic := '0';

begin

    --impr:process(destino, andar_requisitado, requisitado, saida)
    --begin

    --end process impr;

    comb:process(clk) is 
    begin
        if rising_edge(clk) then

            next_state <= current_state;

            case current_state is 
                when stop =>

                    andando <= '0';

                    if requisitado = '1' and posicao /= destino then

                        if posicao < destino then
                            next_state <= up;
                        else 
                            next_state <= down;
                        end if;

                    end if;

                when up =>

                    if posicao = andar_requisitado then
                        next_state <= stop;
                    end if;

                    andando <= '1';
                    direcao <= subindo;

                when down =>

                    if posicao = andar_requisitado then 
                        next_state <= stop;
                    end if;

                    andando <= '1';
                    direcao <= descendo;

        end if

    end process comb;

    mem:process(clk) is 
    begin
        if rst = '1' then

            current_state <= stop;
            andando <= '0';
            posicao <= "0000";

        elsif falling_edge(clk) then

            destino <= andar_requisitado;
            current_state <= next_state;

            if next_state = subindo then
                posicao <= posicao + "0001";
            elsif next_state = descendo then
                posicao <= posicao - "0001";
            end if;

        end if;

    end process mem;

    impr:process(clk) is
    begin
    end process impr;

end arch_elevador;

