TARGET:=tfww
TEST:=test/approve
SRCS=$(shell git ls-files src/* )

.PHONY : build
build : $(TARGET)

$(TARGET): $(SRCS)
	bashly generate --upgrade

.PHONY: all
all: clean build test

.PHONY: clean
clean:
	git clean -x -f

.PHONY: test
test: $(TEST) $(TARGET)
	CI=1 $(TEST)

