terraform {
  # forwards compatible with 0.14.x code.
  required_version = ">= 0.12.26"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.72.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.72.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "google" {
  project = var.project
  region  = var.region

  scopes = [
    # Default scopes
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/devstorage.full_control",

    # Required for google_client_openid_userinfo
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

# We use this data provider to expose an access token for communicating with the GKE cluster.
data "google_client_config" "client" {}

# Use this datasource to access the Terraform account's email for Kubernetes permissions.
data "google_client_openid_userinfo" "me" {}
output "my-email" {
  value = data.google_client_openid_userinfo.me.email
}
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A GOOGLE CLOUD INSTANCE
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "e2-small"
  zone         = "asia-southeast1-b"

  tags = ["instance-class-private"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  network_interface {
    network        = "jobtest-network-vpc"
    subnetwork     ="jobtest-private"
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
}

resource "google_compute_instance" "monitoring" {
  name         = "monitoring"
  machine_type = "e2-small"
  zone         = "asia-southeast1-b"

  tags = ["instance-class-private"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  network_interface {
    network        = "jobtest-network-vpc"
    subnetwork     ="jobtest-private"
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
}

resource "google_compute_instance" "gateway" {
  name         = "gatway"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-b"

  tags = ["instance-class-public"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  network_interface {
    network        = "jobtest-network-public-vpc"
    subnetwork     ="jobtest-subnet-public"
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
}


