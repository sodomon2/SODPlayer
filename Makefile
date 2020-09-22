# SODPlayer Makefile
#
# Copyright (c) 2020  Díaz  Urbaneja Victor Diego Alejandro  aka  (Sodomon)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

EXECUTABLE  = ./sodplayer
MSGFMT      = /usr/bin/msgfmt
LOCALE_PO   = locale
LOCALES     = /usr/share/locale/es_ES.UTF-8/LC_MESSAGES

all: locale

locale:
	$(MSGFMT) --check-accelerators=_ $(LOCALE_PO)/es.po -o $(LOCALE_PO)/es.mo

install: locale
	install -m775 $(EXECUTABLE) /usr/bin/
	mkdir -p /usr/share/sodplayer
	install -m775 init.lua /usr/share/sodplayer
	cp -r components/ /usr/share/sodplayer
	cp -r vistas/ /usr/share/sodplayer
	cp -r lib/ /usr/share/sodplayer
	mkdir -p $(LOCALES)
	cp -r locale/es.mo $(LOCALES)/sodplayer.mo
	install -m644 vistas/images/player.svg /usr/share/pixmaps/sodplayer.svg
	install -m644 sodplayer.desktop /usr/share/applications

uninstall :
	rm -r /usr/share/sodplayer/
	rm -f /usr/share/applications/sodplayer.desktop
	rm -f /usr/share/pixmaps/sodplayer.svg
	rm -f /usr/bin/$(EXECUTABLE)
	rm -f $(LOCALES)/sodplayer.mo

.PHONY: locale
