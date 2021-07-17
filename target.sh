#!/bin/bash

# Copyright (C) 2021 a xyzprjkt property

# Main
KERNEL_ROOTDIR=/home/r_budhiono/test/asus # IMPORTANT ! Fill with your kernel source root directory.
DEVICE_DEFCONFIG=ElasticsPerf # IMPORTANT ! Declare your kernel source defconfig file here.
CLANG_ROOTDIR=/home/r_budhiono/test/clang # IMPORTANT! Put your clang directory here.
export KBUILD_BUILD_USER=ben863 # Change with your own name or else.
export KBUILD_BUILD_HOST=CloudShell # Change with your own hostname.
