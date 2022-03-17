.ONESHELL:
SHELL = /usr/bin/bash

all : images push cluster

local : images minikube cluster

images :
	docker build -t aceitchecripto/app:latest .
	docker build -t aceitchecripto/nginx:latest ./nginx
	docker build -t aceitchecripto/psql:latest ./sql

minikube :
	minikube image load aceitchecripto/app:latest
	minikube image load aceitchecripto/nginx:latest
	minikube image load aceitchecripto/psql:latest

push :
	docker push aceitchecripto/app:latest
	docker push aceitchecripto/app:nginx
	docker push aceitchecripto/app:psql

cluster :
	kubectl apply -f manifest/secret.yml
	kubectl apply -f manifest

clean :
	kubectl delete -f manifest
