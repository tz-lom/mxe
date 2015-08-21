# This file is part of MXE.
# See index.html for further information.

PKG             := make_mingw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1
$(PKG)_CHECKSUM := 0d701882fd6fd61a9652cb8d866ad7fc7de54d58
$(PKG)_SUBDIR   := make-$($(PKG)_VERSION)
$(PKG)_FILE     := make-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/make/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnu.org/pub/gnu/make/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/make/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="make-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        CFLAGS='-I$(1)/w32/include -DWINDOWS32 -DHAVE_CONFIG_H'
        
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
    
endef
