Arm GNU Toolchain build scripts
===============================

There's many gcc toolchains for ARM, but the one enshrined by the ARM developer website and supported by everyone is the [Arm GNU Toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) hosted on their website.

This toolchain is built with specific options, with support for newlib-nano, and a few other tidbits, making it work on projects where sometimes other toolchains (like those provided by linux distributions) have trouble. This is especially true on embedded platforms where slight differences in the options the compiler was built with can cause trouble.

However, it's only provided as a binary. If you try to build it from source code, you'll find that the requirements are a bit unorthodox and it's unclear how to build the entire thing offline, making it hard to package.

This set of scripts aims to provide an example of how to repeatably build the toolchain on various systems, with as few modifications as possible. The downloads are scripted and decoupled from `git` as much as possible, by using the provided source tarball from the [downloads website](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads), and a few unnecessary build dependencies are removed.

Usage
-----

```
# Download all the source code into the abe/ and src/ directories
./fetch.sh
# Unpack and prepare the sources for consumption by ABE into the snapshots/ directory
./unpack.sh
# Build the arm-none-eabi and aarch64-none-elf toolchains
./build.sh
# Strip the output
./strip.sh "build/builds/destdir/$(./abe/config.guess)"
ARCH=aarch64-none-elf ./strip.sh "build_aarch64/builds/destdir/$(./abe/config.guess)"
# Package up the output
tar cvJf arm-none-eabi.tar.xz -C "build/builds/destdir/$(./abe/config.guess)" .
tar cvJf aarch64-none-elf.tar.xz -C "build_aarch64/builds/destdir/$(./abe/config.guess)" .
```
