#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm; exit 1
}

#Ctrl + C

trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t)${endColour}${grayColour} Tecnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inversaLabrouchere${endColour}${purpleColour})${endColour}\n"
  exit 1
}

#---Comienzo de la funcion martingala---#


function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}$money${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Cuanto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continueamente? (par/impar) -> ${endColour}" && read par_impar

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de ${endColour}${yellowColour} $initial_bet ${endColour}${grayColour} a${endColour}${yellowColour} $par_impar${endColour}\n"
 
  backup_bet=$initial_bet
  play_counter=0
  jugadas_malas="[ "
  money_max=0
  tput civis
  while true; do
    money=$(($money-$initial_bet))
    if [ "$money" -gt "$money_max" ]; then
      money_max=$money
    fi
#    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${yellowColour} $initial_bet${endColour}${grayColour} y tienes${endColour}${yellowColour} $money ${endColour}"
    random_number="$(($RANDOM % 37))" 
#    echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero ${endColour}${blueColour}$random_number${endColour}"
    
    if [ ! "$money" -lt 0 ]; then
      if [ "$par_impar" == "par" ]; then
        #Todo esta definicion es para cuando apostamos por numeros pares
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
#           echo -e "${redColour}[+] Ha salido el 0, por tanto perdemos${endColour}"
#            echo -e "${yellowColour}[+]${endColour}${redColour} el numero que salio es impar${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
          else
#            echo -e "${yellowColour}[+]${endColour}${greenColour} el numero que ha salido es par, ganas!${endColour}"
            reward=$(($initial_bet * 2))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${yellowColour} $reward${endColour}"
            money=$(($money + $reward))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money${endColour}"
            initial_bet=$backup_bet
            jugadas_malas="[ "
          fi
        else
#          echo -e "${yellowColour}[+]${endColour}${redColour} el numero que salio es impar${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${yellowColour} $money${endColour}"
        fi
      else
      #Toda esta definicion espara cuando apostamos por numeros impares   
        if [ "$(($random_number % 2))" -eq 1 ]; then
         #echo -e "${yellowColour}[+]${endColour}${greenColour}El numero que ha salido es impar, !ganas!${endColour}"
         reward=$(($initial_bet*2))
         money=$(($money+$reward))
         initial_bet=$backup_bet
         jugadas_malas="[ "
        else
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
 #        echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${yellowColour} $money${endColour}"
        fi
      fi
    else
       echo -e "${redColour}[!] Te has quedado sin dinero${endColour}\n"
       echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de${endColour}${yellowColour} $play_counter${endColour}${grayColour} jugadas${endColour}\n"
       echo -e "${yellowColour}[+]${endColour}${grayColour} A Continuacion se van a representar las malas jugadas consecutivas que han salido:${endColour}\n"
       echo -e "${blueColour}$jugadas_malas]${endColour}\n"
       echo -e "${greenColour}Maximo dinero conseguido: $money_max$ ${endColour}"
       tput cnorm; exit 0
    fi

    let play_counter+=1
  done

  tput cnorm
}


#---Fin de la funcion martingala---#


#---Comiezo de la funcion inverseLabrouchere

function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}$money${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continueamente? (par/impar) -> ${endColour}" && read par_impar
  
  declare -a my_sequence=(1 2 3 4)

  echo -e "${yellowColour}[+]${endColour}${grayColour} Comenzar con la secuencia ${endColour}${greenColour}[${my_sequence[@]}]${endColour}\n"
 
  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

  #echo -e "${yellowColour}[+]${endColour}${grayColour}Invertimos${endColour}${yellowColour} $bet${endColour}\n"
  #echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} $money${endColour}"


  tput civis
  while true; do
    random_number=$(($RANDOM % 37))
    money=$(($money - $bet))
    if [ ! "$money" -lt 0 ]; then
      echo -e "${yellowColour}[+]${endColour}${grayColour}Invertimos${endColour}${yellowColour} $bet${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} $money${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero ${endColour}${blueColour}$random_number${endColour}"
      
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
          echo -e "${yellowColour}[+]${endColour}${grayColour} el numero es par${endColour}"
          reward=$(($bet*2))
          let money+=$reward
          echo -e "${yellowColour}[+]${endColour}${grayColour}Tienes ${endColour}${yellowColour}$money${endColour}"

          my_sequence+=($bet)
          my_sequence=(${my_sequence[@]})
   
          echo -e "${yellowColour}[+]${endColour}${grayColour}Nuestra nueva secuencia es ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then 
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi
        elif [ "$((random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ]; then
          if [ "$((random_number % 2))" -eq 1 ]; then
            echo -e "${redColour}[!] el numero es impar ${endColour}"
          else
            echo -e "${redColour}[!] Ha salido el numero 0 ${endColour}"
          fi
          unset my_sequence[0]
          unset my_sequence[-1] 2>/dev/null

          my_sequence=(${my_sequence[@]})
          echo -e "${yellowColour}[+]${endColour}${grayColour}La secuencia nos queda de la siguente forma:${endColour}${greenColour}[${my_sequence[@]}]${endColour}"

          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then 
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi
        fi
      fi
     else
       

       echo -e "${redColour}[!] Te has quedado sin dinero${endColour}\n"
      # echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de${endColour}${yellowColour} $play_counter${endColour}${grayColour} jugadas${endColour}\n"
      tput cnorm; exit 1
     fi
    #sleep 1
  done
  tput cnorm

}

#---Final de la funcion inverseLabrouchere

while getopts "m:t:h" arg; do
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac

done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La tecnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
