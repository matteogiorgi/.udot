#define STATUS "%lu 0x%02x %s%c -%lu- %u", f->dot.p1, f->s->s[f->dot.p1], f->name->n ? f->name->s : "-unnamed-", f->dirty, f - file, counter

Key keys[] = {
	{ 'c', change },
	{ 'C', change , '\n' + 0x7f },
	{ 'r', change, 'x' },
	{ '0', count, 0 },
	{ '1', count, 1 },
	{ '2', count, 2 },
	{ '3', count, 3 },
	{ '4', count, 4 },
	{ '5', count, 5 },
	{ '6', count, 6 },
	{ '7', count, 7 },
	{ '8', count, 8 },
	{ '9', count, 9 },
	{ 'd', delete },
	{ 'D', delete, '\n' + 0x7f },
	{ 'x', delete , Letter },
	{ '.', dot },
	{ Esc, escape },
	{ 'E', file_open },
	{ 'q', file_close, -1 },
	{ 'S', file_save, -1 },
	{ 'h', gmove, Left },
	{ 'j', gmove, Down },
	{ 'k', gmove, Up },
	{ 'l', gmove, Right },
	{ Ctrl + 'd', gmove, HalfDown },
	{ Ctrl + 'u', gmove, HalfUp },
	{ 'g', gmove, Top },
	{ 'w', gmove, Word },
	{ 'e', gmove, EndWord },
	{ 'b', gmove, PrevWord },
	{ 'i', insert },
	{ 'I', insert , StartLine},
	{ 'A', insert , EndLine },
	{ 'a', insert , Right },
	{ 'o', insert , Down },
	{ 'O', insert , Up },
	{ '@', pline },
	{ '$', move, EndLine },
	{ 'G', move, Bottom },
	{ 'p', paste },
	{ 'Q', quit },
	{ '/', search, '/' },
	{ '?', search, '?' },
	{ 'n', search, 'n' },
	{ 'N', search, 'N' },
	{ 'u', undo },
	{ Ctrl + 'r', redo },
	{ 'y', yank }
};