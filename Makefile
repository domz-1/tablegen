.PHONY: all install uninstall test
all:
	@echo "Run 'make install' to install TableGen"
install:
	@bash ./install.sh
uninstall:
	@bash ./uninstall.sh
test:
	@./bin/tablegen md
