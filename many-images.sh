#!/bin/bash

BASE_DIR="$HOME/gaia-docker"

for i in {1..15}; do
    NODE_NAME="gaianet-node$i"
    NODE_DIR="$BASE_DIR/gaianet$i"
    HTTP_PORT=$((8080 + (i-1)*3))
    QDRANT_PORT=$((6333 + (i-1)*2))
    
    cd "$NODE_DIR" || exit
    
    echo "Building $NODE_NAME from $NODE_DIR..."
    docker build -t "$NODE_NAME" .
    
    echo "Starting $NODE_NAME..."
    docker run -d \
        --name "$NODE_NAME" \
        -p "$HTTP_PORT":8080 \
        -p "$QDRANT_PORT":6333 \
        -v "$HOME/gaia-docker/shared_volume:/home/$NODE_NAME/gaianet" \
        "$NODE_NAME"
    
    docker exec -it "$NODE_NAME" gaianet info
done
