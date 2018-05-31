all:
	@echo "Select one of:"
	@echo "\t" campaign
	@echo "\t" wexlfu

campaign: _server.pbl
wexlfu: loader.cfg

_server.pbl: _server.pbl.in secrets/email secrets/passphrase VERSION
	cp $< $@
	sed -i "s/@PASSPHRASE@/$(shell cat secrets/passphrase.ign)/g" $@
	sed -i "s/@EMAIL@/$(shell cat secrets/email.ign)/g" $@
	sed -i "s/@VERSION@/$(shell cat VERSION)/g" $@

loader.cfg: loader.cfg.in VERSION
	cp $< $@
	sed -i "s/@VERSION@/$(shell cat VERSION)/g" $@
