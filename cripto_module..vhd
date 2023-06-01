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
  
  TYPE STATE IS (IDLE, E2, E3, E4, E5, E6. E7, E8, E9, E10, E11, E12, E13, E14, E15, E16, E17, E18, E19, E20, E21); -- Etapas da máquina de estados   N SEI SE PRECISA DE RESET OU N AINDA
  SIGNAL EA : state; -- Estado atual
  SIGNAL EF : state; -- Estado futuro 
  SIGNAL busy_sig : STD_LOGIC := '0'; ---- 0 desocupado e 1 ocupado   -------------- DA PROBLEMA TER 0 AQUI, ACHO Q SÓ PRECISARIA NO RESET NÃO?
  SIGNAL ready_sig : STD_LOGIC := '0'; ---- 0 não está pronto e 1 está pronto
  SIGNAL for_num : STD_LOGIC := '0'; --- quando for 0 é o primeiro e qnd for ''1' é o segundo o acabou
  SIGNAL done_sig : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_2 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_3 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_4 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_5 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_6 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_7 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_8 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_9 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL done_sig_10 : STD_LOGIC := '0'; --- quando for 1 o acabou
  SIGNAL K : INTEGER RANGE 0 TO 2; -- VAI DE 0 A 2
  SIGNAL I : INTEGER RANGE 0 TO 7; -- VAI DE 0 A 7
  SIGNAL J : INTEGER RANGE 0 TO 7; -- VAI DE 0 A 7
  SIGNAL CM1 : STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL CM2 : STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL N1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL N2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL R : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SN : STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL NI : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL mask : STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL mask_f : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
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

  
  TYPE VETOR IS ARRRAY( natural range <> ) OF STD_LOGIC_VECTOR(32 DOWNTO 0);			
  SIGNAL KEY : VETOR ( 0 to 7); -- TEM QUE SEPARAR PELOS BITS MAIS SIGNIFICATIVOS  ATÉ OS MENOS DE 32 EM 32  BITS, NO CASO A ENTRADA DE 256
  

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
 PROCESS (reset, clock) ---- tem que zerar todas as variáveis depois
    BEGIN
        IF reset = '1' THEN
            EA <= IDLE;
	    N1 <= (OTHERS=>'0'); -- ZEREI O VETOR TODO DO N1
	    N2 <= (OTHERS=>'0');
	    NI <= (OTHERS=>'0');
	    key <= (OTHERS=>'0');
	    CM1 <= (OTHERS=>'0');
	    CM2 <= (OTHERS=>'0');
	    mask_f <= (OTHERS=>'0');
	    R <= (OTHERS=>'0');
	    done_sig <= '0';
	    done_sig_2 <= '0';
	    done_sig_3 <= '0';
	    done_sig_4 <= '0';
	    done_sig_5 <= '0';
	    done_sig_6 <= '0';
	    done_sig_7 <= '0';	
	    done_sig_8 <= '0';
	    done_sig_9 <= '0';
	    done_sig_10 <= '0';
        ELSIF rising_edge(clock) THEN  
            EA <= EF;
	    IF EA = E2 THEN
		busy_sig = '1';
		N2 <= data_i(31 DOWNTO 0);
	        N1 <= data_i(63 DOWNTO 32);
		key[0] <= key_i(255 DOWNTO 224);
		key[1] <= key_i(223 DOWNTO 192);
		key[2] <= key_i(191 DOWNTO 160);
		key[3] <= key_i(159 DOWNTO 128);
		key[4] <= key_i(127 DOWNTO 96);
		key[5] <= key_i(95 DOWNTO 64);
		key[6] <= key_i(63 DOWNTO 32);
		key[7] <= key_i(31 DOWNTO 0);
		done_sig <= '1'; -- para saber que tem que passar pro estado 3
	     ELSIF EA = E3 THEN
		busy <= busy_sig;
		k <= 0; -- inicializer o cont em 0
		i <= 0; -- inicializei em 0
		done_sig_2 <= '1';
	     ELSIF EA = E4 THEN
		CM1 <= N1 + key[i];
		SN <= (OTHERS=>'0'); -- INICIALIZAR EM 0
		done_sig_3 <= '1';
	     ELSIF EA = E5 THEN
		J <= 0;
		done_sig_4 <= '1';
	     ELSIF EA = E6 THEN
		done_sig <= '0'; -- para poder passar o sinal certo no e7
		Ni <= (CM1 srl (4 * (7 - j))) mod 16; -- confirmar se srl desloca para a direita mesmo em vhdl
		Ni <= s_box[j][Ni]; -- será q o ni em dois lufgares da ruim?
		mask <= (OTHERS=>'0');
		mask <= mask or Ni;  -- isso vai dar ruim pq é paralelo?
		mask <= mask sll (28 - (4 * j));  -- sll =  shift left logic
		SN <= SN or mask;
	     ELSIF EA = E7 THEN
		J <= J + 1;
		done_sig_5 <= '1'; 
	     ELSIF EA = E8 THEN ------------------------------ CONFERIR a sintaxe  DESSE -----------------------------
		mask_f <= R sll 11;
		R <= (R srl 21) or mask_f;
		CM2 <= R XOR N2;
    		N2 <= N1;
    		N1 <= CM2;
		done_sig_6 <= '1';
	     ELSIF EA = E9 THEN
		IF for_num = '0' THEN
			IF I < 7 THEN
				I <= I + 1;
			ELSIF I = 7 AND K < 3 THEN
		 		K <= K + 1;
			END IF
		ELSIF for_num = '1' THEN
			IF I < 0 THEN
			 I <= I - 1 ;
			ELSE THEN
			done_sig_8 = '1';
			END IF
		END IF
	     ELSIF EA = E10 THEN
		j < = 0;
		done_sig_7 <= '1';
	     ELSIF EA = E11 THEN
		------ AQUELA PARTE DO ENCRIPTOBLOCK????????
		done_sig_9 <= '1';
			
        END IF;
 END PROCESS;
      		
PROCESS(EA)
    BEGIN
    CASE EA IS
       WHEN IDLE =>
		IF start = '1' AND enc_dec = '1' THEN
			EF <= E2;
		ELSIF start = '1' AND enc_dec = '0' THEN
			EF <= E12;
		END IF
	WHEN E2 => -- ARMAZENAMENTO ENC
		IF done_sig = '1' THEN
			EF <= E3;
		END IF
	WHEN E3 => -- INICIAÇÃO DO PRIMEIRO FOR ENC
		IF done_sig_2 = '1' THEN
			EF <= E4;
		END IF
	WHEN E4 => --SOMA DA CHAVE ENC
		IF done_sig_3 = '1' THEN
			EF <= E5;
		END IF  
	WHEN E5 => --INICIAÇAO DO FOR DO GOST ROUND ENC
		IF done_sig_4 = '1' THEN
			EF <= E6;
		END IF  
	WHEN E6 => -- OPERAÇÕES DENTRO DO FOR DO GOST ROUND ENC
		IF j < 7 THEN  -- É SÓ MENOR PQ COM A SOMA DE UM FICA TUDO BEM ACHO CONFIRMAR ISSO AQUI
			EF <= E7;
		ELSE THEN
			EF <= E8;
		END IF
	WHEN E7 => --ICNCREMETENTA CONT DO FOR DO GOST ROUND ENC
		IF done_sig_5 = '1' THEN
			EF <= E6;
		END IF
	WHEN E8 => --OPERAÇÃO FINAL DA FUNÇÃO GOST ROUND ENC
		IF done_sig_6 = '1' THEN
			EF <= E9;
		END IF
	WHEN E9 => -- INCREMENTA/DECREMETNA CONTADORES DOS FORS DO ENC
		IF I = 7 AND K = 2 THEN
			for_num = '1';
			EF <= E10;
		ELSIF done_sig_8 = '1' THEN
			EF <= E11;
		ELSE THEN
			EF <= E4;
		END IF
	WHEN E10 => --INICIAÇÃO DO SEGUNDO FOR ENC
		IF done_sig_7 = '1' THEN   ----  POSSO USAR O MESMO I NEH, NÃO DA PROBLEMA?
			EF <= E4; 
		END IF
	WHEN E11 => -- ULTIMA PARTE DA ENC
		IF done_sig_9 = '1' THEN   ----  POSSO USAR O MESMO I NEH, NÃO DA PROBLEMA?
			ready <= '1';
			busy <= '0';
		END IF
	WHEN E12 => -- ARMAZENAMENTO DEC
		
	WHEN E13 => -- INICIAÇÃO DO PRIMEIRO FOR DEC
		
	WHEN E14 => --SOMA DA CHAVE DEC
		
	WHEN E15 => --INICIAÇAO DO FOR DO GOST ROUND DEC
		
	WHEN E16 => -- OPERAÇÕES DENTRO DO FOR DO GOST ROUND DEC
	
	WHEN E17 => --ICNCREMETENTA CONT DO FOR DO GOST ROUND DEC
	
	WHEN E18 => --OPERAÇÃO FINAL DA FUNÇÃO GOST ROUND DEC
			
	WHEN E19 => -- INCREMENTA/DECREMETNA CONTADORES DOS FORS DO DEC
			
	WHEN E20 => --INICIAÇÃO DO SEGUNDO FOR DEC
		
	WHEN E21 => -- ULTIMA PARTE DA DEC
		IF done_sig_10 = '1' THEN   ----  POSSO USAR O MESMO I NEH, NÃO DA PROBLEMA?
			ready <= '1';
			busy <= '0';
		END IF
			
      END CASE;
END PROCESS;

END ARCHITECTURE;