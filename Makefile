uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
CC=gcc
ifeq ($(uname_S), Darwin)
	SHARED = -fPIC -dynamiclib -Wl,-undefined,dynamic_lookup
else
	SHARED = -fPIC --shared
endif

all:  linenoise_example linenoise_utf8_example linenoise_cpp_example linenoise.so

linenoise_example: linenoise.h linenoise.c example.c
	$(CC) -Wall -W -Os -g -o $@ linenoise.c example.c

linenoise_utf8_example: linenoise.c utf8.c example.c
	$(CC) -DNO_COMPLETION -DUSE_UTF8 -Wall -W -Os -g -o $@ linenoise.c utf8.c example.c

linenoise_cpp_example: linenoise.h linenoise.c
	g++ -Wall -W -Os -g -o $@ linenoise.c example.c

linenoise.so: linenoiselib.c linenoise.c utf8.c
	$(CC) -Wall -Os $(SHARED) $^ -o $@

clean:
	rm -r -f linenoise_example linenoise_utf8_example linenoise_cpp_example linenoise.so *.o *.dSYM
