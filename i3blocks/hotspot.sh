#! /bin/bash
hotspotname=$(cat $MEAD_PATH/.auxfiles/hotspotname)
if [ ${#hotspotname} -gt 1 ]; then
	echo " $hotspotname  |"
fi
