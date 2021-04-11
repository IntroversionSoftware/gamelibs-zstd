# -*- Makefile -*- for zstd

.SECONDEXPANSION:
.SUFFIXES:

ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
        QUIET          = @
        QUIET_CC       = @echo '   ' CC $<;
        QUIET_AR       = @echo '   ' AR $@;
        QUIET_RANLIB   = @echo '   ' RANLIB $@;
        QUIET_INSTALL  = @echo '   ' INSTALL $<;
        export V
endif
endif

LIB    = libzstd.a
AR    ?= ar
ARFLAGS ?= rc
CC    ?= gcc
RANLIB?= ranlib
RM    ?= rm -f

BUILD_DIR := build-lib
BUILD_ID  ?= default-build-id
OBJ_DIR   := $(BUILD_DIR)/$(BUILD_ID)

ifeq (,$(BUILD_ID))
$(error BUILD_ID cannot be an empty string)
endif

prefix ?= /usr/local
libdir := $(prefix)/lib
includedir := $(prefix)/include

HEADERS = lib/zstd.h
SOURCES = \
	lib/common/debug.c \
	lib/common/entropy_common.c \
	lib/common/error_private.c \
	lib/common/fse_decompress.c \
	lib/common/pool.c \
	lib/common/threading.c \
	lib/common/xxhash.c \
	lib/common/zstd_common.c \
	lib/compress/fse_compress.c \
	lib/compress/hist.c \
	lib/compress/huf_compress.c \
	lib/compress/zstd_compress.c \
	lib/compress/zstd_compress_literals.c \
	lib/compress/zstd_compress_sequences.c \
	lib/compress/zstd_compress_superblock.c \
	lib/compress/zstd_double_fast.c \
	lib/compress/zstd_fast.c \
	lib/compress/zstd_lazy.c \
	lib/compress/zstd_ldm.c \
	lib/compress/zstd_opt.c \
	lib/compress/zstdmt_compress.c \
	lib/decompress/huf_decompress.c \
	lib/decompress/zstd_ddict.c \
	lib/decompress/zstd_decompress.c \
	lib/decompress/zstd_decompress_block.c \
	lib/deprecated/zbuff_common.c \
	lib/deprecated/zbuff_compress.c \
	lib/deprecated/zbuff_decompress.c \
	lib/dictBuilder/cover.c \
	lib/dictBuilder/divsufsort.c \
	lib/dictBuilder/fastcover.c \
	lib/dictBuilder/zdict.c \
	lib/legacy/zstd_v01.c \
	lib/legacy/zstd_v02.c \
	lib/legacy/zstd_v03.c \
	lib/legacy/zstd_v04.c \
	lib/legacy/zstd_v05.c \
	lib/legacy/zstd_v06.c \
	lib/legacy/zstd_v07.c

ifneq ($(findstring x86_64,$(shell $(CC) $(CFLAGS) -dumpmachine)),)
    SOURCES += \
		lib/decompress/huf_decompress_amd64.S
endif

HEADERS_INST := $(patsubst lib/%,$(includedir)/%,$(HEADERS))
OBJECTS := $(filter %.o,$(patsubst %.c,$(OBJ_DIR)/%.o,$(SOURCES)))
OBJECTS += $(filter %.o,$(patsubst %.S,$(OBJ_DIR)/%.o,$(SOURCES)))

CFLAGS ?= -O2

.PHONY: install

all: $(OBJ_DIR)/$(LIB)

$(includedir)/%.h: lib/%.h
	-@if [ ! -d $(includedir)  ]; then mkdir -p $(includedir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

$(libdir)/%.a: $(OBJ_DIR)/%.a
	-@if [ ! -d $(libdir)  ]; then mkdir -p $(libdir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

install: $(HEADERS_INST) $(libdir)/$(LIB)

clean:
	$(RM) -r $(OBJ_DIR)

distclean: clean
	$(RM) -r $(BUILD_DIR)

$(OBJ_DIR)/$(LIB): $(OBJECTS) | $$(@D)/.
	$(QUIET_AR)$(AR) $(ARFLAGS) $@ $^
	$(QUIET_RANLIB)$(RANLIB) $@

$(OBJ_DIR)/%.o: %.c $(OBJ_DIR)/.cflags | $$(@D)/.
	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ -c $<

$(OBJ_DIR)/%.o: %.S $(OBJ_DIR)/.cflags | $$(@D)/.
	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ -c $<

.PRECIOUS: $(OBJ_DIR)/. $(OBJ_DIR)%/.

$(OBJ_DIR)/.:
	$(QUIET)mkdir -p $@

$(OBJ_DIR)%/.:
	$(QUIET)mkdir -p $@

TRACK_CFLAGS = $(subst ','\'',$(CC) $(CFLAGS))

$(OBJ_DIR)/.cflags: .force-cflags | $$(@D)/.
	@FLAGS='$(TRACK_CFLAGS)'; \
    if test x"$$FLAGS" != x"`cat $(OBJ_DIR)/.cflags 2>/dev/null`" ; then \
        echo "    * rebuilding zstd: new build flags or prefix"; \
        echo "$$FLAGS" > $(OBJ_DIR)/.cflags; \
    fi

.PHONY: .force-cflags
