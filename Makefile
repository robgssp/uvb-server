PREFIX := /usr/local
CPPFLAGS := -I./include -I/usr/include
CFLAGS := -Wall -Wextra -fPIC -pedantic -pthread -lhttp_parser -llmdb

DEBUGFLAGS := -ggdb3
ifeq ($(CC),clang)
    DEBUGFLAGS := -ggdb
endif

ifeq ($(CC),gcc)
	CFLAGS += -std=c11
endif
ifeq ($(CC),clang)
	CFLAGS += -Weverything
endif

LIBSOURCE := $(addprefix src/,buffer.c counter.c http.c list.c lmdb_counter.c timers.c)
SOURCE := $(LIBSOURCE) src/server.c
CTRSOURCE := $(LIBSOURCE) src/countertest.c

EXECUTABLE := uvb-server

all: $(SOURCE)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $(EXECUTABLE) $(SOURCE)

debug: $(SOURCE)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEBUGFLAGS) -o $(EXECUTABLE) $(SOURCE)

profile: $(SOURCE)
	$(CC) $(CPPFLAGS) $(CFLAGS) -DGPROF $(DEBUGFLAGS) -pg -o $(EXECUTABLE) $(SOURCE)

release: $(SOURCE)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEBUGFLAGS) -O2 -o $(EXECUTABLE) $(SOURCE)

countertest: $(CTRSOURCE)
	$(CC) $(CPPFLAGS) $(CFLAGS) -ggdb -o countertest $(CTRSOURCE)


install:
	install -D $(EXECUTABLE) $(PREFIX)/bin/$(EXECUTABLE)

clean:
	$(RM) $(EXECUTABLE) counters.db names.db

uninstall:
	$(RM) $(PREFIX)/bin/$(EXECUTABLE)
