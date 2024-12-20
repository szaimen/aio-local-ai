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

echo -e "\nGPU info:"
echo    "    Note: Detecting a GPU does not guarantee compatibility with Local-AI. "
echo -e "    For more details on supported GPUs and requirements, please refer to the documentation.\n"

# Filter only GPU-related devices using device class codes (0300, 0302, 0380)
if command -v lspci &>/dev/null; then
    echo "Detected GPUs:"
    lspci -nn | awk '/\[030[02|80]\]/'
else
    echo "    'lspci' not available to detect GPUs."
fi


if command -v nvidia-smi &>/dev/null; then
    echo -e "\nDetected NVIDIA GPUs:"
    nvidia-smi
else
    echo -e "\n    NVIDIA GPU not detected or 'nvidia-smi' is not installed."
    echo      "    To enable NVIDIA GPU support, please ensure the following:"
    echo      "      1. Install the Nvidia Container Toolkit on the Docker host machine."
    echo      "         Refer to the official Nvidia Container Toolkit documentation for installation instructions."
    echo      "      2. Use the 'aio-local-ai-cuda12' Docker image, specifically designed for Nvidia GPU support."
    echo      "      3. Run the container with the '--gpus all' flag to allocate GPU resources."
    echo -e "    For more details, please consult the Nextcloud Local-AI community container documentation.\n"
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
