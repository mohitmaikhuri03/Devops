#!/bin/bash

action=$1
file=$2

if [ ${action} == "addLineTop" ]; then
  
    line=$3
    sed -i "1 i ${line}" ${file}

elif [ ${action} == "addLineBottom" ]; then

    line=$3
    sed -i "$ a\\${line}" ${file}

elif [ ${action} == "addLineAt" ]; then

    linenumber=$3
    line=$4
    sed -i "$linenumber} a ${line}" ${file}

elif [ ${action} == "updateFirstword" ]; then

    word1=$3
    word2=$4
    sed -i "0,/${word1}/s//${word2}/" ${file}

elif [ ${action} == "updateAllwords" ]; then

    word1=$3
    word2=$4
    sed -i "s/${word1}/${word2}/" ${file}

elif [ ${action} == "insertword" ]; then

    word1=$3
    word2=$4
    word_to_insert=$5
    sed -i "s/\(${word1}\) \(${word2}\)/\1 ${word_to_insert} \2/" ${file}
   

elif [ ${action} == "deleteLine" ]; then

linenumber=$3
    
        if [ "$#" -eq 3 ]; then

            sed -i "$linenumber}d" ${file}

        elif [ "$#" -eq 4 ]; then

            word=$4
            sed -i "$linenumber}{/${word}/d;}" ${file}

        fi


fi

