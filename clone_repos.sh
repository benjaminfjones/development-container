#!/bin/bash

for repo in $(cat repositories.txt); do
    git clone "$repo"
done
