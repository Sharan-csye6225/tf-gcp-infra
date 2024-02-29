# Terraform Configures the Google Cloud Provider (GCP)
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

# Create Virtual Private Cloud (VPC)
resource "google_compute_network" "my_vpc" {
  name                            = var.vpc_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

# Create Route Table
resource "google_compute_route" "webapp_route" {
  name             = "${var.vpc_name}-route-table"
  network          = google_compute_network.my_vpc.self_link
  dest_range       = var.dest_range
  next_hop_gateway = var.next_hop_gateway
  priority         = 1000
  depends_on       = [google_compute_subnetwork.subnet["webapp"]]
}

# Create Subnets dynamically
resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnet_map

  name          = "${var.vpc_name}-${each.key}"
  ip_cidr_range = each.value
  network       = google_compute_network.my_vpc.self_link
}

# Create Subnets Firewall rule - Deny all ports
resource "google_compute_firewall" "firewall_deny" {
  name        = var.firewall_deny_name
  network     = google_compute_network.my_vpc.self_link
  description = var.firewall_description

  deny {
    protocol = var.firewall_deny_protocol
    ports    = var.firewall_deny_port
  }

  priority      = var.firewall_deny_priority
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}

# Create Subnets Firewall rule - Allow http 8080
resource "google_compute_firewall" "firewall_allow" {
  name        = var.firewall_allow_name
  network     = google_compute_network.my_vpc.self_link
  description = var.firewall_description

  allow {
    protocol = var.firewall_allow_protocol
    ports    = var.firewall_allow_port
  }

  priority      = var.firewall_allow_priority
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}

resource "random_id" "db_name_suffix" {
  byte_length = var.db_name_suffix_byte_length
}

resource "google_compute_global_address" "private_ip_address" {
  name          = var.private_ip_address_name
  purpose       = var.purpose
  address_type  = var.address_type
  prefix_length = var.prefix_length
  network       = google_compute_network.my_vpc.id
}

resource "google_service_networking_connection" "private_network_connection" {
  network                 = google_compute_network.my_vpc.id
  service                 = var.private_network_connection_service
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "my_db_instance" {
  name                = "${var.my_db_instance_name}-${random_id.db_name_suffix.hex}"
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection
  depends_on          = [google_service_networking_connection.private_network_connection]
  settings {
    tier              = var.tier
    disk_type         = var.disk_type
    disk_size         = var.disk_size
    availability_type = var.availability_type
    disk_autoresize   = var.disk_autoresize
    edition           = var.edition
    backup_configuration {
      enabled            = var.backup_configuration_enabled
      binary_log_enabled = var.backup_configuration_binary_log_enabled
    }
    ip_configuration {
      ipv4_enabled    = var.ip_configuration_ipv4_enabled
      private_network = google_compute_network.my_vpc.id
    }
  }
}

resource "random_password" "db_password" {
  length           = var.db_password_length
  special          = var.db_password_special
  override_special = var.db_password_override_special
}

resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.my_db_instance.name
}

# CloudSQL Database User
resource "google_sql_user" "db_user" {
  name     = var.db_user
  instance = google_sql_database_instance.my_db_instance.name
  password = random_password.db_password.result
  host     = google_compute_instance.my_vm_instance.hostname
}


# Output the internal IP address of the Cloud SQL instance
output "cloud_sql_internal_ip" {
  value = google_sql_database_instance.my_db_instance.private_ip_address
}

# Create GCP Compute Engine Instance
resource "google_compute_instance" "my_vm_instance" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags

  network_interface {
    subnetwork = google_compute_subnetwork.subnet["webapp"].self_link
    network    = google_compute_network.my_vpc.self_link
    access_config { #Generates a external IP address
      nat_ip       = var.access_config_nat_ip
      network_tier = var.access_config_network_tier
    }
  }

  boot_disk {
    auto_delete = var.boot_disk_auto_delete
    initialize_params {
      image = var.custom_image_name
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  metadata = {
    startup-script = <<-EOF
    echo "Startup script"
    cd /opt/cloud
    echo "MYSQL_DB_USERNAME=${google_sql_user.db_user.name}" >> .env
    echo "MYSQL_DB_PASSWORD=${random_password.db_password.result}" >> .env
    echo "MYSQL_DB_DATABASE=${google_sql_database.db.name}" >> .env
    echo "MYSQL_DB_HOST=${google_sql_database_instance.my_db_instance.private_ip_address}" >> .env
    echo "MYSQL_DB_PORT=${var.cloudSQL_port}" >> .env
    EOF
  }
}

