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
