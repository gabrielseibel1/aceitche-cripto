.ONESHELL:
SHELL = /usr/bin/bash

all : images push cluster

local : images minikube cluster

images :
	docker build -t aceitchecripto/app:latest .
	docker build -t aceitchecripto/psql:latest ./sql

minikube :
	minikube image load aceitchecripto/app:latest
	minikube image load aceitchecripto/psql:latest

push :
	docker push aceitchecripto/app:latest
	docker push aceitchecripto/psql:latest

cluster :
	kubectl apply -f cluster/secret.yml
	kubectl apply -f cluster/storage.yml
	kubectl apply -f cluster

clean :
	kubectl delete -f cluster
