run:
	docker-compose up -d --remove-orphans
down:
	docker-compose down
plan:
	terraform plan
apply:
	terraform apply -auto-approve
invoke_lambda:
	aws lambda invoke --function-name local-lambda --endpoint-url=http://localhost:4566 a.log
list_functions:
	aws lambda list-functions --endpoint-url=http://localhost:4566