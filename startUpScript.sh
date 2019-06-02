#!/bin/sh
kubectl create -f secrets.yml
kubectl create -f mysql-pv.yaml
kubectl create -f database.yml
kubectl create -f database-service.yml
kubectl create -f helloworld-db.yml
kubectl create -f helloworld-db-service.yml
