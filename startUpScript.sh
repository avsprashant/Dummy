#!/bin/sh
kubectl create -f helloworld-db-service.yml
kubectl create -f database-service.yml
kubectl create -f secrets.yml