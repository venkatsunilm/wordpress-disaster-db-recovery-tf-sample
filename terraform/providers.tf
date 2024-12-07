terraform {
  # Ensure compatibility with specific Terraform versions
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0" # Specify the provider version
    }
  }
}

provider "openstack" {
  # Use variables for OpenStack authentication details
  user_name        = var.openstack_credentials.username
  password         = var.openstack_credentials.password
  auth_url         = var.openstack_credentials.auth_url
  region           = var.openstack_credentials.region_name
  tenant_name      = var.openstack_credentials.project_name
  user_domain_name = var.openstack_credentials.user_domain_name
}
