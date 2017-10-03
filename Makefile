all: install

install:
	@echo "Installing Peach Kwin Script"
	mkdir -p $(DESTDIR)/usr/share/kde4/apps/kwin/scripts/peach-screencontrol
	@cp -fr peach-screencontrol/* $(DESTDIR)/usr/share/kde4/apps/kwin/scripts/peach-screencontrol/

	@echo "Installing Peach Kwin Service"
	mkdir -p $(DESTDIR)/usr/share/kde4/services
	@cp -fr kwin-script-peach-screencontrol.desktop $(DESTDIR)/usr/share/kde4/services/

	@echo "Installing Peach Icon"
	mkdir -p $(DESTDIR)/usr/share/eta/eta-peach
	@cp -fr peach.svg $(DESTDIR)/usr/share/eta/eta-peach/

uninstall:
	@echo "Removing Peach"
	@rm -fr $(DESTDIR)/usr/share/eta/eta-peach/
	@rm -fr $(DESTDIR)/usr/share/kde4/services/kwin-script-peach-screencontrol.desktop
	@rm -fr $(DESTDIR)/usr/share/kde4/apps/kwin/scripts/peach-screencontrol

.PHONY: install uninstall
