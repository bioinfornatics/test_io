#!/usr/bin/env bash

declare -ra fileSizeToTests=(4k 16k 1M 10M 100M 200M)

warmup(){
    local -ra cmd=($@)
    for i in {0..10}; do 
        command ${cmd[@]} &> /dev/null; 
    done
}


bench(){
    local -ra cmd=($@)
    local -ri loopUntil=10
    local tool=$(basename "${cmd[0]}")
    for fileSize in ${fileSizeToTests[@]}; do
        warmup ${cmd[@]} test_${fileSize}
        for i in $(seq 0 ${loopUntil}); do 
            ts=$(date +%s%N); ${cmd[@]} test_${fileSize} &>/dev/null; tt=$((($(date +%s%N) - $ts)/1000000))
            echo "${tt}"
        done | awk -v n=${tool} -v s=${fileSize} -v j="${loopUntil}" '
        BEGIN{i=0}
        {
            i+=$1;
        }
        END{printf "%-40s %-10s %.3f\n", n, s, i/j;}'
    done
}

main(){
    for fileSize in ${fileSizeToTests[@]}; do 
        ./build/wc_file_generator -w ${fileSize} -o test_${fileSize}
    done
    for fileSize in ${fileSizeToTests[@]}; do 
        bench wc -l 
        bench ./build/wc_File_by_line -i
        bench ./build/wc_File_by_chunks -n 1 -i
        bench ./build/wc_File_by_chunks_parallel_count -n 1 -t 4 -i
        bench ./build/wc_File_by_chunks_async_buffer -n 1 -t 4 -i
    done
}


main
