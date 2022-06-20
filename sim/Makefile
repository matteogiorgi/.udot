CC     = c89
CFLAGS = -Os -Wall -Wpedantic -Wno-deprecated-declarations -Wno-return-type
SRC    = ${wildcard *.c}
OBJ    = ${SRC:.c=.o}

all: sim

config.h:
	cp config.def.h $@

${OBJ}: config.h sim.h

sim: ${OBJ}
	${CC} ${OBJ} -o $@

%.o: %.c
	${CC} ${CFLAGS} -c $< -o $@

clean:
	rm -f sim *.o
