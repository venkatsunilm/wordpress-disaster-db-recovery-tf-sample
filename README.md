# WordPress Deployment with Disaster Recovery on OpenStack

## Table of Contents
1. [Overview](#overview)
2. [Exercise 7: WordPress Deployment](#exercise-7-wordpress-deployment)
    - [Environment Setup](#environment-setup)
    - [Installing MySQL Database](#installing-mysql-database)
    - [Installing Web Server and WordPress](#installing-web-server-and-wordpress)
    - [Configuring SSL](#configuring-ssl)
3. [Exercise 8: Disaster Recovery](#exercise-8-disaster-recovery)
    - [Attaching Persisted Volumes](#attaching-persisted-volumes)
    - [Restoring WordPress](#restoring-wordpress)
    - [Changing the Domain Name](#changing-the-domain-name)
    - [Post Updates](#post-updates)
4. [Troubleshooting](#troubleshooting)
5. [References](#references)

---

## Overview
This project demonstrates deploying a WordPress site using OpenStack and implementing disaster recovery mechanisms by attaching persisted volumes and restoring the WordPress database. It involves setting up a MySQL database server, a web server with Nginx, and configuring a self-signed SSL certificate.

---

## WordPress Deployment

### Environment Setup
- Two virtual machines (VMs) were provisioned in **OpenStack**:
  1. **VM1 (Web Server)**: Publicly accessible with Nginx and PHP installed.
  2. **VM2 (Database Server)**: Private network with MySQL database.

### Installing MySQL Database
1. **MySQL Installation on VM2**:
   - Installed MySQL server.
   - Secured the installation using `mysql_secure_installation` (medium security level).
   - Created a `wordpress` database and users:
     - `local_db_user` for local access.
     - `wp_remote_user` for remote access from VM1.

2. **Database Configuration**:
   - Edited `/etc/mysql/mysql.conf.d/mysqld.cnf` to bind the MySQL service to the private IP of VM2.

### Installing Web Server and WordPress
1. **Web Server Setup on VM1**:
   - Installed Nginx and PHP using a LEMP stack.
   - Configured Nginx to serve WordPress with PHP.

2. **WordPress Installation**:
   - Downloaded and configured WordPress on `/var/www/your_domain`.
   - Set the database connection details in `wp-config.php`:
     ```
     DB_NAME: wordpress
     DB_USER: wp_remote_user
     DB_PASSWORD: <password>
     DB_HOST: 192.168.1.99
     ```

### Configuring SSL
1. Created a self-signed SSL certificate with OpenSSL.
2. Updated Nginx to use SSL by creating snippets (`self-signed.conf` and `ssl-params.conf`).
3. Redirected HTTP traffic to HTTPS.

---

## Disaster Recovery

### Attaching Persisted Volumes
1. Created and attached a persisted OpenStack volume (`/dev/vdb`) to the database server (VM2).
2. Restored the database by:
   - Mounting the volume at `/mnt/wordpress_db`.
   - Linking it to the MySQL data directory (`/var/lib/mysql`).
   - Restarting the MySQL service.

### Restoring WordPress
1. Verified that WordPress connected to the restored database.
2. Ensured the site was running at `https://vmxxxx.kaj.pouta.csc.fi`.

### Changing the Domain Name
1. Checked the domain name using:
   ```bash
   nslookup <floating_ip>
   ```
2. Updated the domain in the WordPress database:
   ```sql
   UPDATE wp_options SET option_value = 'https://vmxxxx.kaj.pouta.csc.fi' WHERE option_name = 'siteurl';
   UPDATE wp_options SET option_value = 'https://vmxxxx.kaj.pouta.csc.fi' WHERE option_name = 'home';
   ```

---

## Troubleshooting
- **Error establishing a database connection**: Ensure the correct MySQL user credentials and host IP are set in `wp-config.php`.
- **SSL issues**: Verify the self-signed certificate is properly configured and added to Nginx.
- **Persistent volume not mounting**: Ensure the volume is formatted and linked correctly to `/var/lib/mysql`.

---