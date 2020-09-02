# set gcc as default if CC is not set

# Detect OS
OS := $(shell uname)

SRCS        = sslscan.c

PREFIX     ?= /usr/local
INCLUDEDIR ?= $(PREFIX)/include
LIBDIR     ?= $(PREFIX)/lib
BINDIR     ?= $(PREFIX)/bin
MANDIR     ?= $(PREFIX)/share/man
MAN1DIR    ?= $(MANDIR)/man1

# for dynamic linking
SSLSCAN_LIBS = -lssl -lcrypto
ifeq ($(OS), SunOS)
	SSLSCAN_LIBS   += -lsocket -lnsl
endif

.PHONY: all sslscan clean install uninstall static opensslpull

all: sslscan

sslscan: $(SRCS)
	$(CC) -o $@ ${CPPFLAGS} ${CFLAGS} ${SRCS} ${LDFLAGS} ${SSLSCAN_LIBS} ${LIBS}

install:
	@if [ ! -f sslscan ] ; then \
		echo "\n=========\n| ERROR |\n========="; \
		echo "Before installing you need to build sslscan with either \`make\` or \`make static\`\n"; \
		exit 1; \
	fi
ifeq ($(OS), Darwin)
	install -d $(DESTDIR)$(BINDIR)/;
	install sslscan $(DESTDIR)$(BINDIR)/sslscan;
	install -d $(DESTDIR)$(MAN1DIR)/;
	install sslscan.1 $(DESTDIR)$(MAN1DIR)/sslscan.1;
else
	install -D sslscan $(DESTDIR)$(BINDIR)/sslscan;
	install -D sslscan.1 $(DESTDIR)$(MAN1DIR)/sslscan.1;
endif

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/sslscan
	rm -f $(DESTDIR)$(MAN1DIR)/sslscan.1

test:	static
	./docker_test.sh

clean distclean:
	rm -f sslscan

.PHONY: all install test clean distclean