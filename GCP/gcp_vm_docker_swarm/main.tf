#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# Main.tf file
#
# Made by y.tkachenko@mobidev.biz
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
  connection {
    type = "ssh"
    user = var.ssh_user
    private_key = file(var.ssh_private_key)
    host = google_compute_address.docker_ip.address
  }
  provisioner "file" {
    source      = "./Ansible"
    destination = "/home/ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible --yes",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/Ansible && ansible-playbook playbook.yml -e @extra_vars.json",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo docker stack deploy -c /home/ubuntu/app/docker-stack.yml app_name",
    ]
  }

  depends_on = [ google_compute_firewall.docker_ingress_ssh, google_compute_firewall.docker_ingress ]

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