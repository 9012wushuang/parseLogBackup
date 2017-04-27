
#!/bin/sh

common_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  
dir1=10.251.147.60
dir2=10.251.147.62

echo "输入自定义文件名"
read filename
echo "输入要统计的uri"
read uri

echo "uri is $uri"
echo "file name is $filename"


echo "select is conitinue

	1 continue
	2 quit
"

read -p "Enter selection [1-2] > "

if [[ $REPLY =~ ^[1-2] ]];then
	 if [[ $REPLY == 2 ]];then
		 echo "Program terminated."
       		 exit
	 fi
else
    echo "Invalid entry." >&2
    exit 1
fi



all=$filename

cd $common_path/$dir1



for k in $( seq 1 9 )
do
	cat webcall.log.2017-04-0${k} |  grep $uri | grep 'http.*'  >> $common_path/$all
done

for k in $( seq 10 21 )
do
	cat webcall.log.2017-04-${k} |  grep $uri | grep 'http.*'  >> $common_path/$all
done

echo "======================================into step next folder========================"
cd $common_path/$dir2
 
for k in $( seq 1 9 )
do
	cat webcall.log.2017-04-0${k} |  grep $uri | grep 'http.*'  >> $common_path/$all
done

for k in $( seq 10 21 )
do
	cat webcall.log.2017-04-${k} |  grep $uri | grep 'http.*'  >> $common_path/$all
done

cat $common_path/$all | wc -l
