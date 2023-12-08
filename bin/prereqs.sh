#!/usr/bin/env bash

python -m venv  ~/venv/unifi_docker

source ~/venv/unifi_docker/bin/activate


DIR=$(dirname -- "${BASH_SOURCE[0]}")

pip install -r "${DIR}/../requirements.txt"

python "${DIR}/../python/main.py"

