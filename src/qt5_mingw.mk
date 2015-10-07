# This file is part of MXE.
# See index.html for further information.

PKG             := qt5_mingw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.5.0
$(PKG)_CHECKSUM := 4409ef12d1017a9b5e6733ea27596a6ca637a88c
$(PKG)_SUBDIR   := qt-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := qt-everywhere-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.qt.io/official_releases/qt/5.5/$($(PKG)_VERSION)/single/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc postgresql freetds openssl harfbuzz zlib libpng jpeg sqlite pcre fontconfig freetype dbus

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.qt-project.org/official_releases/qt/5.5/ | \
    $(SED) -n 's,.*href="\(5\.[0-9]\.[^/]*\)/".*,\1,p' | \
    grep -iv -- '-rc' | \
    tail -1
endef

define $(PKG)_BUILD
    # ICU is buggy. See #653. TODO: reenable it some time in the future.
    cd '$(1)' && \
        OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl` -lws2_32" \
        SYBASE_LIBS="-lsybdb `'$(TARGET)-pkg-config' --libs-only-l gnutls` -liconv -lws2_32" \
        ./configure \
            -opensource \
            -confirm-license \
            -xplatform win32-g++ \
            -device-option CROSS_COMPILE=${TARGET}- \
            -device-option PKG_CONFIG='${TARGET}-pkg-config' \
            -force-pkg-config \
            -no-use-gold-linker \
            -debug-and-release \
            -shared \
            -prefix '$(PREFIX)/$(TARGET)/qt5-mingw' \
            -no-icu \
            -opengl desktop \
            -no-glib \
            -accessibility \
            -nomake examples \
            -nomake tests \
            -no-sql-mysql \
            -plugin-sql-sqlite \
            -plugin-sql-odbc \
            -plugin-sql-psql \
            -plugin-sql-tds -D Q_USE_SYBASE \
            -system-zlib \
            -system-libpng \
            -system-libjpeg \
            -system-sqlite \
            -fontconfig \
            -system-freetype \
            -system-harfbuzz \
            -system-pcre \
            -openssl-linked \
            -dbus-linked \
            -v

    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' install

endef


$(PKG)_BUILD_SHARED = $(subst -static ,-shared ,\
                      $($(PKG)_BUILD))
