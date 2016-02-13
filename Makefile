DESTDIR=
PREFIX=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/bin
SRC=main.m QueryListener.m
BIN=mdlisten

$(BIN): $(SRC)
	clang $^ -Wall -Werror -fmodules -mmacosx-version-min=10.6 -o $@

clean:
	-rm $(BIN)

install: $(BIN)
	install -d $(BINDIR)
	install -c $< $(BINDIR)/$<

uninstall: $(BINDIR)/$(BIN)
	rm -f $<

.PHONY: clean install uninstall
