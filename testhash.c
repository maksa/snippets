#include <stdio.h>
#include <string.h>
#include <stdint.h>

uint32_t  hash(int8_t *command);

#define HASH_TABLE_LENGTH	13
const uint32_t  hashtable[HASH_TABLE_LENGTH] =
{
	0,				//0
	0,				//1
	4080429,		//2
	3914880981u,	//3
	1670,			//4
	121730,			//5
	4108351,		//6
	138097304,		//7
	110149,			//8
	3174374908u,	//9
	132593272,		//10
	2802956003u,	//11
	3638929			//12
};

int match_hash(uint32_t hash ) {
	for(int i = 0; i < sizeof(hashtable)/sizeof(int);++i) {
		if( hashtable[i] == hash ) return i;
	}
	return -1;
}

int main( int argc, char* argv[] ) {
    char buff[500];
    while( fgets(buff, 500, stdin)) {
		if( strlen(buff) > 0 ) {
			char* w = strtok(buff, "\n");
			uint32_t h = hash(buff);
			printf("%s\t%u\n", buff, hash(buff));
			int hash_index = match_hash(h);
			if( hash_index > 0 ) {
				printf("match found at %d for %s\n", hash_index, buff);
			}
		}
    }
}

uint32_t  hash(int8_t *command)
{
	uint32_t  hash = 0;
	uint8_t infinite_loop_breaker = 0;
	uint8_t c;
	while (c = *command++)
	{
		hash = (hash*33)^c;
		if (infinite_loop_breaker++ > 100) return 0;	//In case we get stuck
	}
	return hash;
}