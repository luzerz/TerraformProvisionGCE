# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------
variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
  default = "jobfinder-362313"
}

variable "name_anotation" {
  description = "The name anotation for resource init"
  type = string
  default = "jobtest"
}
variable "location" {
  description = "The location (region or zone)."
  type        = string
  default     = "asia-southeast1"
}

variable "region" {
  description = "The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone."
  type        = string
  default     = "asia-southeast1"
}
variable "zone" {
  description = "The zone specify"
  type        = string
  default     = "asia-southeast1-b"
}

variable "gce_ssh_user" {
  type = string
}
variable "gce_ssh_pub_key_file" {
  type = string
}