PKGS ?= \
  abcBridge \
  binary-symbols \
  crucible \
  crucible-jvm \
  crucible-llvm \
  crucible-saw \
  cryptol \
  cryptol-verifier \
  elf-edit \
  flexdis86 \
  galois-dwarf \
  jvm-parser \
  llvm-pretty \
  llvm-pretty-bc-parser \
  llvm-verifier \
  macaw-base \
  macaw-symbolic \
  macaw-x86 \
  macaw-x86-symbolic \
  parameterized-utils \
  saw \
  saw-core \
  saw-core-aig \
  saw-core-sbv \
  what4

.PHONY: travis
travis:
	./scripts/travis-yml.sh $(PKGS)

.PHONY: build
build:
	./scripts/build-all.sh $(PKGS)

%.json:
	nix-prefetch-git "ssh://git@github.com/GaloisInc/$(basename $@)" > "$@"

.PHONY: clean
clean:
	rm result*

.PHONY: all
all: travis build
