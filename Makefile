PKGS ?= \
  abcBridge \
  binary-symbols \
  cryptol \
  crucible \
  crucible-jvm \
  crucible-llvm \
  crucible-saw \
  crux \
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
  saw-script \
  saw-core \
  saw-core-aig \
  saw-core-sbv \
  what4

# This doesn't exactly match to_build, because multiple projects are in the same
# git repo.
#
# Additionally, abcBridge and llvm-pretty are handled manually.
#
# TODO: This is unused. Should make update-all target.
JSON ?= \
  cryptol \
  parameterized-utils \
  saw-script \
  saw-core \
  saw-core-aig \
  saw-core-sbv \
  saw-core-what4 \
  crucible \
  cryptol-verifier \
  elf-edit \
  flexdis86 \
  dwarf \
  jvm-parser \
  jvm-verifier \
  llvm-pretty-bc-parser \
  llvm-verifier \
  macaw

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
