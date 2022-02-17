#!/bin/zsh
nasm -o mbr.bin mbr.S
dd if=mbr.bin of=disk.img bs=512 count=1 conv=notrunc
bochs