#!/bin/bash
curl -s "https://api.github.com/users/benjaminfjones/repos?per_page=100" | grep -Eo 'git@[^"]*'
