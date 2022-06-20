#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include "sim.h"

#define MINSIZE 16
#define MAXEMPTY 256
#define FILECOUNT 8
#define LENGTH(a) (sizeof(a)/sizeof(a[0]))

typedef long Posn;

enum {
	Up = 1,
	Down,
	Left,
	Right,
	HalfUp,
	HalfDown,
	Top,
	Bottom,
	Letter,
	Word,
	EndWord,
	PrevWord,
	Till,
	Line,
	StartLine,
	EndLine,
	Insert,
	Delete,
	Change,
	Ctrl = -0x60,
	Esc = 0x1b,
	Del = 0x7f
};

typedef struct {
	Posn p0, p1;
} Address;

typedef struct {
	char* s;
	ulong n; /*number of filled characters*/
	ulong size;
} String;

typedef struct {
	String is[2048];
	String ds[2048];
	uint   c[2048];
	uint   arg[2048];
	uint   count[2048];
	Posn   p0[2048];
	short  n;
} Buffer;

typedef struct {
	String* s;
	String* name;
	Address dot;
	short   i;   /*buffer index*/
	uchar   dirty;
} File;

typedef struct {
	uchar key;
	void (*func)(int);
	int value;
} Key;

typedef struct {
	Address* a;
	ushort dot;
	ushort n;
	ushort size;
} Frame;

void        die(char*, ...);
void*       emalloc(ulong);
void*       erealloc(void*, ulong);
static void blind_reader(Frame* fr, String* s, Posn p0);
static void blind_writer(String* s, Frame* fr, ushort line, ushort offset, ushort top, ushort bot);
static void buf_add(Buffer* b, String* is, String* ds, uint c, uint arg, uint count, Posn p0);
static void change(int arg);
static void count(int arg);
static void delete(int arg);
static void dot(int arg);
static void redo(int arg);
static void escape(int c);
static void init();
static void input(String* s, ushort line, char* msg);
static void insert(int arg);
static int  isword(uchar c);
static void file_close(int arg);
static void file_init(File* f);
static void file_load(File* f);
static void file_open(int c);
static void file_save(int arg);
static void fr_add(Frame* fr, Posn p0, Posn p1);
static void fr_close(Frame* fr);
static void fr_init(Frame* fr);
static void fr_insert(Frame* p, Frame* q, ushort n);
static void fr_insure(Frame* fr, ushort n);
static void fr_update();
static void fr_zero(Frame*);
static void gmove(int arg);
static void paste(int arg);
static void pline();
static void search(int arg);
static int  selection(int arg);
static void str_init(String* p);
static void str_close(String* p);
static void str_zero(String* p);
static void str_insure(String* p, ulong n);
static void str_addc(String* p, int c);
static void str_adds(String* p, char* s, ulong n);
static void str_delc(String* p);
static void str_insert(String* p, String* q, Posn p0);
static void str_delete(String* p, Posn p0, Posn p1);
static void undo(int arg);
static void move(int);
static void quit(int);
static void yank(int arg);

static Frame*  fr, frame[FILECOUNT];
static File*   f, file[FILECOUNT];
static Buffer* buf, buffer[FILECOUNT];
static String  istr, srch;
static Window  w;
static uint    counter;

#include "config.h"

void
die(char* fmt, ...)
{
	uint i;
	va_list ap;

	win_end();
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
	if (fmt[0] && fmt[strlen(fmt) - 1] == ':')
		perror(NULL);
	else
		fputc('\n', stderr);
	for (i = 0; i < FILECOUNT; ++i) {
		if (!file[i].s->n)
			continue;
		str_adds(file[i].name, ".swap", 5);
		file_save(i);
		fprintf(stderr, "file saved to %s\n", file[i].name->s);
	}
	*fmt = *(char*)NULL;
}

void*
emalloc(ulong n)
{
	void* p;

	p = malloc(n);
	if (!p)
		die("malloc:");
	memset(p, 0, n);
	return p;
}

void*
erealloc(void* p, ulong n)
{
	p = realloc(p, n);
	if (!p)
		die("realloc:");
	return p;
}

static void
blind_reader(Frame* fr, String* s, Posn p0)
{
	Posn p1;
	uint wx;

	p1 = p0;
	do {
		for (wx = 0; wx < w.wx && p1 < s->n;) {
			switch (s->s[p1]) {
				case '\t':
					wx += 4 - (wx % 4);
					break;
				case '\n':
					goto endloop;
				default:
					++wx;
			}
			if (wx < w.wx)
				++p1;
			if (wx >= w.wx) {
				if (s->s[p1] == '\t')
					++p1;
				if (s->s[p1 + 1] == '\n')
					++p1;
			}
		}
		endloop:
		fr_add(fr, p0, p1);
		p0 = ++p1;
	} while (p1 <= s->n && s->s[p1 - 1] != '\n');
}

static void
blind_writer(String* s, Frame* fr, ushort line, ushort offset, ushort top, ushort bot)
{
	ushort i, o;

	i = o = 0;
	if (offset >= top)
		i = offset - top + 1;
	if (fr->n - offset > bot)
		o = offset + bot - 1;
	else if (fr->n)
		o = fr->n - 1;
	printf(CSI "%uH", line - offset);
	fwrite(&s->s[fr->a[i].p0], fr->a[o].p1 - fr->a[i].p0, 1, stdout);
}

static void
buf_add(Buffer* b, String* is, String* ds, uint c, uint arg, uint count, Posn p0)
{
	b->n = ++f->i + 1;
	str_zero(&b->is[f->i]);
	str_zero(&b->ds[f->i]);
	if (is != NULL)
		str_insert(&b->is[f->i], is, 0);
	if (ds != NULL)
		str_insert(&b->ds[f->i], ds, 0);
	b->c[f->i] = c;
	b->arg[f->i] = arg;
	b->count[f->i] = count;
	b->p0[f->i] = p0;
	f->dirty = '*';
	fr_zero(fr);
}

static void
change(int arg)
{
	String s;
	uint   count;

	if (!arg)
		arg = fgetc(stdin);
	switch (arg) {
		case 'x': arg = Letter; break;
		case 'c': arg = Line; break;
		case 'G': arg = Bottom; break;
		case 'g': arg = Top; break;
		case 'w': arg = Word; break;
		case 't': arg = Till; break;
	}
	count = counter;
	arg = selection(arg);
	if (arg == Word || arg == Letter || arg > 0x7f)
		++f->dot.p1;
	str_init(&s);
	if (f->dot.p0 != f->dot.p1) {
		str_adds(&s, f->s->s + f->dot.p0, f->dot.p1 - f->dot.p0);
		str_delete(f->s, f->dot.p0, f->dot.p1);
	}
	f->dot.p0 = f->dot.p1 = f->dot.p0;
	fr_zero(fr);
	insert(0);
	if (s.n)
		str_insert(&buf->ds[f->i], &s, 0);
	str_close(&s);
	buf->c[f->i] = Change;
	buf->arg[f->i] = arg;
	buf->count[f->i] = count;
	fr_update();
}

static void
count(int arg)
{
	if (!counter && !arg) {
		move(StartLine);
		return;
	}
	counter *= 10;
	counter += arg;
}

static void
delete(int arg)
{
	String s;
	uint   count;

	if (!f->s->n)
		return;
	if (!arg) {
		switch (arg = fgetc(stdin)) {
			case 'x': arg = Letter; break;
			case 'd': arg = Line; break;
			case 'G': arg = Bottom; break;
			case 'g': arg = Top; break;
			case 'w': arg = Word; break;
			case 't': arg = Till; break;
			default:
				return;
		}
	}
	count = counter;
	if ((arg = selection(arg)) < 0)
		return;
	str_init(&s);
	str_zero(&istr);
	str_adds(&s, f->s->s + f->dot.p0, f->dot.p1 + 1 - f->dot.p0);
	str_adds(&istr, f->s->s + f->dot.p0, f->dot.p1 + 1 - f->dot.p0);
	buf_add(buf, NULL, &s, Delete, arg, count, f->dot.p0);
	str_delete(f->s, f->dot.p0, f->dot.p1 + 1);
	str_close(&s);
	if (f->dot.p0 == f->s->n && f->dot.p0)
		--f->dot.p0;
	f->dot.p1 = f->dot.p0;
	fr_update();
}

static void
dot(int arg)
{
	String ds;

	if (f->i < 0)
		f->i = 0;
	arg = buf->arg[f->i];
	counter = buf->count[f->i];
	switch (buf->c[f->i]) {
		case Insert:
			if (arg == Down)
				move(EndLine);
			else
				move(arg);
			str_insert(f->s, &istr, f->dot.p0);
			buf_add(buf, &istr, NULL, Insert, arg, counter, f->dot.p0);
			break;
		case Delete:
			delete(arg);
			break;
		case Change:
			str_init(&ds);
			if (buf->ds[f->i].n) {
				selection(arg);
				if (arg == Word || arg == Letter || arg > 0x7f)
					++f->dot.p1;
				str_adds(&ds, f->s->s + f->dot.p0, f->dot.p1 - f->dot.p0);
				str_delete(f->s, f->dot.p0, f->dot.p1);
			}
			if (buf->is[f->i].n)
				str_insert(f->s, &buf->is[f->i], f->dot.p0);
			buf_add(buf, &buf->is[f->i], &ds, Change, arg, buf->count[f->i], f->dot.p0);
			str_close(&ds);
			f->dot.p1 = f->dot.p0;
			break;
	}
	fr_update();
}

static void
redo(int arg)
{
	if (f->i == buf->n - 1)
		return;
	if (buf->ds[++f->i].n)
		str_delete(f->s, buf->p0[f->i], buf->p0[f->i] + buf->ds[f->i].n);
	if (buf->is[f->i].n)
		str_insert(f->s, &buf->is[f->i], buf->p0[f->i]);
	f->dot.p0 = f->dot.p1 = buf->p0[f->i];
	f->dirty = '*';
	fr_zero(fr);
	fr_update();
}

static void
escape(int c)
{
	counter = 0;
	c = fgetc(stdin) - 0x30;
	if (c > 0 && c <= 8) {
		--c;
		f = &file[c];
		fr = &frame[c];
		buf = &buffer[c];
		return;
	}
	ungetc(c + 0x30, stdin);
}

static void
input(String* s, ushort line, char* msg)
{
	uchar c;

	for (;;) {
		printf(CSI "%uH" EL "%s%s", line, msg, s->s);
		switch (c = fgetc(stdin)) {
			case Esc:
				str_zero(s);
			case '\n':
				return;
			case Del:
				str_delc(s);
				break;
			default:
				str_addc(s, c);
		}
	}
}

static int
isword(uchar c)
{
	switch (c) {
		case ' ': case '\t': case '\n': case '.':
		case '(': case ')':  case '{':  case '}':
		case '[': case ']':  case ':':  case ';':
		case ',': case '<':  case '>':  case '#':
		case '*': case '+':  case '-':  case '!':
		case '%': case '\\': case '/':  case '"':
		case '=':
		return 0;
	}
	return 1;
}

static void
insert(int arg)
{
	String s, c;

	if (f->s->s[f->s->n - 1] != '\n') {
		str_addc(f->s, '\n');
		move(Right);
	}
	str_init(&s), str_init(&c);
	str_addc(&c, '\0');
	switch (arg) {
		case StartLine:
		case EndLine:
		case Right:
			move(arg);
			break;
		case Down:
			move(EndLine);
			str_addc(&s, '\n');
			str_insert(f->s, &s, f->dot.p0);
			++f->dot.p1;
			break;
	}
	for (;;) {
		win_query(&w);
		fr_update();
		switch (c.s[0] = fgetc(stdin)) {
			case Esc:
				goto endmode;
			case Del:
				if (f->dot.p1 != f->dot.p0) {
					str_delc(&s);
					str_delete(f->s, f->dot.p1 - 1, f->dot.p1);
					--f->dot.p1;
				}
				break;
			default:
				str_addc(&s, c.s[0]);
				str_insert(f->s, &c, f->dot.p1);
		}
		f->dot.p1 = f->dot.p0 + s.n;
	}
	endmode:
	str_zero(&istr);
	str_insert(&istr, &s, 0);
	for (counter ? --counter : 0; counter; --counter) {
		str_insert(&istr, &s, istr.n);
		str_insert(f->s, &s, f->dot.p0);
	}
	buf_add(buf, &istr, NULL, Insert, arg, counter, f->dot.p0);
	str_close(&s), str_close(&c);
	f->dot.p0 = f->dot.p1;
	if (f->dot.p1 >= f->s->n)
		move(Left);
}

static void
init()
{
	uint i;

	win_init();
	for (i = 0; i < FILECOUNT; ++i) {
		file_init(&file[i]);
		fr_init(&frame[i]);
	}
	f = &file[0];
	fr = &frame[0];
	buf = &buffer[0];
	str_init(&srch);
	str_init(&istr);
}

static void
file_close(int arg)
{
	if (arg == -1)
		arg = f - file;
	if (file[arg].dirty) {
		printf(CSI "%uH" EL CSI "31mSave %s?" CSI "0m [y/n]", w.wy/2, file[arg].name->n ? file[arg].name->s : "-unnamed-");
		if (fgetc(stdin) == 'y')
			file_save(arg);
	}
	str_zero(f->s);
	str_zero(f->name);
	f->dot.p0 = f->dot.p1 = 0;
}

static void
file_init(File* f)
{
	f->s = emalloc(sizeof(String));
	f->name = emalloc(sizeof(String));
	str_init(f->s);
	str_init(f->name);
	f->dirty = f->dot.p0 = f->dot.p1 = 0;
	f->i = -1;
}

static void
file_load(File* f)
{
	FILE* disk;

	if (!(disk = fopen(f->name->s, "r")))
		return;
	fseek(disk, 0, SEEK_END);
	if ((f->s->n = ftell(disk))) {
		str_insure(f->s, f->s->n);
		rewind(disk);
		fread(f->s->s, f->s->n, 1, disk);
	}
	fclose(disk);
	f->dot.p0 = f->dot.p1 = 0;
	f->i = -1;
}

static void
file_open(int c)
{
	if (f->dirty) {
		printf(CSI "%uH" EL CSI "31mSave %s?" CSI "0m [y/n]", w.wy/2, f->name->s);
		if (fgetc(stdin) == 'y')
			file_save(f - file);
	}
	input(f->name, w.wy/2, CSI "32m$ " CSI "m");
	file_load(f);
}

static void
file_save(int arg)
{
	FILE* disk;

	if (arg == -1)
		arg = f - file;
	if (!file[arg].name->n) {
		input(file[arg].name, w.wy/2, "File name: ");
		if (!file[arg].name->n)
			return;
	}
	disk = fopen(file[arg].name->s, "w");
	fwrite(file[arg].s->s, file[arg].s->n, 1, disk);
	fclose(disk);
	file[arg].dirty = 0;
}

static void
fr_add(Frame* fr, Posn p0, Posn p1)
{
	fr_insure(fr, fr->n + 1);
	fr->a[fr->n].p0 = p0;
	fr->a[fr->n].p1 = p1;
	++fr->n;
}

static void
fr_calc(Frame* fr)
{
	Frame fr0;
	Posn  p0, p1;
	ushort half;

	half = w.wy >> 1;
	if (!fr->n
		|| f->dot.p1 != f->dot.p0
		|| f->dot.p1 < fr->a[0].p0
		|| f->dot.p1 > fr->a[fr->n ? fr->n - 1 : 0].p1
		|| (fr->dot < half && fr->a[0].p0)
		|| (fr->dot + half + 1 > fr->n && fr->a[fr->n ? fr->n - 1 : 0].p1 + 1 < f->s->n)
	) {
		fr_zero(fr);
		for (p0 = f->dot.p1; p0; --p0)
			if (f->s->s[p0 - 1] == '\n')
				break;
		p1 = p0;
		if (p1) {
			fr_init(&fr0);
			for (--p1; p1 && fr->n < w.wy;) {
				for (;p1 && f->s->s[p1 - 1] != '\n'; --p1);
				blind_reader(&fr0, f->s, p1);
				p1 = fr0.a[0].p0;
				if (p1)
					--p1;
				fr_insert(fr, &fr0, 0);
				fr_zero(&fr0);
			}
			fr_close(&fr0);
		}
		for (p1 = p0; p1 < f->s->n && fr->n < w.wy * 3;) {
			blind_reader(fr, f->s, p1);
			p1 = fr->a[fr->n - 1].p1 + 1;
		}
	}
	for (;f->dot.p1 < fr->a[fr->dot].p0 && fr->dot; --fr->dot);
	for (;f->dot.p1 > fr->a[fr->dot].p1; ++fr->dot);
}

static void
fr_close(Frame* fr)
{
	free(fr->a);
}

static void
fr_init(Frame* fr)
{
	fr->a = emalloc(32 * sizeof(*fr->a));
	fr->dot = 0;
	fr->n = 0;
	fr->size = 32;
}

static void
fr_insert(Frame* p, Frame* q, ushort n)
{
	fr_insure(p, p->n + q->n);
	memmove(p->a + n + q->n, p->a + n, (p->n - n) * sizeof(*p->a));
	memmove(p->a + n, q->a, q->n * sizeof(*p->a));
	p->n += q->n;
}

static void
fr_insure(Frame* fr, ushort n)
{
	if (n > fr->size) {
		fr->size += n + 32;
		fr->a = erealloc(fr->a, fr->size * sizeof(*fr->a));
	}
}

static void
fr_update()
{
	Posn p0, p1;
	uint half;

	half = w.wy >> 1;
	if (!f->s->n) {
		fr->a[0].p0 = fr->a[0].p1 = 0;
		printf(ED);
		goto status;
	}
	fr_calc(fr);
	fwrite(ED, sizeof(ED), 1, stdout);
	blind_writer(f->s, fr, half, fr->dot, half, half + (w.wy % 2));
	status:
	printf(CSI "%uH", w.wy);
	printf(STATUS);
	for (p0 = fr->a[fr->dot].p0, p1 = 1; p0 < f->dot.p1; ++p0) {
		if (f->s->s[p0] == '\t' && p1 % 4)
			p1 += 5 - (p1 % 4);
		else
			++p1;
	}
	printf(CSI "%u;%luH", half, p1);
	return;
}

static void
fr_zero(Frame* fr)
{
	fr->n = 0;
	fr->dot = 0;
}

static void
move(int arg)
{
	switch (arg) {
		case Left:
			if (f->dot.p1)
				--f->dot.p1;
			break;
		case Right:
			if (f->dot.p1 + 1 < f->s->n)
				++f->dot.p1;
			break;
		case Up:
			if (fr->dot)
				f->dot.p1 = fr->a[fr->dot - 1].p0;
			else
				f->dot.p1 = 0;
			break;
		case Down:
			if (!f->s->n)
				return;
			if (fr->dot < fr->n - 1)
				f->dot.p1 = fr->a[fr->dot + 1].p0;
			else
				f->dot.p1 = fr->a[fr->dot].p1 - 1;
			break;
		case HalfUp:
			if (fr->dot < w.wy/2)
				f->dot.p1 = 0;
			else
				f->dot.p1 = fr->a[fr->dot - w.wy/2].p0;
			break;
		case HalfDown:
			if (!f->s->n)
				break;
			if (fr->n - fr->dot <= w.wy/2) {
				if (fr->a[fr->n - 1].p1 <= f->s->n)
					f->dot.p1 = fr->a[fr->n - 1].p0;
				else
					f->dot.p1 = f->s->n;
			} else
				f->dot.p1 = fr->a[fr->dot + w.wy/2].p0;
			break;
		case Top:
			f->dot.p1 = 0;
			break;
		case Bottom:
			if (f->s->n)
				f->dot.p1 = f->s->n - 1;
			break;
		case StartLine:
			if (fr->dot)
				for (;fr->dot > 1 && f->s->s[fr->a[fr->dot].p0 - 1] != '\n'; --fr->dot);
			f->dot.p1 = fr->a[fr->dot].p0;
			break;
		case EndLine:
			for (;f->dot.p1 + 1 < f->s->n && f->s->s[f->dot.p1] != '\n'; ++f->dot.p1);
			break;
		case Word:
			for (;f->dot.p1 + 1 < f->s->n && isword(f->s->s[f->dot.p1]); ++f->dot.p1);
			for (;f->dot.p1 + 1 < f->s->n && !isword(f->s->s[f->dot.p1]); ++f->dot.p1);
			break;
		case EndWord:
			move(Right);
			for (;f->dot.p1 < f->s->n && !isword(f->s->s[f->dot.p1]); ++f->dot.p1);
			for (;f->dot.p1 < f->s->n && isword(f->s->s[f->dot.p1]); ++f->dot.p1);
			move(Left);
			break;
		case PrevWord:
			move(Left);
			for (;f->dot.p1 > 0 && !isword(f->s->s[f->dot.p1]); --f->dot.p1);
			for (;f->dot.p1 > 0 && isword(f->s->s[f->dot.p1]); --f->dot.p1);
			if (f->dot.p1)
				move(Right);
			break;
	};
	f->dot.p0 = f->dot.p1;
	fr_calc(fr);
}

static void
quit(int arg)
{
	uint i;

	for (i = 0; i < FILECOUNT; ++i)
		file_close(i);
	win_end();
	exit(arg);
}

static void
gmove(int arg)
{
	if (arg == Top) {
		move(Top);
		for (counter ? --counter : 0; counter; --counter) {
			move(EndLine);
			move(Right);
		}
		return;
	}
	for (!counter ? ++counter : 0; counter; --counter)
		move(arg);
}

static void
paste(int arg)
{
	str_insert(f->s, &istr, f->dot.p0);
	buf_add(buf, &istr, NULL, Insert, 0, 1, f->dot.p0);
}

static void
pline()
{
	ulong i, j, c, l;

	for (l = f->dot.p1 = 0; f->dot.p1 < f->dot.p0; ++l) {
		for (;f->dot.p1 + 1 < f->s->n && f->s->s[f->dot.p1] != '\n'; ++f->dot.p1);
		if (f->dot.p1 + 1 < f->s->n)
			++f->dot.p1;
	}
	++l;
	j = 1;
	if (!counter)
		counter = 1;
	for (;;) {
		for (i = 0; i < j * counter && i < w.wy/2 ; ++i)
			printf(CSI "%luH" EL "%lu", w.wy/2 + i, i ? i : l);
		switch (c = fgetc(stdin)) {
			case '!':
				++j;
				break;
			case '+':
				++counter;
				break;
			case '-':
				if (counter > 1)
					--counter;
			default:
				counter = 0;
				return;
		}
	}
}

static void
search(int arg)
{
	Posn pos;
	char* p;

	f->s->s[f->s->n] = 0;
	if (arg == '/' || arg == '?') {
		str_zero(&srch);
		input(&srch, w.wy, "/");
		for (pos = 0; pos < srch.n; ++pos)
			if (srch.s[pos] == '^')
				srch.s[pos] = '\n';
	}
	if (arg == '/' || arg == 'n') {
		move(Right);
		p = strstr(f->s->s + f->dot.p0, srch.s);
		if (p == NULL) {
			move(Left);
			return;
		}
	} else {
		pos = f->dot.p1;
		if (srch.s[0] == '\n' && srch.s[1] != '\n')
			move(Left);
		for (;;) {
			for (;move(Left), f->dot.p1 && f->s->s[f->dot.p1] != srch.s[0];);
			if (!strncmp(f->s->s + f->dot.p1, srch.s, srch.n))
				break;
			if (!f->dot.p1) {
				f->dot.p0 = f->dot.p1 = pos;
				return;
			}
		}
		p = f->s->s + f->dot.p1;
	}
	f->dot.p0 = f->dot.p1 = p - f->s->s;
	if (srch.s[0] == '\n' && srch.s[1] != '\n')
		move(Right);
	fr_update();
}

static int
selection(int arg)
{
	Posn p0;

	if (!counter)
		++counter;
	if (arg > 0x7f) {
		arg -= 0x7f;
		goto till;
	}
	p0 = f->dot.p1 = f->dot.p0;
	switch (arg) {
		case Letter:
			p0 = f->dot.p0;
			for (;counter > 1; --counter)
				move(Right);
			break;
		case Line:
			move(StartLine);
			p0 = f->dot.p0;
			for (;counter; --counter) {
				move(EndLine);
				move(Right);
			}
			if (f->dot.p1 + 1 < f->s->n)
				move(Left);
			break;
		case Bottom:
			move(StartLine);
			move(Left);
			p0 = f->dot.p0;
			move(Bottom);
			break;
		case Top:
			p0 = 0;
			move(EndLine);
			break;
		case Word:
			p0 = f->dot.p0;
			for (;counter; --counter)
				move(EndWord);
			break;
		case Till:
			arg = fgetc(stdin);
			if (arg == Esc)
				return 0;
			till:
			p0 = f->dot.p0;
			for (;counter && f->dot.p1 + 1 < f->s->n; --counter)
				for (++f->dot.p1; f->dot.p1 + 1 < f->s->n && f->s->s[f->dot.p1 + 1] != arg; ++f->dot.p1);
			if (f->s->s[f->dot.p1 + 1] != arg) {
				f->dot.p1 = f->dot.p0;
				return -1;
			}
			arg += 0x7f;
			break;
	}
	f->dot.p0 = p0;
	counter = 0;
	return arg;
}

static void
str_init(String* p)
{
	p->s = emalloc(MINSIZE * sizeof(*p->s));
	p->n = 0;
	p->size = MINSIZE;
}

static void
str_close(String* p)
{
	free(p->s);
}

static void
str_zero(String* p)
{
	if (p->size > MAXEMPTY) {
		p->s = erealloc(p->s, MAXEMPTY * sizeof(*p->s));
		p->size = MAXEMPTY;
	}
	p->n = 0;
	memset(p->s, 0, p->size);
}

static void
str_insure(String* p, ulong n)
{
	if (p->size < n) {
		p->size = n + MAXEMPTY;
		p->s = erealloc(p->s, p->size * sizeof(*p->s));
	}
}

static void
str_addc(String* p, int c)
{
	str_insure(p, p->n + 1);
	p->s[p->n++] = c;
	p->s[p->n] = '\0';
}

static void
str_adds(String* p, char* s, ulong n)
{
	str_insure(p, p->n + n);
	memmove(p->s + p->n, s, n);
	p->n += n;
}

static void
str_delc(String* p)
{
	if (p->n)
		p->s[--p->n] = 0;
}

static void
str_insert(String* p, String* q, Posn p0)
{
	str_insure(p, p->n + q->n);
	memmove(p->s + p0 + q->n, p->s + p0, p->n - p0);
	memmove(p->s + p0, q->s, q->n);
	p->n += q->n;
}

static void
str_delete(String* p, Posn p0, Posn p1)
{
	memmove(p->s + p0, p->s + p1, p->n - p1);
	p->n -= p1 - p0;
}

static void
undo(int arg)
{
	if (f->i < 0)
		return;
	if (buf->is[f->i].n)
		str_delete(f->s, buf->p0[f->i], buf->p0[f->i] + buf->is[f->i].n);
	if (buf->ds[f->i].n)
		str_insert(f->s, &buf->ds[f->i], buf->p0[f->i]);
	f->dot.p0 = f->dot.p1 = buf->p0[f->i--];
	f->dirty = '*';
	fr_zero(fr);
	fr_update();
}

static void
yank(int arg)
{
	if (!f->s->n)
		return;
	if (!arg) {
		switch (arg = fgetc(stdin)) {
			case 'y': arg = Line; break;
			case 'G': arg = Bottom; break;
			case 'g': arg = Top; break;
			case 'w': arg = Word; break;
			case 't': arg = Till; break;
			default:
				return;
		}
	}
	if ((arg = selection(arg)) < 0)
		return;
	str_zero(&istr);
	str_adds(&istr, f->s->s + f->dot.p0, f->dot.p1 + 1 - f->dot.p0);
}

int
main(int argc, char* argv[])
{
	uint i;
	uchar c;

	init();
	if (argv[1]) {
		str_adds(f->name, argv[1], strlen(argv[1]));
		file_load(f);
	}
	for (;;) {
		win_query(&w);
		fr_update();
		c = fgetc(stdin);
		for (i = 0; i < LENGTH(keys); ++i) {
			if (keys[i].key == c) {
				keys[i].func(keys[i].value);
				break;
			}
		}
	}
}
