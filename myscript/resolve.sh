VMLINUX="/run/user/1000/gvfs/sftp:host=192.168.0.101,port=8022/sdcard/syzz/linux-6-oem/vmlinux"
#VMLINUX="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/Desktop/bak/linux-6/vmlinux"

OUT=output

touch "$OUT/symbols.txt"

# Ambil alamat yang sudah pernah diproses (kolom 1)
cut -f1 "$OUT/symbols.txt" | grep '^0x' > "$OUT/processed.txt"

# Ambil hanya alamat baru
grep -Fvx -f "$OUT/processed.txt" "$OUT/pcs.txt" > "$OUT/new-pcs.txt"

echo "[+] Process: "
cat $OUT/new-pcs.txt

if [ -s "$OUT/new-pcs.txt" ]; then
    # addr2line keluar 3 baris per alamat -> gabung jadi 1 baris: addr<TAB>func<TAB>file:line
    addr2line -a -f -C -e "$VMLINUX" < "$OUT/new-pcs.txt" |
    sed 's|.*/test-ci/||' |
    paste - - - >> "$OUT/symbols.txt"
fi

# cov.txt: ambil kolom 3 (file:line), buang suffix setelah nomor baris
cut -f3 "$OUT/symbols.txt" |
grep -E '(^|/)[^ ]+\.(c|h):[0-9]+' |
sed -E 's/(:[0-9]+).*/\1/' > "$OUT/cov.txt"
