# OpenStack Authentication Variables
variable "openstack_credentials" {
  description = "OpenStack authentication details."
  type = object({
    username         = string
    password         = string
    auth_url         = string
    region_name      = string
    project_name     = string
    user_domain_name = string
  })
}

# VM Configuration Variables
variable "vm_defaults" {
  description = "Default settings for VM instances."
  type = object({
    image_name    = string
    flavor_name   = string
    network_name  = string
    key_pair_name = string
  })
}

# Security Group Rules
variable "security_group_rules" {
  description = "Security group rules for VMs."
  type = object({
    web_server = list(object({
      name       = string
      protocol   = string
      port_range = tuple([number, number]) # Start and end ports
      source     = string
    }))
    db_server = list(object({
      name       = string
      protocol   = string
      port_range = tuple([number, number]) # Start and end ports
      source     = string
    }))
  })
}

# Output Settings
variable "output_settings" {
  description = "Settings for outputs."
  type = object({
    vm1_floating_ip = bool
    vm2_private_ip  = bool
  })
}
