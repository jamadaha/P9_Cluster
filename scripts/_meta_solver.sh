#!/bin/bash
## NOTE: This file is not meant to be run, rather it is called by others

ulimit -v 8192000 ## 8 GB

DOMAIN="$1"
PROBLEM="$2"
META_DOMAIN="$3"
CACHE="$4"
CACHE_METHOD="$5"

INFO_OUT="info"
CMD_OUT="cmd_out"

CMD="reconstruction -d ${DOMAIN} -p ${PROBLEM} -m ${META_DOMAIN} -c ${CACHE} --cache-method ${CACHE_METHOD}"
CMD="timeout 30m /usr/bin/time -f \"%e,%M\" ${CMD} >> ${CMD_OUT}"

echo "${CMD}"

$(eval ${CMD} 2>${INFO_OUT})

INFO=$(<${INFO_OUT})
INFO_SPLIT=(${INFO//,/ })
TOTAL_TIME=${INFO_SPLIT[0]}
MEMORY_USAGE=${INFO_SPLIT[1]}


EXIT_CODE=$?

if [ $EXIT_CODE -eq 0  ]; then
	echo "solved=true"
	echo "total_time=${TOTAL_TIME}"
	echo "memory_used=${MEMORY_USAGE}"
else
	echo "solved=false"
fi

exit 0
