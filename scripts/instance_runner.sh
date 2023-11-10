#!/bin/bash
#SBATCH --output=/nfs/home/student.aau.dk/jmdh19/slurm-output/instance_runner-%A_%a.out
#SBATCH --error=/nfs/home/student.aau.dk/jmdh19/slurm-output/instance_runner-%A_%a.err
#SBATCH --partition=dhabi
#SBATCH --mem=9G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jmdh19@student.aau.dk

if [ -z "${SLURM_JOBID+xxx}" ]; then SLURM_JOBID=0; fi
if [ -z "${SLURM_ARRAY_TASK_ID+xxx}" ]; then SLURM_ARRAY_TASK_ID=1; fi

if  (("$#" < 4)); then
    echo "Illegal number of parameters"
    exit 1
fi

U="$1"
PD=$(pwd)

SCRATCH_DIRECTORY=/scratch/${U}/${SLURM_JOBID}  

DOMAIN_DIR="$2"
echo "Domain dir: ${DOMAIN_DIR}"
DOMAIN_NAME=${DOMAIN_DIR##*/}
echo "Domain name: ${DOMAIN_NAME}"

RESULT_DIR="$3"
mkdir -p ${RESULT_DIR}
echo "Result dir: ${RESULT_DIR}"

DOMAIN="${DOMAIN_DIR}/domain.pddl"
META_DOMAIN="${DOMAIN_DIR}/metaDomain.pddl"
CACHE="${DOMAIN_DIR}/cache"
PROBLEM_NAME="p${SLURM_ARRAY_TASK_ID}"
echo "Problem name: ${PROBLEM_NAME}"
PROBLEM="${DOMAIN_DIR}/problems/${PROBLEM_NAME}.pddl"
echo "Problem: ${PROBLEM}"

shift;shift;shift;
for var in $@
do
    mkdir -p ${SCRATCH_DIRECTORY}
    cd ${SCRATCH_DIRECTORY}

    SCRIPT_PATH="${PD}/${var}"
    SCRIPT_OUT="script_out"
    CMD="${SCRIPT_PATH} ${DOMAIN} ${PROBLEM} ${META_DOMAIN} ${CACHE} >> ${SCRIPT_OUT}"
    eval "${CMD}"
    NAME=$(grep 'name' ${SCRIPT_OUT} | cut -d "=" -f2)
    TOTAL_TIME=$(grep 'total_time' ${SCRIPT_OUT} | cut -d "=" -f2)
    SEARCH_TIME=$(grep 'search_time' ${SCRIPT_OUT} | cut -d "=" -f2)
    MEMORY_USED=$(grep 'memory_used' ${SCRIPT_OUT} | cut -d "=" -f2)
    SOLVED=$(grep 'solved' ${SCRIPT_OUT} | cut -d "=" -f2)

    RESULT_FILE="${RESULT_DIR}/${SLURM_JOBID}_${NAME}"
    OUTPUT="${NAME}, ${DOMAIN_NAME}, ${PROBLEM_NAME}, ${SOLVED}, ${MEMORY_USED}, ${TOTAL_TIME} ${SEARCH_TIME}"
    echo "Printing result to: ${RESULT_FILE}"
    echo ${OUTPUT} > ${RESULT_FILE}

    cd /scratch/${U}
    [ -d "${SLURM_JOBID}" ] && rm -r ${SLURM_JOBID}
done


exit 0
