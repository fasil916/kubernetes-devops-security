#!/bin/bash

DockerImage=$(awk '/^FROM/ {print $2; exit}' Dockerfile)

echo "Docker Image: $DockerImage"

docker run --rm -v .:/root/.cache/ aquasec/trivy:0.18.3 -q image --exit-code 0 --severity HIGH --light $DockerImage

docker run --rm -v .:/root/.cache/ aquasec/trivy:0.18.3 -q image --exit-code 1 --severity CRITICAL --light $DockerImage

exit_code=$?

echo "Exit code: $exit_code"

if [[ "$exit_code" -eq 1 ]]; then
    echo "Image scanning found vulnerabilities!"
    exit 0
else
    echo "Image scan passed."
fi
