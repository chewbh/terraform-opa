.PHONY: all tfplan validate apply destroy clean

all: validate apply

tfplan:
	@echo "generating terraform plan for check"
	terraform init
	terraform plan -out=.tfplan
	terraform show -json ./.tfplan > .tfplan.json

validate: tfplan
	@echo "validate against policies..."
	conftest test .tfplan.json

apply:
	terraform apply -auto-approve

destroy: clean
	terraform destroy -auto-approve

clean:
	@echo "cleaning up..."
	rm .tfplan .tfplan.json
