#!/bin/bash

gdate="$(date +"%d-%m@%H:%M:%S:%N")"

for file in ./data/${1}/*
do
    echo "$file:"
    tmp=$(echo "$(basename $file)" | grep -Po -m 1 "(([a-z]|[A-Z])*\d+)")
    mkdir -p ./out/output/${tmp}
    filename="${tmp}_${3}${2}_$(date +"%d-%m@%H:%M:%S:%N")"
    solfilename="${tmp}_sol.dat"

    while IFS= read -r line; do
        
        ./out/knapsack ${2} ${3} ${4} "$line" >> ./out/output/${tmp}/${filename}.out   #tasktype(d/e/c) method(0/1/2) precision knapsack

        res="$?"
        if [[ ${res} != "0" ]]; then 
            echo "ERROR: program returned ${res}"
            exit
        fi
        
    done < "$file"

    # getting some stats about generated records for further plotting
    min=`awk 'BEGIN{a=999999999999}{if ($4<0+a) a=$4} END{print a}' ./out/output/${tmp}/${filename}.out`
    max=`awk 'BEGIN{a=           0}{if ($4>0+a) a=$4} END{print a}' ./out/output/${tmp}/${filename}.out`
    ave=`awk '{ sum += $4 } END { if (NR > 0) { OFMT="%d";print sum / NR }}' ./out/output/${tmp}/${filename}.out`
    sum=`awk '{ sum += $4 } END { if (NR > 0) { OFMT="%d";print sum}}' ./out/output/${tmp}/${filename}.out`

    # plotting a distribution of an every file
    python3 plotter.py ./out/output/${tmp}/${filename}.out ${min} ${max} ${ave} ${sum}

    # saving computational errors in the .err file, if the fifth command line argument equals to "-err"
    if [[ "${5}" == "-err" ]]; then
        err=$(awk 'NR==FNR{a[$1]=$3;next}$3!=a[$1]&&a[$1]{print "ID: "$1"   ANSWER: "$3 "   GOT: "a[$1]}' ./out/output/${tmp}/${filename}.out ./data/solutions/${1}/${solfilename})
        echo "${err}" >> ./out/output/${tmp}/${filename}.err
        # printing error ratio
        err=$(wc -l < ./out/output/${tmp}/${filename}.err)
        echo "Error ratio: ${err}/$(wc -l < ./out/output/${tmp}/${filename}.out)"
    fi

    echo "$filename $min $max $ave" >> ./out/output/stats_${3}${2}${gdate}.out
    
done
