#!/bin/bash
clear
yacc -d labs.y 
#lex debugger.l
lex labs.l
gcc lex.yy.c y.tab.c -o labs

./labs entrada.txt > salida.txt
./labs entrada2.txt > salida2.txt
./labs entrada3.txt > salida3.txt

echo "Ejecucion terminada"
