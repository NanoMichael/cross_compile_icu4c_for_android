#!/bin/bash

# CROSS BUILD ICU FOR ANDROID
# usage:
# ./build_icu.sh <NDK_DIR> <ARCH>

WORKING_DIR=`pwd`

# Build
BUILD_DIR=$WORKING_DIR/build
if [ ! -d "$BUILD_DIR" ]; then
    mkdir $BUILD_DIR
fi

########################################## Build for host #####################################

HOST_BUILD=$BUILD_DIR/host

buildHost() {
    cd $HOST_BUILD

    export ICU_SOURCES=$WORKING_DIR/icu
    export CPPFLAGS="-Os -fno-short-wchar -DU_USING_ICU_NAMESPACE=1 -fno-short-enums \
        -DU_HAVE_NL_LANGINFO_CODESET=0 -D__STDC_INT64__ -DU_TIMEZONE=0 \
        -DUCONFIG_NO_LEGACY_CONVERSION=1 \
        -ffunction-sections -fdata-sections -fvisibility=hidden"

    export LDFLAGS="-Wl,--gc-sections"

    (exec $ICU_SOURCES/source/runConfigureICU Linux --prefix=$PWD/icu_build --enable-extras=no \
        --enable-strict=no -enable-static --enable-shared=no --enable-tests=no \
        --enable-samples=no --enable-dyload=no)

    make -j16
    make install

    cd $WORKING_DIR
}

checkInclude() {
    ICU_INCLUDE=/usr/include/unicode
    if [ ! -d $ICU_INCLUDE ]; then
        echo "No icu includes found, copy..."
        cp -r $HOST_BUILD/icu_build/include/unicode /usr/include
    else
        echo "Icu includes already exists."
    fi
}

if [ -d $HOST_BUILD ]; then
    echo "Host build already exists, use this one."
else
    echo "Build for host:"
    mkdir $HOST_BUILD
    cd $HOST_BUILD
    buildHost
fi

checkInclude

###################################### Make standalone-toolchain #################################

NDK_DIR=$1
if [ ! -d $NDK_DIR ]; then
    echo "NDK not found, exit."
    exit 1
fi

ARCH=$2
if [ -z $ARCH ]; then
    echo "No arch specified, use arm."
    ARCH='arm'
fi

TOOLCHAIN=''
if [ $ARCH == 'arm' ]; then
    TOOLCHAIN='arm-linux-androideabi-4.9'
elif [ $ARCH == 'arm64' ]; then
    TOOLCHAIN='aarch64-linux-android-4.9'
else
    echo "$ARCH is not supported, exit."
    exit 1
fi

TOOLCHAIN_INSTALL_DIR=${WORKING_DIR}/${ARCH}-toolchain/
MAKE_TOOLCHAIN=${NDK_DIR}/build/tools/make-standalone-toolchain.sh

# Check if toolchain is already exists
if [ -d $TOOLCHAIN_INSTALL_DIR ]; then
    echo "Use the toolchain already exists."
else
    echo "Install toolchain into $TOOLCHAIN_INSTALL_DIR"
    (exec $MAKE_TOOLCHAIN \
        --platform=android-21 \
        --install_dir=$TOOLCHAIN_INSTALL_DIR \
        --toolchain=$TOOLCHAIN \
        --arch=$ARCH \
        --stl=gnustl)
fi


########################################## Build for Android #####################################

ANDROID_BUILD=$BUILD_DIR/android

buildAndroid() {
    ARCH_BUILD=$ANDROID_BUILD/$ARCH
    if [ -d $ARCH_BUILD ]; then
        echo "Arch '$ARCH' already builded, use this one."
        return
    fi

    mkdir $ARCH_BUILD
    cd $ARCH_BUILD

    export ICU_SOURCES=$WORKING_DIR/icu
    export ANDROIDVER=22
    export AR=/usr/bin/ar
    export ICU_CROSS_BUILD=$HOST_BUILD
    export NDK_STANDARD_ROOT=$TOOLCHAIN_INSTALL_DIR
    export CPPFLAGS="-I$NDK_STANDARD_ROOT/sysroot/usr/include/ \
        -Os -fno-short-wchar -DU_USING_ICU_NAMESPACE=1 -fno-short-enums \
        -DU_HAVE_NL_LANGINFO_CODESET=0 -D__STDC_INT64__ -DU_TIMEZONE=0 \
        -DUCONFIG_NO_LEGACY_CONVERSION=1 \
        -ffunction-sections -fdata-sections -fvisibility=hidden"

    export LDFLAGS="-lc -lstdc++ -Wl,--gc-sections,-rpath-link=$NDK_STANDARD_ROOT/sysroot/usr/lib/"

    export PATH=$PATH:$NDK_STANDARD_ROOT/bin

    (exec $ICU_SOURCES/source/configure --with-cross-build=$ICU_CROSS_BUILD \
        --enable-extras=no --enable-strict=no -enable-static --enable-shared=no \
        --enable-tests=no --enable-samples=no --enable-dyload=no \
        --host=arm-linux-androideabi --prefix=$PWD/icu_build)

    make -j16
    make install

    cd $WORKING_DIR
}

if [ ! -d $ANDROID_BUILD ]; then
    mkdir $ANDROID_BUILD
fi

buildAndroid
