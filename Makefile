AWS_REGION           := eu-west-1
AWS                  := aws
SERVICE              := mlbot
SERVERLESS           := node_modules/.bin/serverless

node_modules: package.json
	npm install
	touch node_modules

$(SERVERLESS): node_modules

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

.PHONY: deploy-serverless
deploy-serverless: $(SERVERLESS)
	$(SERVERLESS) deploy --stage=dev

.PHONY: deploy
deploy: deploy-infrastructure deploy-serverless
