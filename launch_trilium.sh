#! /usr/bin/env bash

docker run -d --restart unless-stopped -p 0.0.0.0:8080:8080 -v ~/trilium-data:/home/node/trilium-data --name trilium zadam/trilium:latest
