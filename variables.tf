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

variable "my_cloud_function2_all_trafficon_latest_revision" {
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


