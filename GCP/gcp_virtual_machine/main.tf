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
#                                   GCP-VM
#-------------------------------------------------------------------------------------------

resource "google_compute_instance" "docker_instance" {
  name         = var.machine_name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_latest.self_link
      size = var.disk_size
    }
  }
  metadata_startup_script = file("./docker.sh") # Install Docker and docker-compose

    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
    }
    tags = ["docker"]

  network_interface {
    subnetwork = google_compute_subnetwork.docker-subnetwork.self_link
    access_config {
    nat_ip = google_compute_address.docker_ip.address
    }
  }
}

#---------------------------------------------------------------------------------
#                                    AMI
#---------------------------------------------------------------------------------

data "google_compute_image" "ubuntu_latest" {
  project = "ubuntu-os-cloud"
  name = "ubuntu-2204-jammy-v20220528"
}
#----------------------------------------------------------------------------------
#                                  Network address
#----------------------------------------------------------------------------------

resource "google_compute_address" "docker_ip" {
  name   = "server"
  region = var.region
}
#----------------------------------------------------------------------------------
#                                  Network
#----------------------------------------------------------------------------------
resource "google_compute_network" "docker-network" {
  auto_create_subnetworks = false
  name                    = "docker"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" docker-subnetwork {
  name          = "subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.docker-network.id
}
#----------------------------------------------------------------------------------
#                                   Firewall
#----------------------------------------------------------------------------------

resource "google_compute_firewall" "docker_ingress" {
  name    = "docker-web"
  network = google_compute_network.docker-network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "docker_ingress_ssh" {
  name    = "docker-ssh"
  network = google_compute_network.docker-network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}