#define ED "\x1b[2J"
#define EL "\x1b[2K"
#define CSI "\x1b["

typedef unsigned char  uchar;
typedef unsigned int   uint;
typedef unsigned long  ulong;
typedef unsigned short ushort;

typedef struct {
	ushort wx, wy;
} Window;

void  die(char* fmt, ...);
void* emalloc(ulong n);
void* erealloc(void* p, ulong n);
void  win_end();
void  win_init();
void  win_query(Window* w);
