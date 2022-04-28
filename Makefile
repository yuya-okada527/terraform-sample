run:
	docker-compose up -d --remove-orphans
down:
	docker-compose down
plan:
	terraform plan
apply:
	terraform apply -auto-approve
destroy:
	terraform destroy
invoke_lambda:
	aws lambda invoke --function-name local-lambda --endpoint-url=http://localhost:4566 tmp/lambda.json
log_lambda:
	cat tmp/lambda.json | jq
list_functions:
	aws lambda list-functions --endpoint-url=http://localhost:4566