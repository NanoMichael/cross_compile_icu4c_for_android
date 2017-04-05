export ICU_SOURCES=/home/nano/projects/icu_58/icu
export ANDROIDVER=22
export AR=/usr/bin/ar
export BASE=/home/nano/projects/icu_58
export HOST_ICU=$BASE/build_icu_android
export ICU_CROSS_BUILD=$BASE/build_icu_linux
export NDK_STANDARD_ROOT=/home/nano/android-toolchains/arm64-21
export CPPFLAGS="-I$NDK_STANDARD_ROOT/sysroot/usr/include/ \
-Os -fno-short-wchar -DU_USING_ICU_NAMESPACE=1 -fno-short-enums \
-DU_HAVE_NL_LANGINFO_CODESET=0 -D__STDC_INT64__ -DU_TIMEZONE=0 \
-DUCONFIG_NO_LEGACY_CONVERSION=1 \
-ffunction-sections -fdata-sections -fvisibility=hidden"

export LDFLAGS="-lc -lstdc++ -Wl,--gc-sections,-rpath-link=$NDK_STANDARD_ROOT/sysroot/usr/lib/"

export PATH=$PATH:$NDK_STANDARD_ROOT/bin

$ICU_SOURCES/source/configure --with-cross-build=$ICU_CROSS_BUILD \
--enable-extras=no --enable-strict=no -enable-static --enable-shared=no \
--enable-tests=no --enable-samples=no --enable-dyload=no \
--host=arm-linux-androideabi --prefix=$PWD/icu_build
make -j4
make install 
