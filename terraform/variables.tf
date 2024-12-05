# OpenStack Authentication Variables
variable "os_username" {
  description = "Username for OpenStack authentication."
  type        = string
}

variable "os_password" {
  description = "Password for OpenStack authentication."
  type        = string
  sensitive   = true
}

variable "os_auth_url" {
  description = "Authentication URL for OpenStack."
  type        = string
}

variable "os_region_name" {
  description = "OpenStack region to deploy resources."
  type        = string
}

variable "os_project_name" {
  description = "Project (tenant) name for OpenStack."
  type        = string
}

variable "os_user_domain_name" {
  description = "User domain for OpenStack authentication."
  type        = string
}

# VM Instance Variables
variable "web_server_image_name" {
  description = "Image name for the web server."
  default     = "Ubuntu-22.04"
}

variable "web_server_flavor_name" {
  description = "Flavor for the web server."
  default     = "standard.small"
}

variable "db_server_image_name" {
  description = "Image name for the database server."
  default     = "Ubuntu-22.04"
}

variable "db_server_flavor_name" {
  description = "Flavor for the database server."
  default     = "standard.small"
}

# Key Pair Variable
variable "key_pair_name" {
  description = "Key pair name for SSH access."
  default     = "id_rsa"
}
