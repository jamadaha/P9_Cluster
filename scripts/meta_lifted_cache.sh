#!/bin/bash

echo "name=lifted_cache"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
META_SOLVER="${SCRIPT_DIR}/_meta_solver.sh"

eval "${META_SOLVER} $1 $2 $3 $4 \"lifted\""
