sudo python3 virtme/virtme-run --rw --pwd --kimg bzImage  --memory 1G --script-sh "echo core > /proc/sys/kernel/core_pattern; ./afl-fuzz -V 5 -i ./inp -o ./out -- ./fuzznetlink --dmesg dmesg.txt"
