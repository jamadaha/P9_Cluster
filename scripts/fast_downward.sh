#!/bin/bash

ulimit -v 8192000 ## 8 GB

echo "name=FD"

DOMAIN="$1"
PROBLEM="$2"

INFO_OUT="info"
CMD_OUT="cmd_out"

CMD="fast-downward.py --alias lama-first ${DOMAIN} ${PROBLEM}"
CMD="timeout 30m /usr/bin/time -f \"%e,%M\" ${CMD} >> ${CMD_OUT}"

echo "${CMD}"

$(eval ${CMD} 2>${INFO_OUT})

INFO=$(<${INFO_OUT})
INFO_SPLIT=(${INFO//,/ })
TOTAL_TIME=${INFO_SPLIT[0]}
MEMORY_USAGE=${INFO_SPLIT[1]}

echo "total_time=${TOTAL_TIME}"
echo "memory_used=${MEMORY_USAGE}"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0  ]; then
	echo "solved=true"
else
	echo "solved=false"
fi

PLANNER_TIME_LINE=$(grep 'Planner time' ${CMD_OUT})
LINE_SPLIT=(${PLANNER_TIME_LINE/ })
RAW_SEARCH_TIME=${LINE_SPLIT[3]}
SEARCH_TIME=(${RAW_SEARCH_TIME::-1})

echo "search_time=${SEARCH_TIME}"

exit 0
