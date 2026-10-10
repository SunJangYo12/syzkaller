# peta alamat -> fungsi, dari symbols.txt (tiap PC = 3 baris: alamat, fungsi, file:baris)
#paste - - - < output/symbols.txt | awk -F'\t' '{print tolower($1) "\t" $2 "\t" $3}' > output/map.tsv

total=$(wc -l < output/sigs.txt)
sisa=$total

while read sig; do

  echo "[+] [$sisa/$total] $sig"

  awk -F'\t' 'NR==FNR{f[$1]=$2; l[$1]=$3; next}
            {a=tolower($1)} (a in f){print a "\t" f[a] "\t" l[a]}' \
    output/symbols.txt percov/$sig.pcs > percov/$sig.res

  rm percov/$sig.pcs

  sisa=$((sisa - 1))

done < output/sigs.txt
