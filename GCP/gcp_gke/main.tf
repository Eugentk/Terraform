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
  vpc_name = "${var.environments}-${var.project_name}"
}
resource "google_compute_network" "vpc" {
  name                            = "${local.vpc_name}-vpc"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

}
resource "google_compute_subnetwork" "private" {
  name                     = "${local.vpc_name}-private"
  ip_cidr_range            = "10.2.0.0/16"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "192.168.64.0/22"
  }
  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = "192.168.1.0/24"
  }
}

resource "google_compute_router" "router" {
  name    = "${local.vpc_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

#-------------------------------------------------------------------------------------------
#                                   GCP-NAT
#-------------------------------------------------------------------------------------------

resource "google_compute_router_nat" "nat" {
  name   = "${local.vpc_name}-nat"
  router = google_compute_router.router.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

}
#-------------------------------------------------------------------------------------------
#                                   GCP-Firewall
#-------------------------------------------------------------------------------------------

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
}
