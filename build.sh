#!/bin/bash

# rm -rf ./out/build/

BOLD=`tput bold`

cmake -S . -B ./out/build/
CMAKE=$?

if [[ ${CMAKE} != 0 ]]; then
    echo "${BOLD}ERROR:  cmake"
    exit 1
fi

make -C ./out/build/
MAKE=$?

if [[ ${MAKE} != 0 ]]; then 
    echo "${BOLD}ERROR:  make"
    exit 2
fi

mv ./out/build/knapsack ./out/

echo "${BOLD}SUCCESS"