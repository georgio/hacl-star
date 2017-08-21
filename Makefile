#
# Main HACL* Makefile
#

.PHONY: display verify test clean

all: display

display:
	@echo "HaCl* Makefile:"
	@echo "- 'verify' will run F* verification on all specs, code and secure-api directories"
	@echo "- 'extract' will generate all the C code into a snapshot and test it (no verification)"
	@echo "- 'build' will generate both static and shared libraries (no verification)"
	@echo "- 'test' will generate and test everything (no verification)"
	@echo "- 'world' will run everything (except make prepare)"
	@echo ""
	@echo "Specialized targets:"
	@echo "- 'verify-ct' will run F* verification of the code for the side-channel resistance"
	@echo "- 'verify-specs' will run F* verification on the specifications"
	@echo "- 'verify-code' will run F* verification on the code against the specification"
	@echo "- 'verify-secure_api' will run F* verification of the secure_api directory"
	@echo "- 'extract-specs' will generate OCaml code for the specifications"
	@echo "- 'extract-c-code' will generate C code for all the stable primitives"
	@echo "- 'extract-c-code-experimental' will generate C code for experimental primitives"
	@echo "- 'extract-all-snapshots' will generate C code for multiple compilers"
	@echo "- 'prepare' will install F* and Kremlin (Requirements are still needed)"
	@echo "- 'clean-snapshots' will remove all snapshots"
	@echo "- 'clean' will remove all artifacts of other targets"

#
# Includes
#

include Makefile.include
include Makefile.build

#
# Verification
#

verify-banner:
	@echo $(CYAN)"# Verification of the HaCl*"$(NORMAL)

verify-ct:
	$(MAKE) -C code ct

verify-specs: specs.dir-verify
verify-code: code.dir-verify
verify-secure_api: secure_api.dir-verify

verify: verify-banner verify-ct verify-specs verify-code verify-secure_api

#
# Code generation
#

extract: snapshot

extract-specs:
	$(MAKE) -C specs

extract-all-snapshots: snapshot-all

#
# Compilation of the library
#

build:
	@echo $(CYAN)"# Compiling the HaCl* library"$(NORMAL)
	mkdir -p build && cd build; \
	cmake $(CMAKE_COMPILER_OPTION) .. && make
	@echo $(CYAN)"\nDone ! Generated libraries can be found in 'build'."$(NORMAL)

#
# Test specification and code
#

test:
	@echo $(CYAN)"# Testing the HaCl* code and specifications"$(NORMAL)
	$(MAKE) -C tests

#
# Additional targets
#

prepare:
	@echo "# Installing OCaml packages required by F*"
	opam install ocamlfind batteries sqlite3 fileutils stdint zarith yojson pprint menhir
	@echo "# Installing OCaml packages required by KreMLin"
	opam install ppx_deriving_yojson zarith pprint menhir ulex process fix wasm
	@echo "# Installing submodules for F* and KreMLin"
	git submodule update --init
	@echo "# Compiling and Installing F*"
	$(MAKE) -C dependencies/FStar/src/ocaml-output
	$(MAKE) -C dependencies/FStar/ulib/ml
	@echo "# Compiling and Installing KreMLin"
	$(MAKE) -C dependencies/kremlin

clean-banner:
	@echo $(CYAN)"# Clean HaCl*"$(NORMAL)

clean-base:
	rm -rf *~

clean-build:
	rm -rf build
	rm -rf build-experimental

clean-snapshots:
	rm -rf ./snapshots/hacl-c
	rm -rf ./snapshots/snapshot*

clean: clean-banner clean-base clean-build specs.dir-clean code.dir-clean secure_api.dir-clean apps.dir-clean

#
# Undocumented targets
#

experimental:
	@echo $(CYAN)"# Compiling the HaCl* library (with experimental features)"$(NORMAL)
	mkdir -p build-experimental && cd build-experimental; \
	cmake $(CMAKE_COMPILER_OPTION) -DExperimental=ON .. && make
	@echo $(CYAN)"\nDone ! Generated libraries can be found in 'build-experimental'."$(NORMAL)

hints: code.dir-hints secure_api.dir-hints specs.dir-hints

# Check if GCC-7 is installed, uses GCC otherwise
GCC_EXEC := $(shell gcc-7 --version 2>/dev/null | cut -c -5 | head -n 1)
ifdef GCC_EXEC
   CMAKE_COMPILER_OPTION := -DCMAKE_C_COMPILER=gcc-7
endif

NORMAL="\\033[0;39m"
CYAN="\\033[1;36m"
