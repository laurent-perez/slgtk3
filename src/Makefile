MODNAME = gtk3
LFLAGS = `pkg-config --libs gtk+-3.0 gtk+-unix-print-3.0`
IFLAGS = `pkg-config --cflags gtk+-3.0 gtk+-unix-print-3.0`
MODULE = $(MODNAME)-module.so
SRC = slgtk3.c module.c
SLANGINC = `pkg-config --cflags slang`
SLANGLIB = `pkg-config --libs slang`
CC = gcc
# CFLAGS = -g -O2 -fno-strength-reduce -fno-strict-aliasing -Wall
CFLAGS = -O2 -fno-strength-reduce -fno-strict-aliasing -Wall
SO_CFLAGS = $(CFLAGS) -fPIC -I. $(SLANGINC) $(IFLAGS)
CC_SHARED = $(CC) $(CFLAGS) -shared -fPIC
C_COMPILE = $(CC) $(SO_CFLAGS) -c
DL_LIB = -ldl -lm -lc
LINK = $(CC) -shared -Wl,-soname,$(MODULE)
OBJ= $(SRC:.c=.o)

all: $(MODULE)

$(MODULE): $(OBJ)
	@echo
	$(LINK) -o $@ $(OBJ) $(LFLAGS) $(SLANGLIB) $(DL_LIB)

$(OBJ): $(SRC)
	@echo
	$(C_COMPILE) $(CFLAGS) $(SRC)

clean:
	rm $(OBJ)
