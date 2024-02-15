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

