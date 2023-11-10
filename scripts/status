#!/bin/bash

# Script is stolen from kyrke

if [ -z "$1" ]; then 
  user=$(whoami)
else 
  user=$1
fi

jobsRunningMe=$(squeue -u ${user} -h -t R | wc -l)
jobsRunningTotal=$(squeue -h -t R | wc -l)
jobsPendingMe=$(squeue -u $user -h -t PD | wc -l)
jobsPendingTotal=$(squeue -h -t PD | wc -l)

lines=$(stty size | cut '-d ' -f1)
col=$(stty size | cut '-d ' -f2)

echo Running: $jobsRunningTotal, Pending: $jobsPendingTotal
echo My Jobs: 
echo Running: $jobsRunningMe, Pending: $jobsPendingMe

w=$(($col-67))

squeue -u $user -o "%.18i %.9P %.${w}j %.2t %.10M %.6D %R" --sort "S" | head -n $(($lines-5))
