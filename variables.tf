variable "credentials_file" {
  description = "Path to the Google Cloud credentials file"
  type        = string
}

variable "project_id" {
  description = "The project ID for the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region for the Google Cloud resources."
  type        = string
}

variable "routing_mode" {
  description = "The Route mode for the VPC."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC to be created."
  type        = string
}

variable "subnet_map" {
  description = "Map of subnet names and CIDR blocks"
  type        = map(string)
}

variable "auto_create_subnetworks" {
  description = "Bool value for Auto creation of subnets"
  type        = bool
}

variable "delete_default_routes_on_create" {
  description = "Bool value for deleting the default routes on VPC creation"
  type        = bool
}

variable "dest_range" {
  description = "The destination range."
  type        = string
}

variable "next_hop_gateway" {
  description = "The next hop gateway."
  type        = string
}

variable "zone" {
  description = "Zone for the VM."
  type        = string
}

variable "firewall_allow_port" {
  description = "Firewall Port number."
  type        = list(string)
}

variable "firewall_deny_port" {
  description = "Firewall Port number."
  type        = list(string)
}

variable "firewall_allow_protocol" {
  description = "Firewall allow protocol."
  type        = string
}

variable "firewall_deny_protocol" {
  description = "Firewall deny protocol."
  type        = string
}

variable "tags" {
  description = "Tags."
  type        = list(string)
}

variable "target_tags" {
  description = "Target tags."
  type        = list(string)
}

variable "firewall_description" {
  description = "Description for the Firewall "
  type        = string
}

variable "custom_image_name" {
  description = "Description for the Firewall "
  type        = string
}

variable "firewall_allow_priority" {
  description = "Description for the Firewall rule priority "
  type        = number
}

variable "firewall_deny_priority" {
  description = "Description for the Firewall rule priority "
  type        = number
}

variable "source_ranges" {
  description = "Description for the Firewall rule priority "
  type        = list(string)
}

variable "vm_name" {
  description = "Description for name of the VM "
  type        = string
}

variable "machine_type" {
  description = "Description for machine type "
  type        = string
}

variable "access_config_nat_ip" {
  description = "Description for nat ip"
  type        = string
}

variable "access_config_network_tier" {
  description = "Description for network tier"
  type        = string
}

variable "boot_disk_size" {
  description = "Description for boot disk size"
  type        = number
}

variable "boot_disk_type" {
  description = "Description for boot disk type"
  type        = string
}

variable "boot_disk_auto_delete" {
  description = "Description for boot disk auto delete"
  type        = bool
}

variable "firewall_deny_name" {
  description = "Description for firewall deny name"
  type        = string
}

variable "firewall_allow_name" {
  description = "Description for firewall deny name"
  type        = string
}

variable "cloudSQL_port" {
  description = "mySQL cloud port number"
  type        = number
}

variable "db_user" {
  description = "db user for cloudSQL"
  type        = string
}

variable "db_name" {
  description = "db_name"
  type        = string
}

variable "private_ip_address_name" {
  description = "private_ip_address_name"
  type        = string
}

variable "purpose" {
  description = "purpose"
  type        = string
}

variable "address_type" {
  description = "address_type"
  type        = string
}

variable "prefix_length" {
  description = "prefix_length"
  type        = number
}

variable "private_network_connection_service" {
  description = "private_network_connection_service"
  type        = string
}

variable "my_db_instance_name" {
  description = "my_db_instance_name"
  type        = string
}

variable "database_version" {
  description = "database_version"
  type        = string
}

variable "deletion_protection" {
  description = "deletion_protection"
  type        = bool
}

variable "tier" {
  description = "tier"
  type        = string
}

variable "disk_type" {
  description = "disk_type"
  type        = string
}

variable "disk_size" {
  description = "disk_size"
  type        = number
}

variable "availability_type" {
  description = "availability_type"
  type        = string
}

variable "disk_autoresize" {
  description = "disk_autoresize"
  type        = bool
}

variable "edition" {
  description = "edition"
  type        = string
}

variable "backup_configuration_enabled" {
  description = "backup_configuration_enabled"
  type        = bool
}

variable "backup_configuration_binary_log_enabled" {
  description = "backup_configuration_binary_log_enabled"
  type        = bool
}

variable "ip_configuration_ipv4_enabled" {
  description = "ip_configuration_ipv4_enabled"
  type        = bool
}

variable "db_password_special" {
  description = "db_password_special"
  type        = bool
}

variable "db_password_length" {
  description = "db_password_length"
  type        = number
}

variable "db_password_override_special" {
  description = "db_password_override_special"
  type        = string
}

variable "db_name_suffix_byte_length" {
  description = "db_name_suffix_byte_length"
  type        = number
}

variable "log_File_Path" {
  description = "log_File_Path"
  type        = string
}

variable "domain_name" {
  description = "domain_name"
  type        = string
}

variable "a_record_type" {
  description = "a_record_type"
  type        = string
}

variable "a_record_ttl" {
  description = "a_record_ttl"
  type        = number
}

variable "a_record_managed_zone" {
  description = "a_record_managed_zone"
  type        = string
}

variable "sa_account_id" {
  description = "sa_account_id"
  type        = string
}

variable "sa_display_name" {
  description = "sa_display_name"
  type        = string
}

variable "logging_admin_binding_role" {
  description = "logging_admin_binding_role"
  type        = string
}

variable "monitoring_metric_writer_binding_role" {
  description = "monitoring_metric_writer_binding_role"
  type        = string
}

variable "service_account_scope" {
  description = "service_account_scope"
  type        = list(string)
}

variable "pubsub_pulisher_binding_role" {
  description = "Role for Pub/Sub publisher binding"
  type        = string
}

variable "topic_name" {
  description = "Name of the Pub/Sub topic"
  type        = string
}

variable "topic_message_retention_duration" {
  description = "Duration for retaining Pub/Sub topic messages"
  type        = string
}

variable "subscription_name" {
  description = "Name of the Pub/Sub subscription"
  type        = string
}

variable "subscription_ack_deadline_seconds" {
  description = "Acknowledgement deadline for Pub/Sub subscription"
  type        = number
}

variable "subscription_message_retention_duration" {
  description = "Duration for retaining Pub/Sub subscription messages"
  type        = string
}

variable "subscription_retry_policy_minimum_backoff" {
  description = "Minimum backoff duration for Pub/Sub subscription retry policy"
  type        = string
}

variable "subscription_retry_policy_maximum_backoff" {
  description = "Maximum backoff duration for Pub/Sub subscription retry policy"
  type        = string
}

variable "my_cloud_function2_name" {
  description = "Name of the Cloud Function"
  type        = string
}

variable "my_cloud_function2_description" {
  description = "Description of the Cloud Function"
  type        = string
}

variable "my_cloud_function2_build_config_runtime" {
  description = "Runtime environment for the Cloud Function"
  type        = string
}

variable "my_cloud_function2_build_config_entry_point" {
  description = "Entry point for the Cloud Function"
  type        = string
}

variable "my_cloud_function2_storage_source_bucket" {
  description = "Source bucket for the Cloud Function code"
  type        = string
}

variable "my_cloud_function2_storage_source_object" {
  description = "Source object for the Cloud Function code"
  type        = string
}

variable "my_cloud_function2_service_config_max_instance_count" {
  description = "Maximum number of instances for the Cloud Function"
  type        = number
}

variable "my_cloud_function2_service_config_min_instance_count" {
  description = "Minimum number of instances for the Cloud Function"
  type        = number
}

variable "my_cloud_function2_service_config_available_memory" {
  description = "Memory available to the Cloud Function instance"
  type        = string
}

variable "my_cloud_function2_service_config_available_cpu" {
  description = "CPU available to the Cloud Function instance"
  type        = number
}

variable "my_cloud_function2_service_config_timeout_seconds" {
  description = "Timeout duration for the Cloud Function"
  type        = number
}

variable "my_cloud_function2_service_config_PRIVATE_API_KEY" {
  description = "Private API key for the Cloud Function"
  type        = string
}

variable "my_cloud_function2_service_config_DOMAIN" {
  description = "Domain for the Cloud Function"
  type        = string
}

variable "my_cloud_function2_service_config_SUB_DOMAIN" {
  description = "Sub-domain for the Cloud Function"
  type        = string
}

variable "my_cloud_function2_service_config_TABLE_NAME" {
  description = "Table name for the Cloud Function"
  type        = string
}

variable "my_cloud_function2_ingress_settings" {
  description = "Ingress settings for the Cloud Function"
  type        = string
}

variable "my_cloud_function2_all_traffic_on_latest_revision" {
  description = "Enable traffic on the latest revision for the Cloud Function"
  type        = bool
}

variable "my_cloud_function2_event_trigger_event_type" {
  description = "Event type for triggering the Cloud Function"
  type        = string
}

variable "my_cloud_function2_event_trigger_retry_policy" {
  description = "Retry policy for the Cloud Function event trigger"
  type        = string
}

variable "cloud_function_service_account_account_id" {
  description = "Account ID for the Cloud Function service account"
  type        = string
}

variable "cloud_function_service_account_display_name" {
  description = "Display name for the Cloud Function service account"
  type        = string
}

variable "pubsub_token_creator_iam_binding_role" {
  description = "Role for Pub/Sub token creator IAM binding"
  type        = string
}

variable "cloud_function_invoker_iam_binding_role" {
  description = "Role for Cloud Function invoker IAM binding"
  type        = string
}

variable "cloud_sql_client_iam_binding_role" {
  description = "Role for Cloud SQL client IAM binding"
  type        = string
}

variable "serverless_vpc_connector_name" {
  description = "Name of the serverless VPC connector"
  type        = string
}

variable "serverless_vpc_connector_ip_cidr_range" {
  description = "IP CIDR range for the serverless VPC connector"
  type        = string
}

variable "firewall_for_health_check_name" {
  type        = string
  description = "Name for the firewall rule for health check"
}

variable "firewall_for_health_check_description" {
  type        = string
  description = "Description for the firewall rule for health check"
}

variable "firewall_for_health_check_direction" {
  type        = string
  description = "Direction for the firewall rule for health check"
}

variable "firewall_for_health_check_protocol" {
  type        = string
  description = "Protocol for the firewall rule for health check"
}

variable "firewall_for_health_check_ports" {
  type        = list(number)
  description = "Ports for the firewall rule for health check"
}

variable "firewall_for_health_check_priority" {
  type        = number
  description = "Priority for the firewall rule for health check"
}

variable "firewall_for_health_check_source_ranges" {
  type        = list(string)
  description = "Source ranges for the firewall rule for health check"
}

variable "firewall_for_health_check_target_tags" {
  type        = list(string)
  description = "Target tags for the firewall rule for health check"
}

variable "my_vm_instance_template_name" {
  type        = string
  description = "Name for the VM instance template"
}

variable "my_vm_instance_template_description" {
  type        = string
  description = "Description for the VM instance template"
}

variable "my_http_health_check_name" {
  type        = string
  description = "Name for the HTTP health check"
}

variable "my_http_health_check_description" {
  type        = string
  description = "Description for the HTTP health check"
}

variable "http_health_check_port" {
  type        = number
  description = "Port for the HTTP health check"
}

variable "http_health_check_port_specification" {
  type        = string
  description = "Port specification for the HTTP health check"
}

variable "http_health_check_request_path" {
  type        = string
  description = "Request path for the HTTP health check"
}

variable "http_health_check_proxy_header" {
  type        = string
  description = "Proxy header for the HTTP health check"
}

variable "my_instance_group_manager_name" {
  type        = string
  description = "Name for the instance group manager"
}

variable "my_instance_group_manager_distribution_policy_zones" {
  type        = list(string)
  description = "Zones for the instance group manager distribution policy"
}

variable "my_instance_group_manager_distribution_policy_target_shape" {
  type        = string
  description = "Target shape for the instance group manager distribution policy"
}

variable "my_instance_group_manager_named_port_name" {
  type        = string
  description = "Named port name for the instance group manager"
}

variable "my_instance_group_manager_named_port_port" {
  type        = number
  description = "Named port port for the instance group manager"
}

variable "my_autoscaler_name" {
  type        = string
  description = "Name for the autoscaler"
}

variable "lb_global_address_name" {
  type        = string
  description = "Name for the global address"
}

variable "lb_global_address_ip_version" {
  type        = string
  description = "IP version for the global address"
}

variable "lb_backend_service_name" {
  type        = string
  description = "Name for the backend service"
}

variable "lb_backend_service_load_balancing_scheme" {
  type        = string
  description = "Load balancing scheme for the backend service"
}

variable "lb_backend_service_port_name" {
  type        = string
  description = "Port name for the backend service"
}

variable "lb_backend_service_protocol" {
  type        = string
  description = "Protocol for the backend service"
}

variable "lb_backend_service_session_affinity" {
  type        = string
  description = "Session affinity for the backend service"
}

variable "lb_backend_service_timeout_sec" {
  type        = number
  description = "Timeout in seconds for the backend service"
}

variable "lb_backend_service_enable_cdn" {
  type        = bool
  description = "Enable CDN for the backend service"
}

variable "lb_backend_service_backend_balancing_mode" {
  type        = string
  description = "Backend balancing mode for the backend service"
}

variable "lb_backend_service_capacity_scaler" {
  type        = number
  description = "Capacity scaler for the backend service"
}

variable "lb_backend_service_log_config_enable" {
  type        = bool
  description = "Enable logging for the backend service"
}

variable "lb_backend_service_log_config_sample_rate" {
  type        = number
  description = "Log sample rate for the backend service"
}

variable "my_instance_group_manager_auto_healing_policies_initial_delay_sec" {
  type        = number
  description = "Initial delay in seconds for auto healing policies of the instance group manager"
}

variable "labels_environment" {
  type        = string
  description = "Environment label"
}

variable "my_vm_instance_template_boot" {
  type        = bool
  description = "Boot configuration for VM instance template"
}

variable "my_http_health_check_timeout_sec" {
  type        = number
  description = "Timeout in seconds for the HTTP health check"
}

variable "my_http_health_check_check_interval_sec" {
  type        = number
  description = "Check interval in seconds for the HTTP health check"
}

variable "my_http_health_check_healthy_threshold" {
  type        = number
  description = "Healthy threshold for the HTTP health check"
}

variable "my_http_health_check_unhealthy_threshold" {
  type        = number
  description = "Unhealthy threshold for the HTTP health check"
}

variable "my_autoscaler_autoscaling_policy_min_replicas" {
  type        = number
  description = "Minimum replicas for the autoscaling policy"
}

variable "my_autoscaler_autoscaling_policy_max_replicas" {
  type        = number
  description = "Maximum replicas for the autoscaling policy"
}

variable "my_autoscaler_autoscaling_policy_cooldown_period" {
  type        = number
  description = "Cooldown period in seconds for the autoscaling policy"
}

variable "my_autoscaler_cpu_utilization_target" {
  type        = number
  description = "CPU utilization target for the autoscaler"
}

variable "lb_backend_service_connection_draining_timeout_sec" {
  type        = number
  description = "Connection draining timeout in seconds for the backend service"
}

variable "lb_url_map_name" {
  type        = string
  description = "Name for the URL map"
}

variable "lb_target_https_proxy_name" {
  type        = string
  description = "Name for the target HTTPS proxy"
}

variable "lb_managed_ssl_certificate_name" {
  type        = string
  description = "Name for the managed SSL certificate"
}

variable "lb_managed_ssl_certificate_managed_domains" {
  type        = list(string)
  description = "Domains for the managed SSL certificate"
}

variable "lb_global_forwarding_rule_name" {
  type        = string
  description = "Name for the global forwarding rule"
}

variable "lb_global_forwarding_rule_ip_protocol" {
  type        = string
  description = "IP protocol for the global forwarding rule"
}

variable "lb_global_forwarding_rule_load_balancing_scheme" {
  type        = string
  description = "Load balancing scheme for the global forwarding rule"
}

variable "lb_global_forwarding_rule_port_range" {
  type        = string
  description = "Port range for the global forwarding rule"
}

variable "key_ring_name_suffix_byte_length" {
  type        = number
  description = "Suffix byte length for the key ring name"
}

variable "cloud_storage_bucket_name" {
  type        = string
  description = "Name of the cloud storage bucket"
}

variable "cloud_storage_bucket_force_destroy" {
  type        = bool
  description = "Whether to force destroy the cloud storage bucket"
}

variable "cloud_storage_bucket_public_access_prevention" {
  type        = string
  description = "Prevention mode for public access to the cloud storage bucket"
}

variable "cloud_storage_bucket_object_name" {
  type        = string
  description = "Name of the cloud storage bucket object"
}

variable "cloud_storage_bucket_object_source" {
  type        = string
  description = "Source of the cloud storage bucket object"
}

variable "storage_bucket_iam_binding_role" {
  type        = string
  description = "IAM role binding for the storage bucket"
}

variable "my_key_ring_name" {
  type        = string
  description = "Name of the key ring"
}

variable "vm_crypto_key_name" {
  type        = string
  description = "Name of the VM crypto key"
}

variable "crypto_key_rotation_period" {
  type        = string
  description = "Rotation period for the crypto key"
}

variable "crypto_key_purpose" {
  type        = string
  description = "Purpose of the crypto key"
}

variable "lifecycle_prevent_destroy" {
  type        = bool
  description = "Whether to prevent destruction during the lifecycle"
}

variable "cloud_sql_crypto_key_name" {
  type        = string
  description = "Name of the Cloud SQL crypto key"
}

variable "cloud_storage_crypto_key_name" {
  type        = string
  description = "Name of the Cloud Storage crypto key"
}

variable "gcp_sa_cloud_sql_service" {
  type        = string
  description = "Service for the GCP SA Cloud SQL"
}

variable "crypto_key_iam_binding_role" {
  type        = string
  description = "IAM role binding for the crypto key"
}

variable "vm_crypto_key_iam_binding_service_account" {
  type        = string
  description = "IAM binding for the VM crypto key service account"
}




