# tf-gcp-infra
This Repo is for Terraform and GCP infra code


Prerequisites:-

Install and setup GCloud CLI - https://cloud.google.com/sdk/docs/install
	Download the Tar file for the specific OS and extract the archive to any location on your file system (preferably your Home directory).
	Run the script (from the root of the folder you extracted in the last step) using this command:  ./google-cloud-sdk/install.sh
	To initialize the gcloud CLI, run gcloud init:  ./google-cloud-sdk/bin/gcloud init
	Initializing the gcloud CLI  - https://cloud.google.com/sdk/docs/initializing

		To Set up a gcloud CLI configuration and set a base set of properties, including the active account, the current project and the default Compute Engine region and zone, run the following: 
			gcloud auth login	---> Authorize with a user account without setting up a configuration.
			gcloud auth activate-service-account	---> Authorize with a service account instead of a user account. Useful for authorizing non-interactively and without a web browser.
			gcloud auth application-default   ---> Manage your Application Default Credentials (ADC) for Cloud Client Libraries.
			gcloud auth list  --->  List all credentialed accounts.
			gcloud auth revoke		--->  Remove access credentials for an account.


Install Homebrew -  https://brew.sh/
		$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


Install Terraform - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

	Install the HashiCorp tap, a repository of all our Homebrew packages  --> brew tap hashicorp/tap
	Install Terraform with hashicorp/tap/terraform 	--->  brew install hashicorp/tap/terraform
	To update to the latest version of Terraform, first update Homebrew	---> brew update
	Run the upgrade command to download and use the latest Terraform version 	---> brew upgrade hashicorp/tap/terraform
	Verify the Terraform installation  --->   terraform -help
	Install the autocomplete package  --->  terraform -install-autocomplete

Getting Started

Follow these steps to set up the infrastructure:

Clone the repository:

	git clone <repository_url>
	cd <repository_name>

Initialize Terraform:  
	terraform init

Steps to Notes:
	Review and modify Terraform variables: Review the variables.tf file and modify the variables as needed for your infrastructure setup. You can specify variables either directly in this file or by using environment variables.
	Review and modify Terraform configurations: Review the Terraform configuration files (main.tf, network.tf, etc.) to ensure they match your desired infrastructure setup. Modify them as needed.
	Plan the Terraform execution: Before applying changes, it's a good practice to review what changes Terraform will make. Execute the following command:  terraform plan
	Review the output to ensure it matches your expectations.
	Apply Terraform changes:   terraform apply
		Confirm the action by typing yes when prompted.

Verify the infrastructure:

After Terraform completes applying changes, verify that the infrastructure is set up correctly using the GCP console

To Cleaning Up :
To tear down the infrastructure and delete all resources created by Terraform, run:
	---> $ terraform destroy
	---> Confirm the action by typing yes when prompted.