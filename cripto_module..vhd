--------------------------------------
-- Biblioteca
--------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

--------------------------------------
-- Entidade
--------------------------------------
ENTITY cripto_module IS
  PORT (
    start : IN STD_LOGIC; -- Entrada
    enc_dec : IN STD_LOGIC; -- Entrada
    reset : IN STD_LOGIC; -- Entrada
    clock : IN STD_LOGIC; -- Entrada
    data_i : IN STD_LOGIC(63 DOWNTO 0); -- Entrada
    key_i : IN STD_LOGIC(255 DOWNTO 0); -- Entrada
    
    busy : OUT STD_LOGIC; -- Saída
    ready : OUT STD_LOGIC; -- Saída
    data_o : OUT STD_LOGIC(63 DOWNTO 0) -- Saída
    
    );
    
END ENTITY;

--------------------------------------
-- Arquitetura
--------------------------------------

ARCHITECTURE cripto_module OF cripto_module IS
  
  TYPE STATE IS (IDLE, E2, E3, E4, E5); -- Etapas da máquina de estados   N SEI SE PRECISA DE RESET OU N AINDA
  SIGNAL EA : state; -- Estado atual
  SIGNAL EF : state; -- Estado futuro 
  SIGNAL busy_sig : STD_LOGIC := '0'; ---- 0 desocupado e 1 ocupado
  SIGNAL ready_sig : STD_LOGIC := '0'; ---- 0 não está pronto e 1 está pronto
  
  TYPE matriz IS ARRRAY( natural range <>, natural range <>) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL s_box : matriz ( 0 to 15, 7 downto 0);
  s_box <= (( 4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3),
           ( 14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9),
           ( 5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11),
           ( 7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3),
           ( 6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2),
           ( 4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14),
           ( 13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12),
           ( 1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12));   
   
  SIGNAL key : STD_LOGIC_VECTOR(255 DOWNTO 0):= x"DEADBEEF89ABCDEF01234567DEADBEEFDEADBEEF89ABCDEF01234567DEADBEEF";
  --- caso precise, e eu acho q vai já vou deixar aqui , n sei como faz pra atribiur a diferentes partes de um mesmo vetor diferentes valores.
  SIGNAL key : STD_LOGIC_VECTOR(7 DOWNTO 0);
         key[0] = 0xDEADBEEF;
         key[1] = 0x01234567;
         key[2] = 0x89ABCDEF;
         key[3] = 0xDEADBEEF;
         key[4] = 0xDEADBEEF;
         key[5] = 0x01234567;
         key[6] = 0x89ABCDEF;
         key[7] = 0xDEADBEEF;
 


  -- clock -------------------------------
  PROCESS (clock, reset)
    BEGIN
      IF(reset = '1') THEN
        ---- OQ TEM Q FAZER AQUI
      ELSIF rising_edge(clock) THEN
        -- OQ TEM QUE FAZER AQUI
      END IF;
 END PROCESS;

  --máquina de estados -------------------
 PROCESS (reset, clock)
    BEGIN
        IF reset = '1' THEN
            EA <= IDLE;
        ELSIF rising_edge(clock) THEN  
            EA <= EF;
        END IF;
 END PROCESS;
          
PROCESS(EA) -- aqui tem que colocar todos os sinais que a gente usar embaixo dps
    BEGIN
    CASE EA IS
        WHEN IDLE => --  
           ----------- o que acontece no idle -------------
           IF start = '1' THEN
             ---- SE TIVER QUE FAZER ALGUMA COISA MAIS VEM AQUI
              EF <= E2;
           END IF;
       
        WHEN E2 =>
           ---- O QUE FAZ NA ENTRAEDA DE DADOS --------------
             IF enc_dec = '0' THEN
             ---- SE TIVER QUE FAZER ALGUMA COISA MAIS VEM AQUI
                EF <= E3;
             ELSIF enc_dec = '1' THEN
             ---- SE TIVER QUE FAZER ALGUMA COISA MAIS VEM AQUI
                EF <= E4;
             END IF;
        
        WHEN E3 =>
            --------- O QUE FAZ  NA CRIPTOGRAFIA ---------

        WHEN E4 =>
           ----------  QUE  ACONTECE NA DECRIPTOGRAFIA C-------

        WHEN E5 =>
        ---------------  O QUE ACONTECE NA SAIDA DE DADOS ----------- 
            IF 
      
      END CASE;
END PROCESS;

END ARCHITECTURE;

