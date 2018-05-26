all:
	@echo "Select one of:"
	@echo "\t" campaign
	@echo "\t" wexlfu
campaign: _server.pbl
wexlfu: loader.cfg

.PHONY: _server.pbl
_server.pbl: _server.pbl.in secrets/email secrets/passphrase
	cp $^ $@
	sed -i "s/@PASSPHRASE@/$(shell cat secrets/passphrase)/g" $@
	sed -i "s/@EMAIL@/$(shell cat secrets/email)/g" $@
	sed -i "s/@VERSION@/$(VERSION)/g" $@

.PHONY: loader.cfg
loader.cfg: loader.cfg.in
	cp $^ $@
	sed -i "s/@VERSION@/$(VERSION)/g" $@
