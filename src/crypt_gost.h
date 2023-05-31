#include "crypt_gost.h"

//-----------------------------------------------------------------------------
// GOST
//-----------------------------------------------------------------------------
uint32_t CM1;
uint32_t CM2;
uint32_t N1;
uint32_t N2;
uint32_t R;

// S-box used by the Central Bank of Russian Federation
const uint8_t s_box[8][16] = {
                                    { 4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3 },
                                    { 14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9 },
                                    { 5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11 },
                                    { 7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3 },
                                    { 6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2 },
                                    { 4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14 },
                                    { 13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12 },
                                    { 1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12 }
};

void gost_round(uint32_t xi)
{
    CM1 = (N1 + xi) % 4294967296; // 2^32

    // read entire s-box column according to the CM1 bits
    uint32_t SN = 0;
    for (int j = 0; j <= 7; j++)
    {
        /*
        * 32 bits input is divided into 8 parts, each of 4 bits
        * to a correponding substitution point column point
        * in the s-box
        *
        * The line below generate a random column that will be
        * read from the s-box at each line and based on the
        * size of the total 16 columns of s-box (and thus % 16)
        */
        uint8_t Ni = (CM1 >> (4 * (7 - j))) % 16;  // extrai quatro bits consecutivos de CM1, começando pela posição mais significativa, 
	    //para determinar qual linha da coluna atual da caixa S deve ser acessada. O valor resultante é armazenado na variável Ni.
        Ni = s_box[j][Ni]; //realiza uma substituição usando a caixa S. Ela usa o valor Ni como um índice para acessar a tabela de substituição s_box e obter o valor correspondente. O resultado substitui o valor original de Ni.

        // place the read bits to correct position in the 32 bit output
        uint32_t mask = 0;
        mask = mask | Ni;
        mask = mask << (28 - (4 * j));
        SN = SN | mask;
    }

    R = SN;

    // cyclic 11 shift
    uint32_t mask = R << 11;
    R = (R >> 21) | mask;

    // modulo 2 addition
    CM2 = R ^ N2;
    N2 = N1;
    N1 = CM2;
}

void gost_enc(uint32_t* block, uint32_t* key, uint32_t* encryptdBlock)
{
    N1 = block[1];
    N2 = block[0];

    // first 24 rounds
    for (int k = 0; k < 3; k++)
    {
        for (int i = 0; i <= 7; i++)
        {
            gost_round(key[i]);
        }
    }

    // last 8 rounds
    for (int i = 7; i >= 0; i--)
    {
        gost_round(key[i]);
    }

    encryptdBlock[0] = N1;
    encryptdBlock[1] = N2;
}

void gost_dec(uint32_t* encryptedBlock, uint32_t* key, uint32_t* decryptedBlock)
{
    N1 = encryptedBlock[1];
    N2 = encryptedBlock[0];

    // last 8 rounds
    for (int i = 0; i <= 7; i++)
    {
        gost_round(key[i]);
    }

    // first 24 rounds
    for (int k = 0; k < 3; k++)
    {
        for (int i = 7; i >= 0; i--)
        {
            gost_round(key[i]);
        }
    }

    decryptedBlock[0] = N1;
    decryptedBlock[1] = N2;
}

void
gost(uint32_t* key, uint32_t* input, uint32_t *output, uint8_t* crypt_config) {
    if (crypt_config[0])
        gost_enc(input, key, output);
    else
        gost_dec(input, key, output);
}

//-----------------------------------------------------------------------------
// Main Function
//-----------------------------------------------------------------------------
int
crypt_gost(void) {
    static const char _start[] = "Start crypt-gost\n";
    static const char _end[] = "End crypt-gost\n";
    int i, error;
    uint32_t key[8], plan[2], cipher[2];
    uint8_t crypt_config[5]; //0: enc_dec, 1: plan_size, 2: key_size, 3: msg_size(numWords), 4: algorithm

    printf((void *)_start);

    for (i = 0; i < 2; i++){
        error = 0;

        // Testcase name
        switch (i) {
            case 0 : printf("-- GOST-256 (ENC) --\n"); break; //GOST-256 - ENC
            case 1 : printf("-- GOST-256 (DEC) --\n"); break; //GOST-256 - DEC
        }

        // Write CRYPT_KEY
        key[0] = 0xDEADBEEF;
        key[1] = 0x01234567;
        key[2] = 0x89ABCDEF;
        key[3] = 0xDEADBEEF;
        key[4] = 0xDEADBEEF;
        key[5] = 0x01234567;
        key[6] = 0x89ABCDEF;
        key[7] = 0xDEADBEEF;

        // Write CRYPT_PLAN
        switch (i) {
            case 0 : plan[0] = 0xA5A5A5A5; break; //GOST-256 - ENC
            case 1 : plan[0] = 0x272612A5; break; //GOST-256 - DEC
        }
        switch (i) {
            case 0 : plan[1] = 0x01234567; break; //GOST-256 - ENC
            case 1 : plan[1] = 0xEE5D03AD; break; //GOST-256 - DEC
        }

        // Write CRYPT_CONFIG
        crypt_config[0] = (i+1) % 2; //0: dec, 1: enc (Enc_Dec)
        crypt_config[1] = 0; //0: 64 bits (Plan Size)
        crypt_config[2] = 2; //2: 256 bits (Key Size)
		crypt_config[3] = 2; //2: Number of words in the message
        crypt_config[4] = 4; //4: GOST (algorithm)

        // Call MappCryptography
        gost(key, plan, cipher, crypt_config); // C Application

        // Read CRYPT_CIPHER
        printf("%08X\n", cipher[0]);
        switch (i) {
            case 0 : if (cipher[0] != 0x272612A5) error = 1; break; //GOST-256 - ENC
            case 1 : if (cipher[0] != 0xA5A5A5A5) error = 1; break; //GOST-256 - DEC
        }
        printf("%08X\n", cipher[1]);
        switch (i) {
            case 0 : if (cipher[1] != 0xEE5D03AD) error = 1; break; //GOST-256 - ENC
            case 1 : if (cipher[1] != 0x01234567) error = 1; break; //GOST-256 - DEC
        }

        if (error == 1) {
            printf("CRYPT: ERROR!!!\n"); 
        }
        else {
            switch (i) {
                case 0 : printf("GOST-256 (ENC): OK\n"); break; //GOST-256 - ENC
                case 1 : printf("GOST-256 (DEC): OK\n"); break; //GOST-256 - DEC
            }
        }
    }

    printf((void *)_end);
	return 0;
}
