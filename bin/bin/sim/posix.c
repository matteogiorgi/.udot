#include <sys/ioctl.h>
#include <stdio.h>
#include <termios.h>

#include "sim.h"

void win_end();
void win_init();
void win_query();

static struct termios initial_state;

void
win_end()
{
	printf(ED CSI "H");
	tcsetattr(0, TCSAFLUSH, &initial_state);
}

void
win_init()
{
	struct termios raw_state;

	tcgetattr(0, &initial_state);
	raw_state = initial_state;
	raw_state.c_lflag &= ~(ECHO|ICANON|ISIG);
	tcsetattr(0, TCSAFLUSH, &raw_state);
	setbuf(stdout, NULL);
}

void
win_query(Window* w)
{
	struct winsize ws;

	ioctl(0, TIOCGWINSZ, &ws);
	w->wx = ws.ws_col;
	w->wy = ws.ws_row;
}
