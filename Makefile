.ONESHELL:
SHELL = /usr/bin/bash

all : images push cluster

app :
	docker build -t aceitchecripto/app:v0.3.3 .
	docker push aceitchecripto/app:v0.3.3
	kubectl apply -f cluster/app.yml

psql :
	docker build -t aceitchecripto/psql:v0.3.0 ./sql
	docker push aceitchecripto/psql:v0.3.0
	kubectl apply -f cluster/psql.yml

cluster :
	kubectl apply -f cluster/secret.yml
	kubectl apply -f cluster/storage.yml
	kubectl apply -f cluster

clean :
	kubectl delete -f cluster
