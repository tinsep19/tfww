target = $(shell sed -n -r 's/^name:\s*(\w+)/\1/p' src/bashly.yml)
completion = src/lib/send_completions.sh

.PHONY: all
all: $(target)

$(target) : src/bashly.yml $(completion)
	bashly generate

$(completion) : completions.yml
	completely generate $< $@ -w send_completions

.PHONY: clean
clean:
	rm -f $(target) $(completion)
