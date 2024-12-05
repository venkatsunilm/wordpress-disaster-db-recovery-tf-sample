# Security Group 1: Web Server (VM1)
resource "openstack_networking_secgroup_v2" "web_server_secgroup" {
  name        = "WebServer-SG"
  description = "Allow SSH, HTTP, HTTPS, and private network access from VM1"
}

# Allow SSH (port 22) to VM1 from any IP
resource "openstack_networking_secgroup_rule_v2" "web_ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web_server_secgroup.id
}

# Allow HTTP (port 80) to VM1 from any IP
resource "openstack_networking_secgroup_rule_v2" "web_http_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web_server_secgroup.id
}

# Allow HTTPS (port 443) to VM1 from any IP
resource "openstack_networking_secgroup_rule_v2" "web_https_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web_server_secgroup.id
}

# Allow private network communication to VM1
resource "openstack_networking_secgroup_rule_v2" "web_private_network_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.web_server_secgroup.id
}

# Security Group 2: Database Server (VM2)
resource "openstack_networking_secgroup_v2" "db_server_secgroup" {
  name        = "DBServer-SG"
  description = "Allow MySQL access from VM1 and SSH for maintenance"
}

# Allow MySQL (port 3306) access to VM2 from VM1
resource "openstack_networking_secgroup_rule_v2" "db_mysql_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.db_server_secgroup.id
}

# Allow SSH (port 22) to VM2 from VM1
resource "openstack_networking_secgroup_rule_v2" "db_ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.db_server_secgroup.id
}

# Floating IP for VM1
resource "openstack_networking_floatingip_v2" "fip_vm1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip_vm1_association" {
  floating_ip = openstack_networking_floatingip_v2.fip_vm1.address
  instance_id = openstack_compute_instance_v2.vm1.id
}

# Define VM1: WordPress Web Server
resource "openstack_compute_instance_v2" "vm1" {
  name        = "WordPressWebServer"
  image_name  = "Ubuntu-22.04"
  flavor_name = "standard.small"
  key_pair    = "id_rsa"
  security_groups = [openstack_networking_secgroup_v2.web_server_secgroup.name]

  network {
    name = "project_2011705"
  }
}

# Define VM2: Database Server
resource "openstack_compute_instance_v2" "vm2" {
  name        = "DatabaseServer"
  image_name  = "Ubuntu-22.04"
  flavor_name = "standard.small"
  key_pair    = "id_rsa"
  security_groups = [openstack_networking_secgroup_v2.db_server_secgroup.name]

  network {
    name = "project_2011705"
  }
}
