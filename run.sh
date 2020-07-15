#!/bin/bash
docker run --rm -ti \
    -h hanalei \
    -v $HOME/oss-workspace:/home/bfj/oss-workspace \
    development-container \
    zsh
