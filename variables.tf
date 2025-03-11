variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where VM instances will be created"
  default     = "us-central1-a"
}

variable "backend_instance_count" {
  description = "Number of backend instances to create"
  default     = 2
}

variable "ssl_certificate" {
  description = "Path to the SSL certificate"
  type        = string
}

variable "ssl_private_key" {
  description = "Path to the SSL private key"
  type        = string
}

variable "google_credentials_file" {
  description = "Path to the GCP service account JSON key file"
  type        = string
}
