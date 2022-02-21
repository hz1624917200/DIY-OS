#!/bin/bash
cd $(dirname "$0")

if [ -r $1 ]; then
    nasm -f elf32 $1
    ld -m elf_i386 $(echo $1 | cut -d '.' -f 1)".o" -o $(echo $1 | cut -d '.' -f 1)".out"
    /bin/rm $(echo $1 | cut -d '.' -f 1)".o"
fi