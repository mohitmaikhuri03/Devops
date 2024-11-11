#!/bin/bash


INPUT_FILE=""
first="" 
subject="" 

for arg in "$@"; do
    case "$arg" in
        fname=*) first="${arg#*=}" ;; 
        topic=*) subject="${arg#*=}" ;; 
        *) INPUT_FILE="$arg" ;;
    esac
done

sed -e "s/fname/${first}/g" -e "s/topic/${subject}/g" "$INPUT_FILE"
