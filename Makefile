# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

PREFIX = /usr
DATA = /share
BIN = /bin
PKGNAME = auto-auto-complete
SHEBANG = /usr$(BIN)/env python3
COMMAND = auto-auto-complete
LICENSES = $(PREFIX)$(DATA)


all: auto-auto-complete #doc

#doc: info
#
#info: auto-auto-complete.info.gz
#
#%.info.gz: info/%.texinfo
#	makeinfo "$<"
#	gzip -9 -f "$*.info"

auto-auto-complete: auto-auto-complete.py
	cp "$<" "$@"
	sed -i 's:#!/usr/bin/env python3:#!$(SHEBANG)":' "$@"

install: auto-auto-complete #auto-auto-complete.info.gz
	install -dm755 "$(DESTDIR)$(PREFIX)$(BIN)"
	install -m755 auto-auto-complete "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	install -dm755 "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install -m644 COPYING LICENSE "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install -dm755 "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME)"
	install -m644 example "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME)"
#	install -dm755 "$(DESTDIR)$(PREFIX)$(DATA)/info"
#	install -m644 auto-auto-complete.info.gz "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

uninstall:
	rm -- "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/LICENSE"
	rm -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME)/example"
	rmdir -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME)"
#	rmdir -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
#	rm -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

clean:
	-rm -f auto-auto-complete #auto-auto-complete.info.gz


.PHONY: all install uninstall clean

