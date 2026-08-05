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
    random_number="$(($RANDOM % 37))" 
    
    if [ ! "$money" -lt 0 ]; then
      if [ "$par_impar" == "par" ]; then
        #Todo esta definicion es para cuando apostamos por numeros pares
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
          else
            reward=$(($initial_bet * 2))
            money=$(($money + $reward))
            initial_bet=$backup_bet
            jugadas_malas="[ "
          fi
        else
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
        fi
      else
      #Toda esta definicion espara cuando apostamos por numeros impares   
        if [ "$(($random_number % 2))" -eq 1 ]; then
         reward=$(($initial_bet*2))
         money=$(($money+$reward))
         initial_bet=$backup_bet
         jugadas_malas="[ "
        else
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
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

  jugadas_totales=0
  bet_to_renew=$(($money+50)) # Dinero de renovacion de secuencia (1 2 3 4)
 
  echo -e "${yellowColour}[+]${endColour}${grayColour} El tope a renovar la secuencia esta establecido por encima de los  ${endColour}${yellowColour}$bet_to_renew${endColour}"
  
  tput civis
  while true; do
    let jugadas_totales+=1
    random_number=$(($RANDOM % 37))
    money=$(($money - $bet))
    if [ ! "$money" -lt 0 ]; then
      if [ $money -gt $bet_to_renew ]; then
        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de ${endColour}${yellowColour}$bet_to_renew${endColour}${grayColour} es tablecidos para renovar nuestras secuencia${endColour}"
        bet_to_renew=$((bet_to_renew + 50))
        echo -e "${yellowColour}[+]${endColour}${grayColour} El tope establecido en${endColour}${yellowColour} $bet_to_renew${$endColour}"
        my_sequence=(1 2 3 4)
        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))1
        echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a:${endColour}${greenColour} ${my_sequence[@]}${endColour}"
      fi
      echo -e "${yellowColour}[+]${endColour}${grayColour}Invertimos${endColour}${yellowColour} $bet${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} $money${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero ${endColour}${blueColour}$random_number${endColour}"
      
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
          echo -e "${yellowColour}[+]${endColour}${grayColour} el numero es par${endColour}"
          reward=$(($bet*2))
          let money+=$reward
          echo -e "${yellowColour}[+]${endColour}${grayColour}Tienes ${endColour}${yellowColour}$money${endColour}"

           if [ $money -gt $bet_to_renew ]; then
             echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de ${endColour}${yellowColour}$bet_to_renew${endColour}${grayColour} es tablecidos para renovar nuestras secuencia${endColour}"
             bet_to_renew=$((bet_to_renew + 50))
             echo -e "${yellowColour}[+]${endColour}${grayColour} El tope establecido en${endColour}${yellowColour} $bet_to_renew${endColour}"
             my_sequence=(1 2 3 4)
             bet=$((${my_sequence[0]} + ${my_sequence[-1]}))1
             echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
           elif [ $money -lt $(($bet_to_renew-100)) ]; then
             echo -e "${yellowColour}[+]${endColour}${grayColour} Hemos llegado a un minimo critico, se procede a reajustar el tope${endColour}"
             bet_to_renew=$(($bet_to_renew - 50))
             echo -e "${yellowColour}[+]${endColour}${grayColour} El tope ha sido renovado a ${endColour}${yellowColour}$bet_to_renew${endColour}"
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

           else
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
      

       echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}"
       echo -e "${yellowColour}[+]${endColour}${grayColour} En total han habido ${endColour}${yellowColour}$jugadas_totales${endColour}${grayColour} jugadas totales\n${endColour}"
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
