# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# The package path prefix, if you want to install to another root, set DESTDIR to that root
PREFIX = /usr
# The command path excluding prefix
BIN = /bin
# The resource path excluding prefix
DATA = /share
# The command path including prefix
BINDIR = $(PREFIX)$(BIN)
# The resource path including prefix
DATADIR = $(PREFIX)$(DATA)
# The generic documentation path including prefix
DOCDIR = $(DATADIR)/doc
# The info manual documentation path including prefix
INFODIR = $(DATADIR)/info
# The man page documentation path including prefix
MANDIR = $(DATADIR)/man
# The man page section 1 path including prefix
MAN1DIR = $(MANDIR)/man1
# The license base path including prefix
LICENSEDIR = $(DATADIR)/licenses

# Python 3 command to use in shebangs
SHEBANG = /usr$(BIN)/env python3
# The name of the command as it should be installed
COMMAND = auto-auto-complete
# The name of the package as it should be installed
PKGNAME = auto-auto-complete


# Build rules

.PHONY: default
default: base info shell

.PHONY: all
all: base doc shell

.PHONY: base
base: command


# Build rules for the command

.PHONY: command
command: bin/auto-auto-complete

bin/auto-auto-complete: src/auto-auto-complete.py
	@mkdir -p bin
	cp "$<" "$@"
	sed -i 's:#!/usr/bin/env python3:#!$(SHEBANG):' "$@"


# Build rules for documentation

.PHONY: doc
doc: info pdf dvi ps

.PHONY: info
info: bin/auto-auto-complete.info
bin/%.info: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p bin
	makeinfo $<
	mv $*.info $@

.PHONY: pdf
pdf: bin/auto-auto-complete.pdf
bin/%.pdf: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p obj/pdf bin
	cd obj/pdf && texi2pdf ../../$< < /dev/null
	mv obj/pdf/$*.pdf $@

.PHONY: dvi
dvi: bin/auto-auto-complete.dvi
bin/%.dvi: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p obj/dvi bin
	cd obj/dvi && $(TEXI2DVI) ../../$< < /dev/null
	mv obj/dvi/$*.dvi $@

.PHONY: ps
ps: bin/auto-auto-complete.ps
bin/%.ps: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p obj/ps bin
	cd obj/ps && texi2pdf --ps ../../$< < /dev/null
	mv obj/ps/$*.ps $@


# Build rules for shell auto-completion

.PHONY: shell
shell: bash zsh fish

.PHONY: bash
bash: bin/auto-auto-complete.bash
bin/auto-auto-complete.bash: src/completion bin/auto-auto-complete
	@mkdir -p bin
	bin/auto-auto-complete bash --output $@ --source $<

.PHONY: zsh
zsh: bin/auto-auto-complete.zsh
bin/auto-auto-complete.zsh: src/completion bin/auto-auto-complete
	@mkdir -p bin
	bin/auto-auto-complete zsh --output $@ --source $<

.PHONY: fish
fish: bin/auto-auto-complete.fish
bin/auto-auto-complete.fish: src/completion bin/auto-auto-complete
	@mkdir -p bin
	bin/auto-auto-complete fish --output $@ --source $<


# Install rules

.PHONY: install
install: install-base install-examples install-info install-man install-shell

.PHONY: install
install-all: install-base install-doc install-shell

# Install base rules

.PHONY: install-base
install-base: install-command install-license

.PHONY: install-command-bin
install-command: bin/auto-auto-complete
	install -dm755 -- "$(DESTDIR)$(BINDIR)"
	install -m755 $< -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"

.PHONY: install-license
install-license:
	install -dm755 -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 COPYING LICENSE -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"

# Install documentation

.PHONY: install-doc
install-doc: install-examples install-info install-pdf install-ps install-dvi install-man

.PHONY: install-examples
install-examples: doc/example
	install -dm755 -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)"
	install -m644 $^ -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/example"

.PHONY: install-info
install-info: bin/auto-auto-complete.info
	install -dm755 -- "$(DESTDIR)$(INFODIR)"
	install -m644 $< -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"

.PHONY: install-pdf
install-pdf: bin/auto-auto-complete.pdf
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/$(PKGNAME).pdf"

.PHONY: install-ps
install-ps: bin/auto-auto-complete.ps
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/$(PKGNAME).ps"

.PHONY: install-dvi
install-dvi: bin/auto-auto-complete.dvi
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/$(PKGNAME).dvi"

.PHONY: install-man
install-man: doc/man/auto-auto-complete.1
	install -dm755 -- "$(DESTDIR)$(MAN1DIR)"
	install -m644 $< -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"

# Install shell auto-completion

.PHONY: install-shell
install-shell: install-bash install-zsh install-fish

.PHONY: install-bash
install-bash: bin/auto-auto-complete.bash
	install -dm755 -- "$(DESTDIR)$(DATADIR)/bash-completion/completions"
	install -m644 $< -- "$(DESTDIR)$(DATADIR)/bash-completion/completions/$(COMMAND)"

.PHONY: install-zsh
install-zsh: bin/auto-auto-complete.zsh
	install -dm755 -- "$(DESTDIR)$(DATADIR)/zsh/site-functions"
	install -m644 $< -- "$(DESTDIR)$(DATADIR)/zsh/site-functions/_$(COMMAND)"

.PHONY: install-fish
install-fish: bin/auto-auto-complete.fish
	install -dm755 -- "$(DESTDIR)$(DATADIR)/fish/completions"
	install -m644 $< -- "$(DESTDIR)$(DATADIR)/fish/completions/$(COMMAND).fish"


# Uninstall rules

uninstall:
	-rm -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/$(PKGNAME).pdf"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/$(PKGNAME).ps"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/$(PKGNAME).dvi"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)/example"
	-rm -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"
	-rmdir -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(DATADIR)/fish/completions/$(COMMAND).fish"
	-rmdir -- "$(DESTDIR)$(DATADIR)/fish/completions"
	-rmdir -- "$(DESTDIR)$(DATADIR)/fish"
	-rm -- "$(DESTDIR)$(DATADIR)/zsh/site-functions/_$(COMMAND)"
	-rmdir -- "$(DESTDIR)$(DATADIR)/zsh/site-functions"
	-rmdir -- "$(DESTDIR)$(DATADIR)/zsh"
	-rm -- "$(DESTDIR)$(DATADIR)/bash-completion/completions/$(COMMAND)"
	-rmdir -- "$(DESTDIR)$(DATADIR)/bash-completion/completions"
	-rmdir -- "$(DESTDIR)$(DATADIR)/bash-completion"


# Clean rules

.PHONY: clean
clean:
	-rm -fr bin obj

