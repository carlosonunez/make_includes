#!/usr/bin/env make
.PHONY: terraform_init_with_s3_backend
# Initializes Terraform with an AWS S3 Backend.
# Variable: TERRAFORM_STATE_S3_BUCKET: The bucket to use to hold Terraform state.
# Variable: TERRAFORM_STATE_S3_KEY: The key to use with the bucket above.
# Variable: AWS_REGION: The AWS region to provision resources into, e.g. "us-east-1"
terraform_init_with_s3_backend: \
	_verify_variable-TERRAFORM_STATE_S3_BUCKET \
	_verify_variable-TERRAFORM_STATE_S3_KEY \
	_verify_variable-AWS_REGION \
	ADDITIONAL_TERRAFORM_ARGS = -backend-config "bucket=$(TERRAFORM_STATE_S3_BUCKET)" \
															-backend-config "key=$(TERRAFORM_STATE_S3_KEY)" \
															-backend-config "region=$(AWS_REGION)"
terraform_init_with_s3_backend: terraform_init

.PHONY: generate_test_terraform_plan
# Generates a "dummy" Terraform plan for use with unit testing.
# Variable: TERRAFORM_STATE_S3_BUCKET: The bucket to use to hold Terraform state.
# Variable: TERRAFORM_STATE_S3_KEY: The key to use with the bucket above.
# Variable: AWS_REGION: The AWS region to provision resources into, e.g. "us-east-1"
generate_test_terraform_plan: \
	_verify_variable-TERRAFORM_STATE_S3_BUCKET \
	_verify_variable-TERRAFORM_STATE_S3_KEY \
	_verify_variable-AWS_REGION \
	ADDITIONAL_TERRAFORM_ARGS=-state=dummy -out=terraform.tfplan
generate_test_terraform_plan: terraform_plan


.PHONY: generate_test_terraform_plan_json
# Generates a JSON file from a Terraform plan.
# Variable: TERRAFORM_STATE_S3_BUCKET: The bucket to use to hold Terraform state.
# Variable: TERRAFORM_STATE_S3_KEY: The key to use with the bucket above.
# Variable: AWS_REGION: The AWS region to provision resources into, e.g. "us-east-1"
generate_test_terraform_plan_json: \
	GOLANG_DOCKER_IMAGE=golang:1.9-alpine3.7 \
	TFJSON_GITHUB_URL=github.com/wybczu/tfjson
generate_test_terraform_plan_json:
	$(info Converting test Terraform plan to JSON. Please wait a moment.)
	if [ -f terraform.tfplan.json ]; \
	then \
		rm -f terraform.tfplan.json; \
	fi; \
	docker run --rm -t -v $$PWD:/work -w /work \
		-v $$PWD/.go:/go \
		--entrypoint '/bin/sh' \
		$(GOLANG_DOCKER_IMAGE) -c 'if ! which tfjson > /dev/null; \
			then \
				echo -e "$(INFO): tfjson missing. Downloading it now."; \
				apk add --no-cache git; \
				go get $(TFJSON_GITHUB_URL); \
			fi; \
			tfjson terraform.tfplan >> terraform.tfplan.json';

.PHONY: delete_terraform_tfvars
# Deletes a transient "terraform.tfvars" file.
delete_terraform_tfvars:
	rm terraform.tfvars

.PHONY: terraform_%
# Executes a Terraform action such as "plan" or "validate."
# Example: terraform_plan will invoke "terraform plan".
# Note: This assumes that work is being done within AWS. Fork this target
# with the appropriate environment variables required by your provider to
# use something else, such as Azure or SoftLayer.
# Variable: AWS_REGION: The region being targeted. Example: us-east-1.
# Variable: AWS_ACCESS_KEY_ID: The access key to use.
# Variable: AWS_SECRET_ACCESS_KEY: The secret key for the access key provided.
# Variable: AWS_DEFAULT_REGION: The default region to use. Required by the
# 					HashiCorp AWS provider.
# Variable: ADDITIONAL_TERRAFORM_ARGS: Additional arguments to provide to
# 					Terraform.
terraform_%: \
	_verify_variable-AWS_REGION \
	_verify_variable-AWS_ACCESS_KEY_ID \
	_verify_variable-AWS_SECRET_ACCESS_KEY \
	_verify_variable-AWS_DEFAULT_REGION
terraform_%: TERRAFORM_ACTION=$(shell echo "$@" | \
	cut -f3 -d ' ' | \
	cut -f2 -d '_')
terraform_%:
	echo -e "$(INFO) Performing Terraform action: $(TERRAFORM_ACTION)"; \
	additional_actions="$(ADDITIONAL_TERRAFORM_ARGS)"; \
	docker run -t -v $$PWD:/work -w /work \
		-v $$HOME/.aws:/root/.aws \
		--env-file .env \
		-e AWS_REGION \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) \
		hashicorp/terraform $(TERRAFORM_ACTION) $$additional_actions
