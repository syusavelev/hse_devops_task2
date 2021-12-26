#!/bin/bash

# Parse named arguments using 'shift'. Here we assume the argument values are passed correctly.
while [[ "$#" -gt 0 ]]; 
do
    case $1 in
        -w|--workers_num) workers_num="$2"; shift ;;
        -c|--column_name) column_name="$2"; shift ;;
        -o|--out_dir) out_dir="$2"; shift ;;
        *) echo "Wrong parameter passed: $1"; exit 1 ;;
    esac
    shift
done

dataset='labelled_newscatcher_dataset.csv'

# Get column index by name.
column_id=$( head -n1 $dataset | tr ";" "\n" | grep -nx "$column_name" | cut -d":" -f1 ) 

# Get content of column "link" by index and remove header.
links=($(cut -d ';' -f $column_id $dataset))
links=("${links[@]:1}")

mkdir -p $out_dir
cd $out_dir

# Download content from links.
echo ${links[@]:0:10} | xargs -P "$workers_num" -n 1 curl --create-dirs -O