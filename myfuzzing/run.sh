sudo ../virtme/virtme-run --rw --pwd --kimg bzImage  --memory 1G --script-sh "echo core > /proc/sys/kernel/core_pattern; ./afl-fuzz -i ./inp -o ./out -- ./fuzznetlink --dmesg dmesg.txt"
