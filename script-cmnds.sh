#!/usr/bin/env bash

export URL=$1
export IMAGE=$2
export docker_user=$3
export docker_pswd=$4

docker login -u $docker_user -p $docker_pswd

docker-compose -f docker-compose.yaml up --detach

echo " docker compose successful"
