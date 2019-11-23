#! /bin/bash

apptolaunch=$@

$apptolaunch &
pid="$!"

winid=""
while : ; do
	winid="`wmctrl -lp | awk -vpid=$pid '$3==pid {print $1; exit}'`"
	[[ -z "${winid}" ]] || break
done

wmctrl -ia "${winid}"

i3-msg floating enable > /dev/null
#i3-msg border 1pixel > /dev/null
i3-msg resize set 600px 400px > /dev/null
i3-msg move position 1304px 45px > /dev/null
i3-msg sticky enable > /dev/null
