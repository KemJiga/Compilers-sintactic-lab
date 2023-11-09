#!/bin/bash
clear
yacc -d labs.y
lex labs.l
gcc lex.yy.c y.tab.c -o labs

./labs entrada.txt > ./out/salida.txt
./labs entrada2.txt > ./out/salida2.txt

echo "Ejecucion terminada"