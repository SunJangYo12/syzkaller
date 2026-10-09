FUNC="$@"


while read sig; do

  cut -f2 percov/$sig.res > /tmp/$sig.funcs

  #if grep -qx tcp_v6_rcv percov/$sig.funcs && ! grep -qx tcp_v6_do_rcv percov/$sig.funcs; then
  if grep -qx $FUNC /tmp/$sig.funcs; then
    COV=`cat /tmp/$sig.funcs | wc -l`
    echo "COV: $COV KANDIDAT: $sig"
  fi

  rm /tmp/$sig.funcs

done < output/sigs.txt
