#!/bin/bash

set -e

USERNAME=ryandkb8
IMAGE=tasks-postgresql

docker build -t $USERNAME/$IMAGE:latest .