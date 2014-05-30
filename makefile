BIN=./bin/live-spritesheet
MOCHA=./node_modules/mocha/bin/mocha
VERSION=0.2.2

install:
	npm install


watch: 
	coffee -o ./ -cw src/

build: 
	coffee -o ./ -c src/

run_simple:
	$(BIN) -c ./example/simple/config.json

run_nested:
	$(BIN) -c ./example/nested/images/config.json

bump.minor:
	@$(MVERSION) minor

bump.major:
	@$(MVERSION) major

bump.patch:
	@$(MVERSION) patch

publish:
	git tag $(VERSION)
	git push origin $(VERSION)
	git push origin master
	npm publish

re-publish:
	git tag -d $(VERSION)
	git tag $(VERSION)
	git push origin :$(VERSION)
	git push origin $(VERSION)
	git push origin master -f
	npm publish -f


# TEST
# ------------------------------------------------------------------------------

test:
	@$(MOCHA) --compilers coffee:coffee-script \
		--ui bdd \
		--reporter spec \
		--timeout 600000 \
		tests/runner.coffee --env='local'
