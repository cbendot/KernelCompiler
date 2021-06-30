 #!/bin/bash

export KERNELNAME=HMP-Perfomance

export KBUILD_BUILD_USER=ben863

export KBUILD_BUILD_HOST=LiteSpeed

export TOOLCHAIN=clang

export DEVICES=X00TD

source helper

kernel_source

gen_toolchain

send_msg "⏳ Suit-Suit... He-He | Building Kernel ${KERNELNAME} | $DATE"

START=$(date +"%s")

for i in ${DEVICES//,/ }
do

	build ${i} -perf
	
done

END=$(date +"%s")

DIFF=$(( END - START ))

send_msg "Build Selesai | $((DIFF / 60))Menit $((DIFF % 60))Detik | Pembaruan: $(git log --pretty=format:'%h : %s' -5)"
