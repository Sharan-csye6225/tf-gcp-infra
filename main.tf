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
  name       = var.db_user
  instance   = google_sql_database_instance.my_db_instance.name
  password   = random_password.db_password.result
  depends_on = [google_sql_database_instance.my_db_instance]
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
  depends_on   = [google_service_account.vm_service_account]

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

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = var.service_account_scope
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
    echo "LOG_FILE_PATH=${var.log_File_Path}" >> .env
    echo "GCP_PUBSUB_TOPIC_NAME:  ${google_pubsub_topic.my_topic.name}" >> .env
    echo "GCP_PROJECT_ID:  ${var.project_id}" >> .env
    EOF
  }
}

output "my_vm_instance_public_ip_address" {
  value = google_compute_instance.my_vm_instance.network_interface.0.access_config.0.nat_ip
}

resource "google_dns_record_set" "a_record" {
  name         = var.domain_name
  type         = var.a_record_type
  ttl          = var.a_record_ttl
  managed_zone = var.a_record_managed_zone
  rrdatas      = [google_compute_instance.my_vm_instance.network_interface[0].access_config[0].nat_ip]
}

resource "google_service_account" "vm_service_account" {
  account_id   = var.sa_account_id
  display_name = var.sa_display_name
}

# Bind IAM Roles to Service Account
resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.project_id
  role    = var.logging_admin_binding_role

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.project_id
  role    = var.monitoring_metric_writer_binding_role

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}

resource "google_pubsub_topic_iam_binding" "pubsub_pulisher_binding" {
  project = var.project_id
  role    = var.pubsub_pulisher_binding_role
  topic   = google_pubsub_topic.my_topic.name
  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}

resource "google_pubsub_topic" "my_topic" {
  name                       = var.topic_name
  message_retention_duration = var.topic_message_retention_duration
}

resource "google_pubsub_subscription" "my_subscription" {
  name                       = var.subscription_name
  topic                      = google_pubsub_topic.my_topic.id
  ack_deadline_seconds       = var.subscription_ack_deadline_seconds
  message_retention_duration = var.subscription_message_retention_duration
  depends_on                 = [google_cloudfunctions2_function.my_cloud_function2] # give cloud function here

  push_config {
    push_endpoint = "https://${var.region}-${var.project_id}.cloudfunctions.net/${var.subscription_name}"
  }
  retry_policy {
    minimum_backoff = var.subscription_retry_policy_minimum_backoff
    maximum_backoff = var.subscription_retry_policy_maximum_backoff
  }
}

resource "google_cloudfunctions2_function" "my_cloud_function2" {
  name        = var.my_cloud_function2_name
  location    = var.region
  description = var.my_cloud_function2_description
  depends_on  = [google_vpc_access_connector.serverless_vpc_connector]

  build_config {
    runtime     = var.my_cloud_function2_build_config_runtime
    entry_point = var.my_cloud_function2_build_config_entry_point
    source {
      storage_source {
        bucket = var.my_cloud_function2_storage_source_bucket
        object = var.my_cloud_function2_storage_source_object
      }
    }
  }

  service_config {
    max_instance_count = var.my_cloud_function2_service_config_max_instance_count
    min_instance_count = var.my_cloud_function2_service_config_min_instance_count
    available_memory   = var.my_cloud_function2_service_config_available_memory
    available_cpu      = var.my_cloud_function2_service_config_available_cpu
    timeout_seconds    = var.my_cloud_function2_service_config_timeout_seconds
    environment_variables = {
      PRIVATE_API_KEY = var.my_cloud_function2_service_config_PRIVATE_API_KEY
      DOMAIN          = var.my_cloud_function2_service_config_DOMAIN
      SUB_DOMAIN      = var.my_cloud_function2_service_config_SUB_DOMAIN
      DATABASE_URL    = "jdbc:mysql://${google_sql_database_instance.my_db_instance.private_ip_address}:${var.cloudSQL_port}/${var.db_name}?createDatabaseIfNotExist=true"
      DB_USER         = google_sql_user.db_user.name
      DB_PASSWORD     = random_password.db_password.result
      TABLE_NAME      = var.my_cloud_function2_service_config_TABLE_NAME
    }
    ingress_settings               = var.my_cloud_function2_ingress_settings
    all_traffic_on_latest_revision = var.my_cloud_function2_all_trafficon_latest_revision
    vpc_connector                  = google_vpc_access_connector.serverless_vpc_connector.name
    service_account_email          = google_service_account.cloud_function_service_account.email

  }

  event_trigger {
    trigger_region = var.region
    event_type     = var.my_cloud_function2_event_trigger_event_type
    pubsub_topic   = google_pubsub_topic.my_topic.id
    retry_policy   = var.my_cloud_function2_event_trigger_retry_policy
  }
}

resource "google_service_account" "cloud_function_service_account" {
  account_id   = var.cloud_function_service_account_account_id
  display_name = var.cloud_function_service_account_display_name
}

resource "google_project_iam_binding" "pubsub_token_creator" {
  project = var.project_id
  role    = var.pubsub_token_creator_iam_binding_role

  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account.email}"
  ]
}

resource "google_project_iam_binding" "cloud_function_invoker" {
  project = var.project_id
  role    = var.cloud_function_invoker_iam_binding_role
  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account.email}"
  ]
}

resource "google_project_iam_binding" "cloud_sql_client" {
  project = var.project_id
  role    = var.cloud_sql_client_iam_binding_role

  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account.email}",
  ]
}

resource "google_vpc_access_connector" "serverless_vpc_connector" {
  name          = var.serverless_vpc_connector_name
  region        = var.region
  ip_cidr_range = var.serverless_vpc_connector_ip_cidr_range
  network       = google_compute_network.my_vpc.self_link
  project       = var.project_id
}





