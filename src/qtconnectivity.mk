# This file is part of MXE.
# See index.html for further information.

PKG             := qtconnectivity
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := b393471529502028b0d5318088a27e48e944bc90
$(PKG)_SUBDIR    = $(subst qtbase,qtconnectivity,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtconnectivity,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtconnectivity,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
