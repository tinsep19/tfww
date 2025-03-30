target := tfww 

.PHONY: build
build: $(target)
$(target): src/bashly.yml
	bashly generate --upgrade

.PHONY: all
all: build test

.PHONY: clean
clean:
	rm -f $(target)

.PHONY: test
test: test/approve
	CI=1 test/approve
