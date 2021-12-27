#! /bin/bash

# put stdout in file1 and stderr in file2
#ls -la 1>file1.txt 2>file2.txt

# put both stdout and stderror in same fiile
#ls +la >file1.txt 2>&1

# also puts both in one file
ls -la >& file1.txt