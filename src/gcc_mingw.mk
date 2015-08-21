# This file is part of MXE.
# See index.html for further information.

PKG             := gcc_mingw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.0
$(PKG)_CHECKSUM := fe3f5390949d47054b613edc36c557eb1d51c18e
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := binutils_mingw gcc-gmp_mingw gcc-isl_mingw gcc-mpc-mingw gcc-mpfr_mingw gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    # configure gcc
    
    if [ ! -d '$(PREFIX)/mingw' ]; then ln -s '$(PREFIX)/$(TARGET)' '$(PREFIX)/mingw'; fi
    
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sysroot='$(PREFIX)' \
        --enable-languages='c,c++,objc,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(if $(BUILD_STATIC),--disable-shared) \
        --disable-multilib \
        --without-x \
        --disable-win32-registry \
        --enable-threads=win32 \
        --disable-libgomp \
        --with-gmp='$(PREFIX)/$(TARGET)' \
        --with-isl='$(PREFIX)/$(TARGET)' \
        --with-mpc='$(PREFIX)/$(TARGET)' \
        --with-mpfr='$(PREFIX)/$(TARGET)' \
        --with-native-system-header-dir='/include' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
endef

define $(PKG)_POST_BUILD
#    # TODO: find a way to configure the installation of these correctly
#    rm -f $(addprefix $(PREFIX)/$(TARGET)/bin/, c++ g++ gcc gfortran)
#    -mv '$(PREFIX)/lib/gcc/$(TARGET)/lib/'* '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'
#    -mv '$(PREFIX)/lib/gcc/$(TARGET)/'*.dll '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'
#    -cp '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'*.dll '$(PREFIX)/$(TARGET)/bin/'
#    -cp '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'*.dll.a '$(PREFIX)/$(TARGET)/lib/'
    rm '$(PREFIX)/mingw'
endef

define $(PKG)_BUILD_mingw-w64
    # build standalone gcc
    $($(PKG)_CONFIGURE)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # build mingw-w64-crt
#    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,mingw-w64)
#    mkdir '$(1).crt-build'
#    cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
#        --host='$(TARGET)' \
#        --prefix='$(PREFIX)/$(TARGET)' \
#        @gcc-crt-config-opts@
#    $(MAKE) -C '$(1).crt-build' -j '$(JOBS)' || $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
#    $(MAKE) -C '$(1).crt-build' -j 1 install

    # build rest of gcc
    cd '$(1).build'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    $($(PKG)_POST_BUILD)
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @gcc-crt-config-opts@,--disable-lib32,$($(PKG)_BUILD_mingw-w64))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @gcc-crt-config-opts@,--disable-lib64,$($(PKG)_BUILD_mingw-w64))

