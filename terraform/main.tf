# Define security group for the web server
resource "openstack_networking_secgroup_v2" "web_server_sg" {
  name        = "WebServer-SG"
  description = "Security group for the web server"
}

# Add ingress rules to the web server security group
resource "openstack_networking_secgroup_rule_v2" "web_server_rules" {
  count             = length(var.security_group_rules.web_server)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = var.security_group_rules.web_server[count.index].protocol
  port_range_min    = var.security_group_rules.web_server[count.index].port_range[0]
  port_range_max    = var.security_group_rules.web_server[count.index].port_range[1]
  remote_ip_prefix  = var.security_group_rules.web_server[count.index].source
  security_group_id = openstack_networking_secgroup_v2.web_server_sg.id
}

# Define security group for the database server
resource "openstack_networking_secgroup_v2" "db_server_sg" {
  name        = "DBServer-SG"
  description = "Security group for the database server"
}

# Add ingress rules to the database server security group
resource "openstack_networking_secgroup_rule_v2" "db_server_rules" {
  count             = length(var.security_group_rules.db_server)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = var.security_group_rules.db_server[count.index].protocol
  port_range_min    = var.security_group_rules.db_server[count.index].port_range[0]
  port_range_max    = var.security_group_rules.db_server[count.index].port_range[1]
  remote_ip_prefix  = var.security_group_rules.db_server[count.index].source
  security_group_id = openstack_networking_secgroup_v2.db_server_sg.id
}

# Define the web server instance
resource "openstack_compute_instance_v2" "web_server" {
  name            = "WordPressWebServer"
  image_name      = var.vm_defaults.image_name
  flavor_name     = var.vm_defaults.flavor_name
  key_pair        = var.vm_defaults.key_pair_name
  security_groups = [openstack_networking_secgroup_v2.web_server_sg.name]

  network {
    name = var.vm_defaults.network_name
  }
}

# Define the database server instance
resource "openstack_compute_instance_v2" "db_server" {
  name            = "DatabaseServer"
  image_name      = var.vm_defaults.image_name
  flavor_name     = var.vm_defaults.flavor_name
  key_pair        = var.vm_defaults.key_pair_name
  security_groups = [openstack_networking_secgroup_v2.db_server_sg.name]

  network {
    name = var.vm_defaults.network_name
  }
}

# Allocate and associate a floating IP for the web server
resource "openstack_networking_floatingip_v2" "web_server_fip" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "web_server_fip_associate" {
  floating_ip = openstack_networking_floatingip_v2.web_server_fip.address
  instance_id = openstack_compute_instance_v2.web_server.id
}

# Outputs
# Output the Floating IP of the web server if enabled
output "web_server_floating_ip" {
  value       = var.output_settings.vm1_floating_ip ? openstack_networking_floatingip_v2.web_server_fip.address : null
  description = "Floating IP of the web server"
}

# Output the Private IP of the database server if enabled
output "db_server_private_ip" {
  value       = var.output_settings.vm2_private_ip ? openstack_compute_instance_v2.db_server.network[0].fixed_ip_v4 : null
  description = "Private IP of the database server"
}
