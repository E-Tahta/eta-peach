all: install

install:
	mkdir -p $(DESTDIR)/usr/share/kde4/apps/kwin/scripts/peachwindowswitcher
	@cp -fr peachwindowswitcher/* $(DESTDIR)/usr/share/kde4/apps/kwin/scripts/peachwindowswitcher/

	mkdir -p $(DESTDIR)/usr/share/kde4/services
	@cp -fr kwin-script-peachwindowswitcher.desktop $(DESTDIR)/usr/share/kde4/services/

	mkdir -p $(DESTDIR)/usr/share/eta/eta-peach
	@cp -fr peach.svg $(DESTDIR)/usr/share/eta/eta-peach/

uninstall:
	@rm -fr $(DESTDIR)/usr/share/eta/eta-peach/
	@rm -fr $(DESTDIR)/usr/share/kde4/services/kwin-script-peachwindowswitcher.desktop
	@rm -fr $(DESTDIR)/usr/share/kde4/apps/kwin/scripts/peachwindowswitcher

.PHONY: install uninstall
