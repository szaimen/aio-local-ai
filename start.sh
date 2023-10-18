#!/bin/bash

echo "CPU info:"
grep -e "model\sname" /proc/cpuinfo | head -1
grep -e "flags" /proc/cpuinfo | head -1
if grep -q -e "\savx\s" /proc/cpuinfo ; then
    echo "CPU:    AVX    found OK"
else
    echo "CPU: no AVX    found"
fi
if grep -q -e "\savx2\s" /proc/cpuinfo ; then
    echo "CPU:    AVX2   found OK"
else
    echo "CPU: no AVX2   found"
fi
if grep -q -e "\savx512" /proc/cpuinfo ; then
    echo "CPU:    AVX512 found OK"
else
    echo "CPU: no AVX512 found"
fi

while ! nc -z nextcloud-aio-nextcloud 9001; do
    echo "Waiting for nextcloud to start"
    sleep 5
done

while ! [ -f /nextcloud/admin/files/nextcloud-aio-local-ai/models.yaml ]; do
    echo "Waiting for nextcloud-aio-local-ai/models.yaml file to be created"
    sleep 5
done

# Set Threads automatically
set -x
THREADS="$(nproc)"
export THREADS
set +x

./local-ai --preload-models-config "/nextcloud/admin/files/nextcloud-aio-local-ai/models.yaml"
