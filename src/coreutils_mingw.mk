# This file is part of MXE.
# See index.html for further information.

PKG             := coreutils_mingw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.23
$(PKG)_CHECKSUM := adead02839225218b85133fa57b4dba02af2291d
$(PKG)_SUBDIR   := coreutils-$($(PKG)_VERSION)
$(PKG)_FILE     := coreutils-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/coreutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnu.org/pub/gnu/coreutils/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext gmp libiconv libtool

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/coreutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="coreutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef
