dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

build:
		docker build  -t $(IMAGE_NAME) .

build-nc:
		docker build --no-cache -t $(IMAGE_NAME) .

tag-latest:
		docker tag $(IMAGE_NAME) $(REGISTRY_URI)/$(IMAGE_NAME):latest

tag-version:
		docker tag $(IMAGE_NAME) $(REGISTRY_URI)/$(IMAGE_NAME):$(VERSION)

publish-latest: tag-latest
		docker push $(REGISTRY_URI)/$(IMAGE_NAME):latest

publish-version: tag-version
		docker push $(REGISTRY_URI)/$(IMAGE_NAME):$(VERSION)

publish: repo-login publish-latest publish-version

release: build-nc publish

clean:
	docker image rm $(IMAGE_NAME)

# HELPERS

# generate script to login to aws docker repo
CMD_REPOLOGIN := "eval $$\( aws ecr"
ifdef AWS_CLI_PROFILE
CMD_REPOLOGIN += " --profile $(AWS_CLI_PROFILE)"
endif
ifdef AWS_CLI_REGION
CMD_REPOLOGIN += " --region $(AWS_CLI_REGION)"
endif
CMD_REPOLOGIN += " get-login --no-include-email \)"

# login to AWS-ECR
repo-login: ## Auto login to AWS-ECR unsing aws-cli
	@eval $(CMD_REPOLOGIN)

version: ## Output the current version
	@echo $(VERSION)