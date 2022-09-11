.PHONY: help
help:
	@echo Available targets:
	@echo - install PREFIX=... DESTDIR=...

LUA_MODULES_DIR?=	share/lua

.PHONY: install
install: cadet.lua
	install -d ${DESTDIR}${PREFIX}/${LUA_MODULES_DIR}
	install -m0644 cadet.lua ${DESTDIR}${PREFIX}/${LUA_MODULES_DIR}
