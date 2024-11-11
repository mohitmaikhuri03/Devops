#!/bin/bash
action=$1
num=$2

        #1 case 
case $action in
t1)
for((i=1 ; i<=$num ;i++));
do
for((j=i ; j<$num ; j++));
do
echo -n " "
done
for((k=1 ; k<=i ; k++));
do
echo -n "* "
done
echo
done
;;
t2)    #2case 
for ((i=1 ; i<=$num ; i++));
do
for ((j=1 ; j<=i ; j++ ));
do
echo -n "*"
done
echo
done
;;
t3)   #3case
for((i=1 ; i<=$num ;i++));
do
for((j=1 ; j<=$num-i ; j++));
do
echo -n " "
done
for((k=1 ; k<=2*i-1 ; k++));
do
echo -n "*"
done
echo
done
;;
t4)     #4case
for ((i=1 ; i<=$num ; i++));
do
for ((j=$num ; j>=i ; j-- ));
do
echo -n "*"
done
echo
done
;;
t5)           #5case
for((i=$num ; i>=1 ;i--));
do
for((j=1 ; j<=$num-i ; j++));
do
echo -n " "
done
for((k=1 ; k<=i ; k++));
do
echo -n "* "
done
echo
done
;;
t6)        #6case
for((i=$num ; i>=1 ;i--));
do
for((j=1 ; j<=$num-i ; j++));
do
echo -n " "
done
for((k=1 ; k<=2*i-1 ; k++));
do
echo -n "*"
done
echo
done
;;
t7)          #7case
for((i=1 ; i<=$num ;i++));
do
for((j=1 ; j<=$num-i ; j++));
do
echo -n " "
done
for((k=1 ; k<=2*i-1 ; k++));
do
echo -n "*"
done
echo
done
for((i=num-1 ; i>=1 ;i--));
do
for((j=1 ; j<=$num-i ; j++));
do
echo -n " "
done
for((k=1 ; k<=2*i-1 ; k++));
do
echo -n "*"
done
echo
done
;;
esac
