default: check principal

check:
ifndef INTERNAL_AWS_PROFILE
	$(error INTERNAL_AWS_PROFILE is undefined)
endif
ifndef TEST_AWS_PROFILE
	$(error TEST_AWS_PROFILE is undefined)
endif
ifndef STAGE_AWS_PROFILE
	$(error STAGE_AWS_PROFILE is undefined)
endif
ifndef LIVE_AWS_PROFILE
	$(error LIVE_AWS_PROFILE is undefined)
endif
ifndef INTERNAL_TFSTATE_BUCKET
	$(error INTERNAL_TFSTATE_BUCKET is undefined)
endif
ifndef TEST_TFSTATE_BUCKET
	$(error TEST_TFSTATE_BUCKET is undefined)
endif
ifndef STAGE_TFSTATE_BUCKET
	$(error STAGE_TFSTATE_BUCKET is undefined)
endif
ifndef LIVE_TFSTATE_BUCKET
	$(error LIVE_TFSTATE_BUCKET is undefined)
endif
ifndef AWS_REGION
	$(error AWS_REGION is undefined)
endif

principal: check
	$(eval INTERNAL_PRINCIPAL := $(shell AWS_PROFILE=$(INTERNAL_AWS_PROFILE) scripts/get-principal))

init-internal-tfstate-bucket: check
	scripts/init-tfstate-bucket \
		--profile $(INTERNAL_AWS_PROFILE) \
		--tfstate-bucket $(INTERNAL_TFSTATE_BUCKET) \
		--tfstate-region $(AWS_REGION)

init-test-tfstate-bucket: check
	$(eval TEST_TFSTATE_BUCKET_ARN := $(shell scripts/init-tfstate-bucket \
		--profile $(TEST_AWS_PROFILE) \
		--tfstate-bucket $(TEST_TFSTATE_BUCKET) \
		--tfstate-region $(AWS_REGION)))

init-stage-tfstate-bucket: check
	$(eval STAGE_TFSTATE_BUCKET_ARN := $(shell scripts/init-tfstate-bucket \
		--profile $(STAGE_AWS_PROFILE) \
		--tfstate-bucket $(STAGE_TFSTATE_BUCKET) \
		--tfstate-region $(AWS_REGION)))

init-live-tfstate-bucket: check
	$(eval LIVE_TFSTATE_BUCKET_ARN := $(shell scripts/init-tfstate-bucket \
		--profile $(LIVE_AWS_PROFILE) \
		--tfstate-bucket $(LIVE_TFSTATE_BUCKET) \
		--tfstate-region $(AWS_REGION)))

init-test-deployment-role: check principal init-test-tfstate-bucket
	scripts/init-deployment-role \
		--profile $(TEST_AWS_PROFILE) \
		--tfstate-bucket-arn $(TEST_TFSTATE_BUCKET_ARN) \
		--principal-arn $(INTERNAL_PRINCIPAL)

init-stage-deployment-role: check principal init-stage-tfstate-bucket
	scripts/init-deployment-role \
		--profile $(STAGE_AWS_PROFILE) \
		--tfstate-bucket-arn $(STAGE_TFSTATE_BUCKET_ARN) \
		--principal-arn $(INTERNAL_PRINCIPAL)

init-live-deployment-role: check principal init-live-tfstate-bucket
	scripts/init-deployment-role \
		--profile $(LIVE_AWS_PROFILE) \
		--tfstate-bucket-arn $(LIVE_TFSTATE_BUCKET_ARN) \
		--principal-arn $(INTERNAL_PRINCIPAL)

init-internal: init-internal-tfstate-bucket

init-test: init-test-tfstate-bucket init-test-deployment-role

init-stage: init-stage-tfstate-bucket init-stage-deployment-role

init-live: init-live-tfstate-bucket init-live-deployment-role

init: init-internal init-test init-stage init-live

.PHONY: default check principal init-internal-tfstate-bucket \
	init-test-tfstate-bucket init-test-deployment-role init-test \
	init-stage-tfstate-bucket init-stage-deployment-role init-staging \
	init-live-tfstate-bucket init-live-deployment-role init-live init
