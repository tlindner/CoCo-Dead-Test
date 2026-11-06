LWASM ?= lwasm
PYTHON ?= python3

ROM = build/coco-dead-test.rom

.PHONY: all test

all: $(ROM)

$(ROM): src/dead-test.asm Makefile
	@mkdir -p build
	$(LWASM) --6809 --format=raw --output=$@ --list=build/coco-dead-test.lst --map=build/coco-dead-test.map $<

test: $(ROM)
	$(PYTHON) tests/check_rom.py $(ROM)
