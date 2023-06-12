--------------------------------------
-- Biblioteca
--------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

--------------------------------------
-- Entidade
--------------------------------------
ENTITY cripto_module IS
    PORT (
        start : IN STD_LOGIC; -- Entrada
        enc_dec : IN STD_LOGIC; -- Entrada
        reset : IN STD_LOGIC; -- Entrada
        clock : IN STD_LOGIC; -- Entrada
        data_i : IN STD_LOGIC_VECTOR(63 DOWNTO 0); -- Entrada
        key_i : IN STD_LOGIC_VECTOR(255 DOWNTO 0); -- Entrada

        busy : OUT STD_LOGIC; -- Saída
        ready : OUT STD_LOGIC; -- Saída
        data_o : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) -- Saída

    );

END ENTITY;

--------------------------------------
-- Arquitetura
--------------------------------------

ARCHITECTURE cripto_module OF cripto_module IS

    TYPE STATE IS (IDLE, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16, E17, E18, E19, E20, E21); -- Etapas da máquina de estados   N SEI SE PRECISA DE RESET OU N AINDA
    SIGNAL EA : state; -- Estado atual
    SIGNAL EF : state; -- Estado futuro 
    SIGNAL for_num : STD_LOGIC := '0'; --- quando for 0 é o primeiro e qnd for ''1' é o segundo o acabou
    SIGNAL for_num_1 : STD_LOGIC := '0'; --- quando for 0 é o primeiro e qnd for ''1' é o segundo o acabou
    SIGNAL done_sig_1 : STD_LOGIC := '0'; --- quando for 1 o acabou
    SIGNAL done_sig_2 : STD_LOGIC := '0'; --- quando for 1 o acabou
    SIGNAL done_sig_3 : STD_LOGIC := '0'; --- quando for 1 o acabou
    SIGNAL K : INTEGER RANGE 0 TO 2; -- VAI DE 0 A 2
    SIGNAL I : INTEGER RANGE 0 TO 7; -- VAI DE 0 A 7
    SIGNAL J : INTEGER RANGE 0 TO 7; -- VAI DE 0 A 7
    SIGNAL CONT : INTEGER RANGE 0 TO 7;
    SIGNAL CM1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL N1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL N2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SN : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL NI : STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE matriz IS ARRAY(NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL s_box : matriz (0 TO 7, 0 TO 15) := ((x"04", x"0A", x"09", x"02", x"0D", x"08", x"00", x"0E", x"06", x"0B", x"01", x"0C", x"07", x"0F", x"05", x"03"),
                                                (x"0E", x"0B", x"04", x"0C", x"06", x"0D", x"0F", x"0A", x"02", x"03", x"08", x"01", x"00", x"07", x"05", x"09"),
                                                (x"05", x"08", x"01", x"0D", x"0A", x"03", x"04", x"02", x"0E", x"0F", x"0C", x"07", x"06", x"00", x"09", x"0B"),
                                                (x"07", x"0D", x"0A", x"01", x"00", x"08", x"09", x"0F", x"0E", x"04", x"06", x"0C", x"0B", x"02", x"05", x"03"),
                                                (x"06", x"0C", x"07", x"01", x"05", x"0F", x"0D", x"08", x"04", x"0A", x"09", x"0E", x"00", x"03", x"0B", x"02"),
                                                (x"04", x"0B", x"0A", x"00", x"07", x"02", x"01", x"0D", x"03", x"06", x"08", x"05", x"09", x"0C", x"0F", x"0E"),
                                                (x"0D", x"0B", x"04", x"01", x"03", x"0F", x"05", x"09", x"00", x"0A", x"0E", x"07", x"06", x"08", x"02", x"0C"),
                                                (x"01", x"0F", x"0D", x"00", x"05", x"07", x"0A", x"04", x"09", x"02", x"03", x"0E", x"06", x"0B", x"08", x"0C"));


    TYPE VETOR IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL KEY : VETOR (0 TO 7); 

    BEGIN
    
    busy <= '0' when EA = IDLE else '1'; -- quando chega no idle n ta ocupado

    --máquina de estados -------------------
    PROCESS (reset, clock)
    BEGIN

        IF reset = '1' THEN
            data_o <= (others=>'0');
            EA <= IDLE;
            N1 <= (OTHERS => '0'); -- ZEREI O VETOR TODO DO N1
            N2 <= (OTHERS => '0');
            NI <= (OTHERS => '0');
            key <= (OTHERS =>(OTHERS => '0'));
            CM1 <= (OTHERS => '0');
            done_sig_1 <= '0';
            done_sig_2 <= '0'; 
            done_sig_3 <= '0'; 
            CONT <= 0;
            --for_num <= '0';
           -- for_num_1 <= '0';                      
        
        ELSIF rising_edge(clock) THEN
            EA <= EF;
            IF EA = IDLE THEN
                CONT <= 0;
                N1 <= (OTHERS => '0'); -- ZEREI O VETOR TODO DO N1
                N2 <= (OTHERS => '0');
                NI <= (OTHERS => '0');
                key <= (OTHERS =>(OTHERS => '0'));
                CM1 <= (OTHERS => '0');
                K <= 0;
                I <= 0;
                J<= 0;
                
            ELSIF EA = E2 THEN
                N1 <= data_i(31 DOWNTO 0);
                N2 <= data_i(63 DOWNTO 32);
                key <= (key_i(255 DOWNTO 224), key_i(223 DOWNTO 192), key_i(191 DOWNTO 160), key_i(159 DOWNTO 128), key_i(127 DOWNTO 96), key_i(95 DOWNTO 64), key_i(63 DOWNTO 32), key_i(31 DOWNTO 0));

            ELSIF EA = E3 THEN
                k <= 0; -- inicializer o cont em 0
                i <= 0; -- inicializei em 0

            ELSIF EA = E4 THEN
                CM1 <= N1 + key(i);
                SN <= (OTHERS => '0'); -- INICIALIZAR EM 0

            ELSIF EA = E5 THEN
                J <= 0;

            ELSIF EA = E6 THEN
                SN <= SN OR (std_logic_vector(shift_left(unsigned(x"00000000" OR (x"000000" & (s_box(j,to_integer(unsigned((shift_right(unsigned(CM1),(4 * (7 - j))) MOD 16))))))),(28 - (4 * j)))(SN'range)));

            ELSIF EA = E7 THEN
                J <= J + 1;

            ELSIF EA = E8 THEN
                N2 <= N1;
                N1 <= ( std_logic_vector(shift_right(unsigned(SN), 21)(N1'range)) OR std_logic_vector(shift_left(unsigned(SN), 11)(N1'range)) ) XOR N2;

            ELSIF EA = E9 THEN
                IF for_num = '0' THEN
                    IF I < 7 THEN
                        I <= I + 1;
                    ELSIF I = 7 AND K < 3 THEN
                        K <= K + 1;
                        I <= 0;
                    END IF;
                ELSIF for_num = '1' THEN
                    IF CONT /= 0 THEN
                        IF I > 0 THEN
                            I <= I - 1;
                        ELSE 
                            done_sig_1 <= '1';
                        END IF;
                    END IF;

                    IF I = 7 THEN
                        CONT <= CONT + 1;
                    END IF;
                END IF;

            ELSIF EA = E10 THEN
                j <= 0;

            ELSIF EA = E11 THEN
                data_o(31 DOWNTO 0) <= N2;
                data_o(63 DOWNTO 32) <= N1;

            ELSIF EA = E12 THEN
                data_o <= (others=>'0');
                N2 <= data_i(31 DOWNTO 0);
                N1 <= data_i(63 DOWNTO 32);
                key <= (key_i(255 DOWNTO 224), key_i(223 DOWNTO 192), key_i(191 DOWNTO 160), key_i(159 DOWNTO 128), key_i(127 DOWNTO 96), key_i(95 DOWNTO 64), key_i(63 DOWNTO 32), key_i(31 DOWNTO 0));

            ELSIF EA = E13 THEN
                i <= 0; -- inicializei em 0
                K <= 0;

            ELSIF EA = E14 THEN
                CM1 <= N1 + key(i);
                SN <= (OTHERS => '0'); -- INICIALIZAR EM 0

            ELSIF EA = E15 THEN
                J <= 0;

            ELSIF EA = E16 THEN
                SN <= SN OR (std_logic_vector(shift_left(unsigned(x"00000000" OR (x"000000" & (s_box(j,to_integer(unsigned((shift_right(unsigned(CM1),(4 * (7 - j))) MOD 16))))))),(28 - (4 * j)))(SN'range)));

            ELSIF EA = E17 THEN
                J <= J + 1;

            ELSIF EA = E18 THEN
                N2 <= N1;
                N1 <= ( std_logic_vector(shift_right(unsigned(SN), 21)(N1'range)) OR std_logic_vector(shift_left(unsigned(SN), 11)(N1'range)) ) XOR N2;

            ELSIF EA = E19 THEN
                IF for_num_1 = '0' THEN
                    IF I < 7 THEN
                        I <= I + 1;
                    END IF;
                ELSIF for_num_1 = '1' THEN
                done_sig_3 <= '1';
                    IF CONT /= 0 THEN 
                        IF I > 0 THEN
                        I <= I - 1;
                        ELSIF I = 0 AND K < 3 THEN
                        K <= K + 1;
                        I <= 7;
                        --- CONT <= 0;
                        ELSIF I = 0 AND K = 2 THEN ------------------------------ SE NENHUM DOS DOIS ACIMA ACONTECER  QUER DIZER QUE TUDO JÁ ACABOU
                        done_sig_2 <= '1';
                        END IF;
                    END IF;
                    IF I = 7 THEN
                        CONT <= CONT + 1;
                    END IF;
                END IF;
                
            ELSIF EA = E20 THEN
                j <= 0;

            ELSIF EA = E21 THEN
                data_o(31 DOWNTO 0) <= N2;
                data_o(63 DOWNTO 32) <= N1;

            END IF;
        END IF;
    END PROCESS;

    PROCESS (EA, start, done_sig_2,done_sig_1,for_num)
    BEGIN
        CASE EA IS
            WHEN IDLE =>
                ready <= '0';
                IF start = '1' AND enc_dec = '1' THEN
                    EF <= E2;
                ELSIF start = '1' AND enc_dec = '0' THEN
                    EF <= E12;
                END IF;

            WHEN E2 => -- ARMAZENAMENTO ENC
                    EF <= E3;
    
            WHEN E3 => -- INICIAÇÃO DO PRIMEIRO FOR ENC
                    EF <= E4;

            WHEN E4 => --SOMA DA CHAVE ENC
                    IF done_sig_1 = '1' THEN
                    EF <= E11;
                    ELSE
                    EF <= E5;
                    END IF;

            WHEN E5 => --INICIAÇAO DO FOR DO GOST ROUND ENC
                    EF <= E6;

            WHEN E6 => -- OPERAÇÕES DENTRO DO FOR DO GOST ROUND ENC
                IF j < 7 THEN 
                    EF <= E7;
                ELSE
                    EF <= E8;
                END IF;

            WHEN E7 => --ICNCREMETENTA CONT DO FOR DO GOST ROUND ENC
                    EF <= E6;
              
            WHEN E8 => --OPERAÇÃO FINAL DA FUNÇÃO GOST ROUND ENC
                    EF <= E9;

            WHEN E9 => -- INCREMENTA/DECREMETNA CONTADORES DOS FORS DO ENC
                IF I = 7 AND K = 2 THEN
                    for_num <= '1';
                    EF <= E10;
                ELSIF done_sig_1 = '1' THEN
                    EF <= E11;
                ELSE
                    EF <= E4;
                END IF;

            WHEN E10 => --INICIAÇÃO DO SEGUNDO FOR ENC
                    EF <= E4;

            WHEN E11 => -- ULTIMA PARTE DA ENC
                    ready <= '1';
                    EF <= IDLE;

            WHEN E12 => -- ARMAZENAMENTO DEC
                    EF <= E13;

            WHEN E13 => -- INICIAÇÃO DO PRIMEIRO FOR DEC
                    EF <= E14;

            WHEN E14 => --SOMA DA CHAVE DEC
                    EF <= E15;

            WHEN E15 => --INICIAÇAO DO FOR DO GOST ROUND DEC
                    EF <= E16;

            WHEN E16 => -- OPERAÇÕES DENTRO DO FOR DO GOST ROUND DEC
                IF j < 7 THEN 
                    EF <= E17;
                ELSE
                    EF <= E18;
                END IF;

            WHEN E17 => --ICNCREMETENTA CONT DO FOR DO GOST ROUND DEC
                    EF <= E16;

            WHEN E18 => --OPERAÇÃO FINAL DA FUNÇÃO GOST ROUND DEC
                    EF <= E19;

            WHEN E19 => -- INCREMENTA/DECREMETNA CONTADORES DOS FORS DO DEC
                IF I = 7 AND K = 0 and done_sig_3 = '0' THEN
                    for_num_1 <= '1';
                    EF <= E20;
                ELSIF done_sig_2 = '1' THEN
                    EF <= E21;
                ELSE
                    EF <= E14;
                END IF;

            WHEN E20 => --INICIAÇÃO DO SEGUNDO FOR DEC
                    EF <= E14;

            WHEN E21 => -- ULTIMA PARTE DA DEC
                    ready <= '1';
                    EF <= IDLE;
        END CASE;
    END PROCESS;

END ARCHITECTURE;


