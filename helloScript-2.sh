#! /bin/bash

age=30

if [ "$age" -lt 18 ] || [ "$age" -gt 28 ]
then
    echo "Age is correct"
else
    echo "Age is not correct"
fi