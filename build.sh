 #!/bin/bash

export KERNELNAME=HMP-Perfomance

export KBUILD_BUILD_USER=ben863

export KBUILD_BUILD_HOST=LiteSpeed

export TOOLCHAIN=gcc

export DEVICES=X00T

source helper

gen_toolchain

send_msg "⏳ Suit-Suit... He-He | Building Kernel ${KERNELNAME}"

START=$(date +"%s")

for i in ${DEVICES//,/ }
do

	build ${i} -nlv
	
done

END=$(date +"%s")

DIFF=$(( END - START ))

send_msg "Build Selesai | $((DIFF / 60))Menit $((DIFF % 60))Detik | Pembaruan: $(git log --pretty=format:'%h : %s' -5)"
