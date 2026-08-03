#!/bin/bash


declare -a myArray=(1 2 3 4)

number=1

#echo ${myArray[@]}


#declare -i posicion=0

#for element in ${myArray[@]}; do
#  echo "[+] Elemento en la posicion [$posicion]: $element"
#  let posicion+=1
#done
myArray+=(5)
#echo ${#myArray[@]}

echo ${myArray[@]}

unset myArray[-1]

echo ${myArray[@]}
