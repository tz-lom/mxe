# This file is part of MXE.
# See index.html for further information.

PKG             := capnproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.1
$(PKG)_CHECKSUM := e631ce4fc7abf4a3a29557580d7176ea8265d13b
$(PKG)_SUBDIR   := $(PKG)-release-$($(PKG)_VERSION)/c++
$(PKG)_FILE     := release-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://github.com/sandstorm-io/capnproto/archive/release-$($(PKG)_VERSION).zip
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD

    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' -DCAPNP_LITE=ON -DBUILD_TESTING=OFF

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1
endef
