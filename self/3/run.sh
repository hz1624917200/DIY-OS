#!/bin/zsh
nasm -o mbr.bin mbr-gpu.S
nasm -o loader.bin loader.S
dd if=mbr.bin of=disk.img bs=512 count=1 conv=notrunc
dd if=loader.bin of=disk.img bs=513 count=1 seek=1 conv=notrunc
bochs -q
