campaign: server.pbl

server.pbl: server.pbl.in secrets/email secrets/passphrase
	cp $^ $@
	sed -i "s/@PASSPHRASE@/$(cat secrets/passphrase)/"
	sed -i "s/@EMAIL@/$(cat secrets/email)/"
