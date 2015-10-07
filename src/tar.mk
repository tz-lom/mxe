# This file is part of MXE.
# See index.html for further information.

PKG             := tar
$(PKG)_VERSION  := 1.13
$(PKG)_VERSION2 := $($(PKG)_VERSION)-1
$(PKG)_CHECKSUM := abc5f2bf6ca253b2fcf61c06ee509eb9ec1361ef
$(PKG)_SUBDIR   := src/$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION2)-src.zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gnuwin32/tar/$($(PKG)_VERSION2)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/cgit/wget.git/refs/' | \
    $(SED) -n "s,.*<a href='/cgit/wget.git/tag/?id=v\([0-9.]*\)'>.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf-2.13
    cd '$(1)' && ./configure $(MXE_CONFIGURE_OPTS)
        
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
