#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# Main.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
#-------------------------------------------------------------------------------------------
#                                   GCP-VPC
#-------------------------------------------------------------------------------------------

locals {
  vpc_name = "${var.environments}-${var.project_name}-vpc"
}

resource "google_compute_network" "vpc" {
  name                    = local.vpc_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "public" {
  name          = "${local.vpc_name}-public"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.20.0.0/24"
}

resource "google_compute_subnetwork" "private" {
  name                     = "${local.vpc_name}-private"
  region                   = var.region
  private_ip_google_access = true
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = "10.20.1.0/24"
}

#-------------------------------------------------------------------------------------------
#                                   GCP-Firewall
#-------------------------------------------------------------------------------------------

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc.name
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"] # Allow traffic from everywhere to instances with an allow-ssh tag
}

resource "google_compute_firewall" "http-server" {
  name    = "allow-web"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-web"] # Allow traffic from everywhere to instances with an allow-web tag
}