#!/usr/bin/env bash
echo "Downloading few Dependecies . . ."
git clone --depth=1 https://github.com/cbendot/elastics-toolchain llvm
git clone --depth=1 https://github.com/cbendot/kernel_asus_sdm660 hard

# Main
KERNEL_ROOTDIR=$(pwd)/hard # IMPORTANT ! Fill with your kernel source root directory.
DEVICE_DEFCONFIG=elastics_defconfig # IMPORTANT ! Declare your kernel source defconfig file here.
CLANG_ROOTDIR=$(pwd)/llvm # IMPORTANT! Put your clang directory here.
export KBUILD_BUILD_USER=ben863 # Change with your own name or else.
export KBUILD_BUILD_HOST=Elastics-DroneCI # Change with your own hostname.
IMAGE=$(pwd)/asus/out/arch/arm64/boot/Image.gz-dtb
DATE=$(date +"%F-%S")
START=$(date +"%s")

# Checking environtment
# Warning !! Dont Change anything there without known reason.
function check() {
echo ================================================
echo Suit-Suit... He-He...
echo version : rev1.5 - gaspoll
echo ================================================
echo BUILDER NAME = ${KBUILD_BUILD_USER}
echo BUILDER HOSTNAME = ${KBUILD_BUILD_HOST}
echo DEVICE_DEFCONFIG = ${DEVICE_DEFCONFIG}
echo CLANG_VERSION = $(${CLANG_ROOTDIR}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')
echo CLANG_ROOTDIR = ${CLANG_ROOTDIR}
echo KERNEL_ROOTDIR = ${KERNEL_ROOTDIR}
echo ================================================
}

# Compiler
function compile() {

   # Private CI
   curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" \
        -d chat_id="${chat_id}" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="<b>🔨Suit-Suit... He-He... Building Kernel</b>%0ABuilder Name : <code>${KBUILD_BUILD_USER}</code>%0ABuilder Host : <code>${KBUILD_BUILD_HOST}</code>%0ADevice Defconfig: <code>${DEVICE_DEFCONFIG}</code>%0AClang Version : <code>$(${CLANG_ROOTDIR}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</code>%0AClang Rootdir : <code>${CLANG_ROOTDIR}</code>%0AKernel Rootdir : <code>${KERNEL_ROOTDIR}</code>%0A1:00 ●━━━━━━─────── 2:00 ⇆ㅤㅤㅤ ㅤ◁ㅤㅤ❚❚ㅤㅤ▷ㅤㅤㅤㅤ↻"  

  cd ${KERNEL_ROOTDIR}
  make -j$(nproc) O=out ARCH=arm64 ${DEVICE_DEFCONFIG}
  make -j$(nproc) ARCH=arm64 O=out \
	CC=${CLANG_ROOTDIR}/bin/clang \
	CROSS_COMPILE=${CLANG_ROOTDIR}/bin/aarch64-linux-gnu- \
	CROSS_COMPILE_ARM32=${CLANG_ROOTDIR}/bin/arm-linux-gnueabi-

   if ! [ -a "$IMAGE" ]; then
	finerr
	exit 1
   fi
        git clone --depth=1 https://github.com/cbendot/AnyKernel3 AnyKernel
	cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
}

# sticker plox
function sticker() {
    curl -s -X POST "https://api.telegram.org/bot${token}/sendSticker" \
        -d sticker="CAACAgUAAxkBAAEChmlg4DSByYxzV0PI4C8w6OhTeqMEpwACpgIAApk4AAFXSahPNJ_y_k0gBA" \
        -d chat_id="${chat_id}"
}

# Push kernel to channel
function push() {
    cd AnyKernel
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot${token}/sendDocument" \
        -F chat_id="${chat_id}" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="✅ Compile successfully completed $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s). | For <b>Zenfone Max Pro M1 (X00TD)</b> | <b>$(${CLANG_ROOTDIR}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</b>"
}

# Fin Error
function finerr() {
    curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" \
        -d chat_id="${chat_id}" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="❌ Build throw an error(s)"

    exit 1
}

# Zipping
function zipping() {
    cd AnyKernel || exit 1
    zip -r9 ElasticsPerf-HMP-${DATE}.zip *
    cd ..
}
check
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
push
