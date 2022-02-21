#!/bin/zsh
# bximage -mode=create -hd=10M -q -imgmode="flat" disk.img
nasm -o mbr.bin mbr.S
nasm -o loader.bin loader.S
dd if=mbr.bin of=disk.img bs=512 count=1 conv=notrunc
dd if=loader.bin of=disk.img bs=512 count=4 seek=1 conv=notrunc
bochs -q
