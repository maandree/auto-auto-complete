.POSIX:

CONFIGFILE = config.mk
include $(CONFIGFILE)


all: auto-auto-complete.bash auto-auto-complete.zsh auto-auto-complete.fish

auto-auto-complete.bash: completion ./auto-auto-complete
	./auto-auto-complete bash --output $@ --source completion

auto-auto-complete.zsh: completion ./auto-auto-complete
	./auto-auto-complete zsh --output $@ --source completion

auto-auto-complete.fish: completion ./auto-auto-complete
	./auto-auto-complete fish --output $@ --source completion

install: auto-auto-complete.bash auto-auto-complete.zsh auto-auto-complete.fish
	mkdir -p -- "$(DESTDIR)$(PREFIX)/bin"
	mkdir -p -- "$(DESTDIR)$(MANPREFIX)/man1"
	mkdir -p -- "$(DESTDIR)$(PREFIX)/share/licenses"
	mkdir -p -- "$(DESTDIR)$(PREFIX)/share/doc/auto-auto-complete"
	mkdir -p -- "$(DESTDIR)$(PREFIX)/share/bash-completion/completions"
	mkdir -p -- "$(DESTDIR)$(PREFIX)/share/zsh/site-functions"
	mkdir -p -- "$(DESTDIR)$(PREFIX)/share/fish/completions"
	test ! -d "$(DESTDIR)$(PREFIX)/share/licenses/auto-auto-complete"
	test ! -d "$(DESTDIR)$(PREFIX)/share/bash-completion/completions/auto-auto-complete"
	test ! -d "$(DESTDIR)$(PREFIX)/share/zsh/site-functions/_auto-auto-complete"
	test ! -d "$(DESTDIR)$(PREFIX)/share/fish/completions/auto-auto-complete.fish"
	cp -- auto-auto-complete "$(DESTDIR)$(PREFIX)/bin/"
	cp -- auto-auto-complete.1 "$(DESTDIR)$(MANPREFIX)/man1/"
	cp -- LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/auto-auto-complete"
	cp -- doc/example "$(DESTDIR)$(PREFIX)/share/doc/auto-auto-complete/"
	cp -- auto-auto-complete.bash "$(DESTDIR)$(PREFIX)/share/bash-completion/completions/auto-auto-complete"
	cp -- auto-auto-complete.zsh "$(DESTDIR)$(PREFIX)/share/zsh/site-functions/_auto-auto-complete"
	cp -- auto-auto-complete.fish "$(DESTDIR)$(PREFIX)/share/fish/completions/auto-auto-complete.fish"

uninstall:
	-rm -f -- "$(DESTDIR)$(PREFIX)/bin/auto-auto-complete"
	-rm -f -- "$(DESTDIR)$(MANPREFIX)/man1/auto-auto-complete.1"
	-rm -f -- "$(DESTDIR)$(PREFIX)/share/licenses/auto-auto-complete"
	-rm -f -- "$(DESTDIR)$(PREFIX)/share/doc/auto-auto-complete/example"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/doc/auto-auto-complete"
	-rm -f -- "$(DESTDIR)$(PREFIX)/share/bash-completion/completions/auto-auto-complete"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/bash-completion/completions"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/bash-completion"
	-rm -f -- "$(DESTDIR)$(PREFIX)/share/zsh/site-functions/_auto-auto-complete"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/zsh/site-functions"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/zsh"
	-rm -f -- "$(DESTDIR)$(PREFIX)/share/fish/completions/auto-auto-complete.fish"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/fish/completions"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/fish"

clean:
	-rm -rf -- __pycache__ *.pyc* *.pyo*
	-rm -f -- auto-auto-complete.bash auto-auto-complete.zsh auto-auto-complete.fish

.PHONY: all install uninstall clean
