# Terraform Configures the Google Cloud Provider (GCP)
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
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
  depends_on  = [google_compute_global_address.lb_global_address]

  allow {
    protocol = var.firewall_allow_protocol
    ports    = var.firewall_allow_port
  }

  priority      = var.firewall_allow_priority
  source_ranges = [google_compute_global_address.lb_global_address.address]
  target_tags   = var.target_tags
}

resource "google_compute_firewall" "firewall_for_health_check" {
  name        = var.firewall_for_health_check_name
  network     = google_compute_network.my_vpc.self_link
  description = var.firewall_for_health_check_description
  direction   = var.firewall_for_health_check_direction

  allow {
    protocol = var.firewall_for_health_check_protocol
    ports    = var.firewall_for_health_check_ports
  }

  priority      = var.firewall_for_health_check_priority
  source_ranges = var.firewall_for_health_check_source_ranges
  target_tags   = var.target_tags
}

resource "random_id" "db_name_suffix" {
  byte_length = var.db_name_suffix_byte_length
}

resource "random_id" "key_ring_name_suffix" {
  byte_length = var.key_ring_name_suffix_byte_length
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
  encryption_key_name = google_kms_crypto_key.cloud_sql_crypto_key.id
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

resource "google_dns_record_set" "a_record" {
  name         = var.domain_name
  type         = var.a_record_type
  ttl          = var.a_record_ttl
  managed_zone = var.a_record_managed_zone
  rrdatas      = [google_compute_global_address.lb_global_address.address]
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

resource "google_storage_bucket" "cloud_storage_bucket" {
  name     = var.cloud_storage_bucket_name
  location = var.region
  encryption {
    default_kms_key_name = google_kms_crypto_key.cloud_storage_crypto_key.id
  }
  force_destroy            = var.cloud_storage_bucket_force_destroy
  public_access_prevention = var.cloud_storage_bucket_public_access_prevention
  depends_on               = [google_kms_crypto_key.cloud_storage_crypto_key, google_kms_crypto_key_iam_binding.cloud_storage_crypto_key_iam_binding]
}

resource "google_storage_bucket_object" "cloud_storage_bucket_object" {
  name       = var.cloud_storage_bucket_object_name
  bucket     = google_storage_bucket.cloud_storage_bucket.name
  source     = var.cloud_storage_bucket_object_source
  depends_on = [google_storage_bucket.cloud_storage_bucket]
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
        bucket = google_storage_bucket.cloud_storage_bucket.name
        object = google_storage_bucket_object.cloud_storage_bucket_object.name
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
    all_traffic_on_latest_revision = var.my_cloud_function2_all_traffic_on_latest_revision
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

resource "google_compute_region_instance_template" "my_vm_instance_template" {
  name         = var.my_vm_instance_template_name
  description  = var.my_vm_instance_template_description
  region       = var.region
  machine_type = var.machine_type
  tags         = var.tags
  depends_on   = [google_service_account.vm_service_account]

  labels = {
    environment = var.labels_environment
  }

  // Create a new boot disk from an image
  disk {
    source_image = var.custom_image_name
    auto_delete  = var.boot_disk_auto_delete
    boot         = var.my_vm_instance_template_boot
    disk_type    = var.boot_disk_type
    disk_size_gb = var.boot_disk_size
    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.vm_crypto_key.id
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet["webapp"].self_link
    network    = google_compute_network.my_vpc.self_link
    access_config {
      nat_ip       = var.access_config_nat_ip
      network_tier = var.access_config_network_tier
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
    echo "GCP_PUBSUB_TOPIC_NAME=${google_pubsub_topic.my_topic.name}" >> .env
    echo "GCP_PROJECT_ID=${var.project_id}" >> .env
    EOF
  }
}

resource "google_compute_health_check" "my_http_health_check" {
  name                = var.my_http_health_check_name
  description         = var.my_http_health_check_description
  timeout_sec         = var.my_http_health_check_timeout_sec
  check_interval_sec  = var.my_http_health_check_check_interval_sec
  healthy_threshold   = var.my_http_health_check_healthy_threshold
  unhealthy_threshold = var.my_http_health_check_unhealthy_threshold

  http_health_check {
    port               = var.http_health_check_port
    port_specification = var.http_health_check_port_specification
    request_path       = var.http_health_check_request_path
    proxy_header       = var.http_health_check_proxy_header
  }
}

resource "google_compute_region_instance_group_manager" "my_instance_group_manager" {
  name                             = var.my_instance_group_manager_name
  base_instance_name               = var.vm_name
  region                           = var.region
  distribution_policy_zones        = var.my_instance_group_manager_distribution_policy_zones
  distribution_policy_target_shape = var.my_instance_group_manager_distribution_policy_target_shape
  depends_on                       = [google_compute_region_instance_template.my_vm_instance_template]

  version {
    instance_template = google_compute_region_instance_template.my_vm_instance_template.self_link
  }

  named_port {
    name = var.my_instance_group_manager_named_port_name
    port = var.my_instance_group_manager_named_port_port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.my_http_health_check.id
    initial_delay_sec = var.my_instance_group_manager_auto_healing_policies_initial_delay_sec
  }

}

resource "google_compute_region_autoscaler" "my_autoscaler" {
  name       = var.my_autoscaler_name
  region     = var.region
  target     = google_compute_region_instance_group_manager.my_instance_group_manager.id
  depends_on = [google_compute_region_instance_group_manager.my_instance_group_manager]

  autoscaling_policy {
    min_replicas    = var.my_autoscaler_autoscaling_policy_min_replicas
    max_replicas    = var.my_autoscaler_autoscaling_policy_max_replicas
    cooldown_period = var.my_autoscaler_autoscaling_policy_cooldown_period

    cpu_utilization {
      target = var.my_autoscaler_cpu_utilization_target
    }
  }
}

resource "google_compute_global_address" "lb_global_address" {
  name       = var.lb_global_address_name
  ip_version = var.lb_global_address_ip_version
}

resource "google_compute_backend_service" "lb_backend_service" {
  name                            = var.lb_backend_service_name
  connection_draining_timeout_sec = var.lb_backend_service_connection_draining_timeout_sec
  health_checks                   = [google_compute_health_check.my_http_health_check.id]
  load_balancing_scheme           = var.lb_backend_service_load_balancing_scheme
  port_name                       = var.lb_backend_service_port_name
  protocol                        = var.lb_backend_service_protocol
  session_affinity                = var.lb_backend_service_session_affinity
  timeout_sec                     = var.lb_backend_service_timeout_sec
  enable_cdn                      = var.lb_backend_service_enable_cdn
  depends_on                      = [google_compute_region_instance_group_manager.my_instance_group_manager, google_compute_health_check.my_http_health_check]

  backend {
    group           = google_compute_region_instance_group_manager.my_instance_group_manager.instance_group
    balancing_mode  = var.lb_backend_service_backend_balancing_mode
    capacity_scaler = var.lb_backend_service_capacity_scaler
  }

  log_config {
    enable      = var.lb_backend_service_log_config_enable
    sample_rate = var.lb_backend_service_log_config_sample_rate
  }

}

resource "google_compute_url_map" "lb_url_map" {
  name            = var.lb_url_map_name
  default_service = google_compute_backend_service.lb_backend_service.id
  depends_on      = [google_compute_backend_service.lb_backend_service]
}

resource "google_compute_target_https_proxy" "lb_target_https_proxy" {
  name             = var.lb_target_https_proxy_name
  url_map          = google_compute_url_map.lb_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.lb_managed_ssl_certificate.id]
  depends_on       = [google_compute_url_map.lb_url_map]
}

resource "google_compute_managed_ssl_certificate" "lb_managed_ssl_certificate" {
  name = var.lb_managed_ssl_certificate_name

  managed {
    domains = var.lb_managed_ssl_certificate_managed_domains
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.lb_global_forwarding_rule_name
  ip_protocol           = var.lb_global_forwarding_rule_ip_protocol
  load_balancing_scheme = var.lb_global_forwarding_rule_load_balancing_scheme
  port_range            = var.lb_global_forwarding_rule_port_range
  target                = google_compute_target_https_proxy.lb_target_https_proxy.id
  ip_address            = google_compute_global_address.lb_global_address.address
  depends_on            = [google_compute_target_https_proxy.lb_target_https_proxy, google_compute_global_address.lb_global_address]
}

output "loadbalancer_external_ip" {
  value = google_compute_global_address.lb_global_address.address
}

# Create a key ring
resource "google_kms_key_ring" "my_key_ring" {
  name     = var.my_key_ring_name
  location = var.region
}

# Create separate customer-managed encryption keys for Virtual Machines, CloudSQL Instances, and Cloud Storage Buckets
resource "google_kms_crypto_key" "vm_crypto_key" {
  name            = var.vm_crypto_key_name
  key_ring        = google_kms_key_ring.my_key_ring.id
  rotation_period = var.crypto_key_rotation_period
  purpose         = var.crypto_key_purpose
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "cloud_sql_crypto_key" {
  name            = var.cloud_sql_crypto_key_name
  key_ring        = google_kms_key_ring.my_key_ring.id
  rotation_period = var.crypto_key_rotation_period
  purpose         = var.crypto_key_purpose
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "cloud_storage_crypto_key" {
  name            = var.cloud_storage_crypto_key_name
  key_ring        = google_kms_key_ring.my_key_ring.id
  rotation_period = var.crypto_key_rotation_period
  purpose         = var.crypto_key_purpose
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = var.gcp_sa_cloud_sql_service
}

resource "google_kms_crypto_key_iam_binding" "vm_crypto_key_iam_binding" {
  crypto_key_id = google_kms_crypto_key.vm_crypto_key.id
  role          = var.crypto_key_iam_binding_role

  members = [
    "serviceAccount:${var.vm_crypto_key_iam_binding_service_account}"
  ]
}

resource "google_kms_crypto_key_iam_binding" "cloud_crypto_key_iam_binding" {
  crypto_key_id = google_kms_crypto_key.cloud_sql_crypto_key.id
  role          = var.crypto_key_iam_binding_role

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}"
  ]
}

data "google_storage_project_service_account" "google_storage_service_account" {
}

resource "google_kms_crypto_key_iam_binding" "cloud_storage_crypto_key_iam_binding" {
  crypto_key_id = google_kms_crypto_key.cloud_storage_crypto_key.id
  role          = var.crypto_key_iam_binding_role

  members = [
    "serviceAccount:${data.google_storage_project_service_account.google_storage_service_account.email_address}"
  ]
}
