#!/bin/bash

set -x


action=$1

case $action in
        topProcess)
                if [ $3 == memory ]; then
			ps aux --sort -%mem | head -n $(( $2+1 ))
        elif [ $3 == cpu ]; then
		ps aux --sort -%cpu | head -$(( $2+1 ))
        else
                echo "please check correct argument: use memory or CPU "
                fi
                ;;

        killLeastPriorityProcess)
		#process=$(ps aux  --sort=ni | tail -n 1 | awk '{print $1}')
                process=$(ps -eo pid,ni --sort=ni | tail -n 1 | awk '{print $1}')
                        read -p "Are you sure you want to kill process with PID $process? (y/n): " answer
                if [ "$answer" == "y" ]; then
                        sudo kill -9 $process
                        echo "Least priority process with PID $pid has been killed."
                else
                        echo "Kill process cancelled!!!"
                fi
                ;;
	RunningDurationProcess)
	   	 process="$2"
    		if [[ "$2" =~ [^0-9] ]]; then
		    duration=$(ps -C "$process" -o etime=)
        		if [[ -n "$duration" ]]; then
         	   		echo "Process with name $process has been running for: $duration."
        		else
            			echo "Process $process not found or is not running."
        		fi
    		else
        		duration=$(ps -p "$process" -o etime=)
        
        		if [[ -n "$duration" ]]; then
            			echo "Process with PID $process has been running for: $duration."
        		else
            			echo "Process with PID $process not found or is not running."
        		fi
    		fi
    		;;
   	 listOrphanProcess)
		 ps --ppid 1 -o pid,ppid,comm | awk '$2 == 1'
		;;

        listZoombieProcess)
                zoombie=$(ps -eo pid,ppid,stat,comm | awk '$3 ~ /^Z/')
		if [[ -n $zoombie ]]; then
			echo $zoombie
		else
			echo "zoombie process not found"
		fi
		;;
	killProcess)
		pid="$2"
		if [[ "$2" =~ [^0-9] ]];then
			read -p "are you sure you want to kill process $pid? (y/n):" answer
			if [[ "$answer" == "y" ]]; then
				if pkill -9 "$pid" 2>/dev/null; then
					echo "process $pid has been killed"
				else
					echo "process $pid could not be killed or dose not exist"
				fi
			else
				echo "kill process cancelled"
			fi
		elif [ -n "$pid" ]; then
			read -p "are you sure you want to kill process $pid? (y/n):" answer
			if [[ "$answer" == "y" ]]; then
				if kill -9 "$pid" 2>/dev/null; then
					echo "process $pid has been killed"
				else
					echo "process $pid could not be killed or dose not exist"
				fi
			else
				echo "kill process cancelled"
			fi
		fi
		;;
	ListWaitingProcess)
		orphan=$(ps -eo pid,ppid,stat,comm | awk '$3 ~ /^D/')
		if [[ -n "$orphan" ]]; then
			echo "$orphan"
		else
			echo "Waiting process not found"
		fi
		;;
	*)
		echo "invalid action"

esac
