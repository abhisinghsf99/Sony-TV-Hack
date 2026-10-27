TOOLS := bin/depth-mask bin/sky-shift

all: $(TOOLS)

bin/%: scripts/%.swift
	@mkdir -p bin
	swiftc -O $< -o $@

clean:
	rm -rf bin

.PHONY: all clean
