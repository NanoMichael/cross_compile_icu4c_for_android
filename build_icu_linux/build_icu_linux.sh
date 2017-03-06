export ICU_SOURCES=/home/nano/icu_58/icu
export CPPFLAGS="-O3 -fno-short-wchar -DU_USING_ICU_NAMESPACE=1 -fno-short-enums \
-DU_HAVE_NL_LANGINFO_CODESET=0 -D__STDC_INT64__ -DU_TIMEZONE=0 \
-DUCONFIG_NO_LEGACY_CONVERSION=1"

sh $ICU_SOURCES/source/runConfigureICU Linux --prefix=$PWD/icu_build --enable-extras=no \
--enable-strict=no -enable-static --enable-shared=no --enable-tests=no \
--enable-samples=no --enable-dyload=no
make -j4
make install
