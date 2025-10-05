#! /usr/bin/env bash

docker pull triliumnext/trilium:latest
docker run -d --restart unless-stopped -p 0.0.0.0:8080:8080 -v ~/trilium-data:/home/node/trilium-data --name trilium triliumnext/trilium:latest
