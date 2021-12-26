#!/bin/bash

while [[ "$#" -gt 0 ]]; 
do
    case $1 in
        --input) input="$2"; shift ;;
        --train_ratio) train_ratio="$2"; shift ;;
        --y_column) y_column="$2"; shift ;;
        *) echo "Wrong parameter passed: $1"; exit 1 ;;
    esac
    shift
done

input=${input:-gender_submission.csv}
train_ratio=${train_ratio:-"50"}
y_column=${y_column:-label}

lines_count=$(wc -l < $input)
border_line=$(( lines_count * train_ratio / 100 ))

sed -n "1,${border_line}p" $input > './train.csv'
head -n1 $input > './test.csv' | sed -n "$((border_line + 1)),${lines_count}p" $input >> './test.csv' 