USER=`whoami`
echo "setting $USER as firebird member"
gksu -u root "usermod -a -G firebird $USER"
