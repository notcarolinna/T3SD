#include <stdio.h>
#include <stdint.h>

//-----------------------------------------------------------------------------
// GOST
//-----------------------------------------------------------------------------
void gost_round(uint32_t xi);
void gost_enc(uint32_t* block, uint32_t* key, uint32_t* encryptdBlock);
void gost_dec(uint32_t* encryptedBlock, uint32_t* key, uint32_t* decryptedBlock);
void gost(uint32_t* key, uint32_t* input, uint32_t *output, uint8_t* crypt_config);

//-----------------------------------------------------------------------------
// Main Function
//-----------------------------------------------------------------------------
int crypt_gost(void);
