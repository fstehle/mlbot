AWS_REGION           := eu-central-1
AWS                  := aws
SERVICE              := mlbot

.PHONY: deploy-infrastructure
deploy-infrastructure:
	$(AWS) cloudformation deploy \
		--no-fail-on-empty-changeset \
		--template-file infrastructure.yml \
		--stack-name $(SERVICE)-infrastructure \
		--parameter-overrides \
			Service=$(SERVICE) \
		--capabilities CAPABILITY_IAM \
		--region $(AWS_REGION)