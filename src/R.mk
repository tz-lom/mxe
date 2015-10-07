# This file is part of MXE.
# See index.html for further information.

PKG             := R
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_CHECKSUM := 68c74db1c5a2f2040280a03b8396e4d28a5a7617
$(PKG)_SUBDIR   := R-$($(PKG)_VERSION)
$(PKG)_FILE     := R-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://cran.r-project.org/src/base/R-3/R-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libpng libjpeg-turbo zlib pcre readline pango xz blas lapack bzip2 curl

SRC_DIR := /home/tz-lom/sources/mxe/src

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)'
    
    mv '$(1)/src/gnuwin32/front-ends/RGui32.manifest' '$(1)/src/gnuwin32/front-ends/Rgui32.manifest'
    mv '$(1)/src/gnuwin32/front-ends/RGui64.manifest' '$(1)/src/gnuwin32/front-ends/Rgui64.manifest'
   
    mkdir -p '$(1)/wine'
    WINEPREFIX='$(1)/wine' wine regedit '$(SRC_DIR)/R/wine.reg'
    ln -s '$(PREFIX)/$(TARGET)' '$(1)/wine/dosdevices/h:'

    
    cp '$(SRC_DIR)/R/MkRules.local' '$(1)/src/gnuwin32/'
    cp '$(SRC_DIR)/R/Rpwd.exe' '$(1)/'
    
    cd '$(1)/src/gnuwin32' && WINEPREFIX='$(1)/wine' $(MAKE) 
    
    
    exit 1
    
endef