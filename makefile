BIN=./bin/live-spritesheet

install:
	npm install

run_simple:
	$(BIN) -c ./example/simple/config.json

run_nested:
	$(BIN) -c ./example/nested/images/config.json