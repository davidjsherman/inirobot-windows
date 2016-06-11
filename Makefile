# Makefile for building Windows distribution

# default input artifacts
DASHEL = ~/src/build-dashel
PORTLIST = $(DASHEL)/portlist

ASEBA = ~/work/build-aseba
ASEBAHTTP = $(ASEBA)/switches/http/asebahttp.exe
ASEBASCRATCH = $(ASEBA)/examples/clients/scratch/asebascratch.exe

PROGRAMS = $(PORTLIST) $(ASEBAHTTP) $(ASEBASCRATCH)

DEPS = libgcc_s_dw2-1.dll libiconv-2.dll libstdc++-6.dll libwinpthread-1.dll libxml2-2.dll zlib1.dll liblzma-5.dll
DEPFILES = $(shell which $(DEPS))

# packaging
SCRATCH_DIR = Scratch
SCRATCH_ZIP = $(SCRATCH_DIR).zip
SCRATCH_VOL = Scratch2-ThymioII
squashcopy := rsync -a -L --no-perms --chmod=go-w

# rules
all:	dir deps pgms

dir:	
	mkdir -p $(SCRATCH_DIR)
	$(squashcopy) --exclude '.??*' --exclude tests --exclude playground \
		inirobot/ $(SCRATCH_DIR)
	cp Resources/Scratch2-ThymioII.lnk $(SCRATCH_DIR)

deps:	$(LIBS)
	mkdir -p $(SCRATCH_DIR)/bin
	mv $(SCRATCH_DIR)/thymio_motion.aesl $(SCRATCH_DIR)/bin
	cp Resources/asebascratch.ico $(SCRATCH_DIR)/bin
	$(if $(DEPFILES),install $(DEPFILES) $(SCRATCH_DIR)/bin)

pgms:	$(PROGRAMS)
	install $^ $(SCRATCH_DIR)/bin

$(SCRATCH_ZIP):	$(SCRATCH_DIR)
	(cd $(SCRATCH_DIR) && zip -r ../$(SCRATCH_ZIP) *)

archive:	$(SCRATCH_ZIP)
