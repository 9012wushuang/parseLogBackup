
#!/bin/sh

common_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  
dir1=10.251.147.60
dir2=10.251.147.62
super=super.log
result=result.log
time=time.log
time_analysis=time_analysis.log
all=all.log


cd $common_path/$dir1

log_file="$common_path/$super"
result_file="$common_path/$result"

echo "create or clear $log_file"
echo "" > $log_file 

echo "get all slow 1000ms request into  $log_file"
for k in $( seq 1 9 )
do
	cat webcall.log.2017-04-0${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 | cut -d '耗' -f 1 >> $log_file
    	cat webcall.log.2017-04-0${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 -f 2 >> $common_path/$time
	cat webcall.log.2017-04-0${k} |  grep '耗时：\d\{4,\}' | grep 'http.*'  >> $common_path/$all
done

for k in $( seq 10 21 )
do
        cat webcall.log.2017-04-${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 | cut -d '耗' -f 1 >> $log_file
	cat webcall.log.2017-04-${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 -f 2 >> $common_path/$time
	cat webcall.log.2017-04-${k} |  grep '耗时：\d\{4,\}' | grep 'http.*'  >> $common_path/$all
done

echo "======================================into step next folder========================"
cd $common_path/$dir2
 
echo "get all slow 1000ms request into  $log_file"
for k in $( seq 1 9 )
do
        cat webcall.log.2017-04-0${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 | cut -d '耗' -f 1 >> $log_file
	cat webcall.log.2017-04-0${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 -f 2 >> $common_path/$time
	cat webcall.log.2017-04-0${k} |  grep '耗时：\d\{4,\}' | grep 'http.*'  >> $common_path/$all
done

for k in $( seq 10 21 )
do
        cat webcall.log.2017-04-${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 | cut -d '耗' -f 1 >> $log_file
	cat webcall.log.2017-04-${k} |  grep '耗时：\d\{4,\}' | grep -o  'http.*' | cut -d '?' -f 1 -f 2 >> $common_path/$time
	cat webcall.log.2017-04-${k} |  grep '耗时：\d\{4,\}' | grep 'http.*'  >> $common_path/$all
done

echo "into no fast request done, analysis result  "
echo "" > $result_file
echo "" > $common_path/$time_analysis
echo "" > $common_path/final.log

echo "clear  $result_file done，write last step result into  $result_file"
cat $common_path/$super | sort|uniq -c |sort -n -k 1  -r >> $result_file
cat $common_path/$super | sort|uniq >> $common_path/$time_analysis

echo "write $result_file done" 
cat $result_file

sed '/^ *$/d' $common_path/$time_analysis | while read line
do
	echo "${line}"
	avg_val=""
	avg_val=`cat $common_path/${time} | grep ${line} | cut -d '：' -f 2 |awk '{sum+=$1} END {print sum/NR}' `
	echo "$avg_val"
	click_count=`grep ${line} $result_file | cut -d 'h' -f 1`
	echo "$avg_val ${line} ${click_count}" >> $common_path/final.log
done
cat $common_path/final.log | cut -d  " " -f1 -f2 |sort -n -r
