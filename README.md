# CROSS BUILD ICU FOR ANDROID

This document shows how to cross compile icu for Android (I use it to enable Chinese segmentation in SQLite3).

The directory **icu** contains the source code of icu4c (version 58.2.0), you can replace it with the version you want.

The directory **build** is the build result, **build/host** is the host build result, and **build/android/*arch*** is the target build result for Android, *arch* is the target arch you want to build.

# HOW TO USE

Just run the following commands:

```sh
$ chmod +x build_icu.sh
$ ./build_icu.sh <NDK_DIR> <TARGET_ARCH>
```

**NDK_DIR** is your NDK toolchain directory, and **TARGET_ARCH** is the target arch you want to build, current support *arm* and *arm64*.

You can find the libs builded in directory **build/andorid/arch/lib**.

# LICENSE

This project is under the [Apache-2.0](http://www.apache.org/licenses/LICENSE-2.0)

```
Copyright 2018 Nano Michael

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
