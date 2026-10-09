#VMLINUX="/run/user/1000/gvfs/sftp:host=192.168.0.101,port=8022/sdcard/syzz/linux-6-oem/vmlinux"
VMLINUX="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/Desktop/bak/linux-6/vmlinux"

OUT=output


touch "$OUT/symbols.txt"

# Ambil alamat yang sudah pernah diproses
grep '^0x' "$OUT/symbols.txt" > "$OUT/processed.txt"

# Ambil hanya alamat baru
grep -Fvx -f "$OUT/processed.txt" "$OUT/pcs.txt" > "$OUT/new-pcs.txt"

if [ -s "$OUT/new-pcs.txt" ]; then
    #addr2line -a -f -C -e "$VMLINUX" < "$OUT/new-pcs.txt" >> "$OUT/symbols.txt"

	addr2line -a -f -C -e "$VMLINUX" < "$OUT/new-pcs.txt" |
	sed 's|.*/test-ci/||' >> "$OUT/symbols.txt"

fi

grep -E '(^|/)[^ ]+\.(c|h):[0-9]+' "$OUT/symbols.txt" | sed -E 's/(:[0-9]+).*/\1/' > "$OUT/cov.txt"
