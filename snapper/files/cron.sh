#!/bin/sh

#
# paranoia settings
#
umask 022
PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PATH


#
# get information from /etc/default/snapper
#
if [ -f /etc/default/snapper ] ; then
    . /etc/default/snapper
fi


#
# run snapper for all configs
#
for CONFIG in $SNAPPER_CONFIGS ; do

    TIMELINE_CREATE="no"

    . /etc/snapper/configs/$CONFIG

    if [ "$TIMELINE_CREATE" = "yes" ] ; then
        snapper --config=$CONFIG --quiet create --description="timeline" --cleanup-algorithm="timeline"
    fi

done

exit 0
