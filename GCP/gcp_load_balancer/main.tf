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
#-------------------------------------------------------------------------------
#                                   GCP-VM
#-------------------------------------------------------------------------------

resource "google_compute_instance" "lb_instance" {
  count = var.count_vm
  name         = "terraform-instance-${count.index}"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_latest.self_link
      size = var.disk_size
    }
  }
  metadata_startup_script = <<EOT
curl -fsSL https://get.docker.com -o get-docker.sh &&
sudo sh get-docker.sh &&
sudo service docker start &&
docker run -p 8080:80 -d nginxdemos/hello
EOT

    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
    }
    tags = ["docker"]

  network_interface {
    subnetwork = google_compute_subnetwork.docker-subnetwork.self_link
    access_config {
    nat_ip = element(google_compute_address.docker_ip.*.address, count.index)
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
  name   = "static-ip-${count.index + 1}"
  count = var.count_vm
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
  ip_cidr_range = "10.5.0.0/16"
  region        = var.region
  network       = google_compute_network.docker-network.id
}
#----------------------------------------------------------------------------------
#                                   Firewall VM
#----------------------------------------------------------------------------------

resource "google_compute_firewall" "docker_ingress" {
  name    = "docker-web"
  network = google_compute_network.docker-network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
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
#------------------------------------------------------------------------------------------
#                                  Instance Group
#------------------------------------------------------------------------------------------

resource "google_compute_instance_group" "webservers" {
  name        = "terraform-webservers"
  description = "lb instance group"

  instances = google_compute_instance.lb_instance[*].self_link

  named_port {
    name = "http"
    port = "8080"
  }
}

#------------------------------------------------------------------------------------------
#                                  Health check
#------------------------------------------------------------------------------------------

resource "google_compute_health_check" "webservers-health-check" {
  name        = "webservers-health-check"
  description = "Health check via tcp"

  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 3
  unhealthy_threshold = 2

  tcp_health_check {
    port_name          = "http"
  }
}
#------------------------------------------------------------------------------------------
#                                  Backend Service
#------------------------------------------------------------------------------------------
resource "google_compute_backend_service" "backend-service" {

  name                            = "webservers-backend-service"
  timeout_sec                     = 30
  connection_draining_timeout_sec = 10
  load_balancing_scheme = "EXTERNAL"
  protocol = "HTTP"
  port_name = "http"
  health_checks = [google_compute_health_check.webservers-health-check.self_link]

  backend {
    group = google_compute_instance_group.webservers.self_link
    balancing_mode = "UTILIZATION"
  }
}

#------------------------------------------------------------------------------------------
#                                  URL Map
#------------------------------------------------------------------------------------------
resource "google_compute_url_map" "web" {

  name            = "website-lb"
  default_service = google_compute_backend_service.backend-service.self_link
}

resource "google_compute_target_http_proxy" "website" {

  name    = "website-proxy"
  url_map = google_compute_url_map.web.id
}

resource "google_compute_forwarding_rule" "webservers-loadbalancer" {
  name                  = "website-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = 80
  load_balancing_scheme = "EXTERNAL" # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
  network_tier          = "STANDARD"
  target                = google_compute_target_http_proxy.website.id
}

#------------------------------------------------------------------------------------------
#                                  Load Balancer Firewall
#------------------------------------------------------------------------------------------

data "google_compute_lb_ip_ranges" "ranges" { } # https://cloud.google.com/load-balancing/docs/health-checks#health_check_source_ips_and_firewall_rules

resource "google_compute_firewall" "load_balancer_inbound" {
  name    = "nginx-load-balancer"
  network = google_compute_network.docker-network.self_link

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  # These IP ranges are required for health checks
  source_ranges = data.google_compute_lb_ip_ranges.ranges.network
  target_tags = ["docker"]
}