#! /bin/bash

curr=$(mpc -p 6601 | head -2 | tail -1 | awk '{print $3}')
timelength=$(( (${#curr} -1) / 2 ))
curr=${curr::$timelength}
currsec=${curr: -2}
currmin=${curr::-3}
if [ $currmin -eq 0 ] && [ $currsec -lt 5 ]; then
	mpc -q -p 6601 prev
else
	mpc -q -p 6601 seek 0
fi
