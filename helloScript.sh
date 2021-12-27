#! /bin/bash

number=-5
until [ $number -ge 20 ]
do
    echo $number
    number=$(( number+1 ))
    done