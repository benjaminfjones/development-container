#!/bin/bash

WORK_DIR=/home/bfj/oss-workspace

cd $WORK_DIR
for repo in $(cat repositories.txt); do
    git clone "$repo"
done
