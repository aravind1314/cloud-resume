#!/usr/bin/env bash

export URL=$1
export IMAGE=$2
export docker_user=$3
export docker_pswd=$4

echo $docker_pswd | docker login -u $docker_user --password-stdin

docker-compose -f docker-compose.yaml up --detach

echo " docker compose successful"
