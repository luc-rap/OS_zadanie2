#!/bin/bash
#
# Meno: Lucia Rapanova
# Kruzok: <kruzok>
# Datum: <datum>
# Zadanie: zadanie02
#
# Text zadania:
#
# V zadanych textovych suboroch uvedenych ako argumenty najdite najdlhsi riadok
# (riadky) zo vsetkych a vypiste ho (ich). Dlzka riadku je jeho dlzka v znakoch.
# Ak nebude uvedeny ako argument ziadny subor, prehladava sa standardny vstup
# (a jeho meno je -).
#
# Syntax:
# zadanie.sh [-h] [cesta ...]
#
# Vystup ma tvar:
# Output: '<subor>: <cislo riadku v subore> <dlzka riadku> <riadok>'
#
# Priklad vystupu (parametrami boli subory nahodny ine/lorem_ipsum
# v adresari /public/testovaci_adresar/testdir2):
# Output: 'ine/lorem_ipsum: 11 98 eu ipsum. Aliquam viverra vestibulum pretium...
# Output: 'nahodny: 3 98 UtRybYIDDPudgG!YUC?NTpgo,M!vsb.wFrTQtoacxOxnQtDVDzOfnPad...
# Output: 'nahodny: 4 98 UtRybYIDDPudgG!YUC?NTpgo,M!vsb.wFrTQtoacxOxnQtDVDzOfnPad...
#
#
# Program musi osetrovat pocet a spravnost argumentov. Program musi mat help,
# ktory sa vypise pri zadani argumentu -h a ma tvar:
# Meno programu (C) meno autora
#
# Usage: <meno_programu> <arg1> <arg2> ...
#       <arg1>: xxxxxx
#       <arg2>: yyyyy
#
# Parametre uvedene v <> treba nahradit skutocnymi hodnotami.
# Ked ma skript prehladavat adresare, tak vzdy treba prehladat vsetky zadane
# adresare a vsetky ich podadresare do hlbky.
# Pri hladani maxim alebo minim treba vzdy najst maximum (minimum) vo vsetkych
# zadanych adresaroch (suboroch) spolu. Ked viacero suborov (adresarov, ...)
# splna maximum (minimum), treba vypisat vsetky.
#
# Korektny vystup programu musi ist na standardny vystup (stdout).
# Chybovy vystup programu by mal ist na chybovy vystup (stderr).
# Chybovy vystup musi mat tvar (vratane apostrofov):
# Error: 'adresar, subor, ... pri ktorom nastala chyba': popis chyby ...
# Ak program pouziva nejake pomocne vypisy, musia mat tvar:
# Debug: vypis .
#
# Poznamky: (sem vlozte pripadne poznamky k vypracovanemu zadaniu)
#
# Riesenie:

set -o noglob
pomoc="$0 - longest lines (C) Lucia Rapanova
Usage: $0 [-h] [text file]...
      [-h]: displays help
      [text file]: In given text files, find the longest line/lines.
      With no text file, or when text file is -, read standard input.
      Output: filename, line number, length of the line and line's content.

"
while :
do
  case "$1" in
    -h)
      printf "%s" "$pomoc"
      shift
      ;;
    -)
      shift
      ;;
    *)
      break
      ;;
  esac
done


if [ $# -ne 0 ]; then  
  for var in "$@"
    do
     checkText=`file -- -b "$var" 2>/dev/null | grep -c "text"`
     if [ ! -f "$var" ] || [  $checkText -eq 0 ]  ; then
        echo "Error: 'File "$var" doesn't exist or is not a text file/is empty, or you might not have permissions to read it.'" 2>/dev/stderr
        continue
     fi
	
      MAX=-1
      pocetRiadkov=0

      while read -r line || [ -n "$line" ]; do
        ((pocetRiadkov=pocetRiadkov+1))

        if [ ${#line} -gt $MAX ]
          then
            MAX=${#line}
            array=( "${line}" )
            riadkyArr=($pocetRiadkov)

        elif [ ${#line} -eq $MAX ]
          then
            array+=("${line}")
            riadkyArr+=($pocetRiadkov)
        fi

      done < "$var"

     for ((i=0; i<${#riadkyArr[@]};++i)); do
         printf "Output: '%s: %d %d %s'\n" "$var" "${riadkyArr[i]}" "$MAX" "${array[i]}"
     done

    done
fi

if [ $# -eq 0 ]; then
  MAX=-1
  pocetRiadkov=0
   while read -r vstup || [ -n "$vstup" ]; do
  
    ((pocetRiadkov=pocetRiadkov+1))

    if [ ${#vstup} -gt $MAX ] 
      then
        MAX=${#vstup}
        array=( "${vstup}" )
        riadkyArr=($pocetRiadkov)

    elif [ ${#vstup} -eq $MAX ]
      then
        array+=("${vstup}")
        riadkyArr+=($pocetRiadkov)
    fi

  done

  printf "\n"
  for ((i=0; i<${#riadkyArr[@]};++i)); do
  printf "Output: '%s: %d %d %s'\n" "-" "${riadkyArr[i]}" "$MAX" "${array[i]}"
  done

fi

