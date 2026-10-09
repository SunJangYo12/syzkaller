HOST=192.168.0.101:56741
#VMLINUX="/run/user/1000/gvfs/sftp:host=192.168.0.101,port=8022/sdcard/syzz/linux-6-oem/vmlinux"
VMLINUX="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/Desktop/bak/linux-6/vmlinux"

curl -s http://$HOST/corpus | grep -o 'input?sig=[0-9a-f]*' | cut -d= -f2 | sort -u > output/sigs.txt

mkdir -p percov

while read sig; do
  curl -s "http://$HOST/rawcover?input=$sig" > percov/$sig.pcs
  COV=`cat percov/$sig.pcs | wc -l`

  echo "[+] COV=$COV $sig"

  continue

  addr2line -f -e $VMLINUX < percov/$sig.pcs > percov/$sig.sym 2>/dev/null
  if grep -qx tcp_v6_rcv percov/$sig.sym && ! grep -qx tcp_v6_do_rcv percov/$sig.sym; then
    echo $sig
  fi
done < output/sigs.txt
