#!/bin/bash
docker build -t grandinetti/alpine-ssh-deployer:latest .
docker push grandinetti/alpine-ssh-deployer:latest