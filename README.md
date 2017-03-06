# CROSS BUILD ICU FOR ANDROID

This document shows how to cross compile icu for Android (for me, I use it to enable Chinese segmentation in SQLite3)

The directory **icu** contains the source code of icu4c (version 58.2.0), you can download and replace it with the version you want.

The directory **icu_build_linux** is for host building, and **icu_build_android** is for Android building.

## MAKE STANDALONE ANDROID TOOLCHAIN

The script **make-standalone-android-toolchain.sh** is used to generate *standalone-toolchain*, you can type the script following on your terminate:

```shell
$ $NDK_ROOT/build/tools/make-standalone-toolchain.sh --platform=android-{PLATFORM_VERSION} \
--install-dir={INSTALL_DIR} --toolchain=arm-linux-{TARGET_ARCH}-{TOOLCHAIN_VERSION} --stl=gnustl
```

* The PLATFORM_VERSION is the Android platform you want to use, 14 is recommended
* The INSTALL_DIR specifies where to install the standalone toolchain
* The TARGET_ARCH specifies what arch you want to build
* The TOOLCHAIN_VERSION is the version of your ndk-toolchain

After the standalone-toolchain is generated, you should replace the toolchain location in script **build_icu_android.sh** to make it work properly.

# BUILD FOR HOST

Cross-buiding ICU requires to build it first for the system where the cross-build is run, then for target system.
The Linux system is recomended.

```shell
$ cd $ICU_DIR/icu_build_linux
$ sh icu_build_linux.sh
```
The **$ICU_DIR** is the root directory to place the project. You may want to change the variables and build options in the building script according to your needs.

# BUILD FOR ANDROID

```shell
$ cd $ICU_DIR/icu_build_android
$ sh icu_build_android.sh
```
Now you will find all the libs you need are on the directory **build_icu_andorid/lib**
