# Cross build icu4c for Android

This document shows how to cross-compile icu4c for Android (I use it to perform `multi-language words segmentation` in SQLite3), please read [the documentation](http://site.icu-project.org/home) to get more details about `icu`.

The directory **icu** contains the source code of icu4c (version 58.2.0), you can replace it with the version you want.

The directory **build** contains the build results, **build/host** is for host building, and **build/android/*[arch]*** contains the target build results for Android, *[arch]* is the target abi-architecture you want to build.

Currently only support linux* and darwin* OS.

# How to use

Just run the following commands:

```sh
$ chmod +x build_icu
$ ./build_icu <TARGET_ARCH>
```

**TARGET_ARCH** is the target abi-architecture you want to build, you can specify it with `arm` that corresponding to `armabi-v7a` or `arm64` that corresponding to `arm64-v8a`, the default is `arm`.

After all works done, you can find the libraries in the directory **build/andorid/[arch]/lib**.

Run `./build_icu -h` or `./build_icu --help` to show usages, and run `./build_icu -c` or `./build_icu --clean` to clear all build files.

# License

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
