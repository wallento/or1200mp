void buserr_except() {}
void dpf_except() {}
void ipf_except() {}
void align_except() {}
void illegal_except() {}
void hpint_except() {}
void dtlbmiss_except() {}
void itlbmiss_except() {}
void range_except() {}
void fpu_except() {}
void trap_except() {}
void res2_except() {}

//void timer_interrupt() {}
void sys_write() {}

typedef unsigned int uint32_t;

#define NOCBASE 0x10000000
#define NOCADDRESS(tile,address) NOCBASE | ( ( tile & 0xff ) << 20 ) | (address & 0x000fffff )
#define UARTTILE 11

#define NA_BASE 0x90000000
#define NA_TILEID 0x0

extern void uart_putc(char c);

inline uint32_t noc_get_tileid() {
	return *((uint32_t*) NA_BASE + NA_TILEID);
}

void noc_read(unsigned short tile, uint32_t addr, uint32_t *data) {
	*data = *( (uint32_t*) (NOCADDRESS(tile,addr)) );
}

void noc_write(unsigned short tile, uint32_t addr, uint32_t data) {
	*( (uint32_t*) (NOCADDRESS(tile,addr)) ) = data;
}

void noc_print(unsigned int slot, char* string ) {
	while (*string != 0) {
		noc_write(UARTTILE,slot * 8 + 4,*string);
		string++;
	}
	noc_write(UARTTILE,slot * 8,1);
}

char *msg = "Hello World from tile x!";

int main() {
	unsigned int tile = noc_get_tileid();
//	unsigned int *a = malloc(4);
//	noc_read(5,0x100,&a);
	msg[22] = (char) tile + 48;
	noc_print(tile,msg);
	return 0;
}
