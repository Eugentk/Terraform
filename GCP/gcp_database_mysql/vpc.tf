#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# vpc.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

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

resource "google_compute_firewall" "db_connect" {
  name = "allow-db-connect"

  allow {
    ports    = ["3306"]
    protocol = "tcp"
  }
  direction = "INGRESS"
  network   = google_compute_network.vpc.name
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-db"] # Allow traffic from everywhere to instances with an allow-db tag
}

