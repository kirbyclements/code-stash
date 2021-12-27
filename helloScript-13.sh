#! /bin/bash

echo "Enter hex number of your choice"
read Hex

echo -n "the decimal value of $Hex is : "

echo "obase=10; ibase=16; $Hex;" | bc