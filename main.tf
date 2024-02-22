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

  priority      = var.firewall-deny-priority
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

  priority      = var.firewall-allow-priority
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
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
      image = var.custom-image-name
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }
}
