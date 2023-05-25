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





END ARCHITECTURE;

