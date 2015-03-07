#!/bin/bash

# add the following to your crontab:
# */10 * * * * cd <path_to_evaluator_home_that_is_the_location_of_eval.py> && bash eval-keep-alive.sh

function start_eval {
    echo $(date): "(Re)starting evaluator" >> keep-alive.log
    rm -f .evaluator-lock
    sleep 180 # sleep 3 minutes to let the children exit gracefully if they exist
    python eval.py -c eval.conf &
}

EVALPID=$(cut -d '@' -f 1 .evaluator-lock 2>/dev/null)

if [ -z "${EVALPID}" ]; then
    start_eval
else
    INSTANCES=$(ps --pid ${EVALPID} h | wc -l)
    if [ $INSTANCES -eq 0 ]; then
        start_eval
    fi
fi


