#!/bin/bash

env="$1"

[ -z "$env" ] && echo "ERROR: Input environment name" >&2 && exit 1

CONDA_BASE=$(conda info --base)
. "${CONDA_BASE}/etc/profile.d/conda.sh"

CONDA_ENV=$(conda info -e | grep '\*' | awk '{print $1}')

if [ "$CONDA_ENV" != "$env" ]; then
    conda activate "$env" || exit 1
fi