#! /usr/bin/env bash

docker stop ghost-ghost-1
docker stop ghost-db-1
docker rm ghost-ghost-1
docker pull ghost:latest

# change wherever appropriate
sh /opt/ghost/launch-ghost.sh
