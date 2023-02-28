#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# db.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------

locals {
  sql_instance_name = "${var.environments}-${var.project_name}-db"

  authorized_networks = [
    {
      name            = "allow-all-inbound"
      value           = "0.0.0.0/0"
      expiration_time = "2099-01-01T00:00:00.000Z"
    },
  ]
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.environments}-${var.project_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "db_mysql" {
  name             = local.sql_instance_name
  database_version = var.engine
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.db_engine

    ip_configuration {
      dynamic "authorized_networks" {
        for_each = local.authorized_networks
        content {
          name  = lookup(authorized_networks.value, "name", null)
          value = authorized_networks.value.value
        }
      }
      ipv4_enabled    = true
      private_network = google_compute_network.vpc.id
    }
    backup_configuration {
      enabled    = true
      start_time = "02:00"
    }
    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_track
    }
    disk_size = var.disk_size
    disk_type = var.disk_type
  }
  deletion_protection = "false"
}

resource "google_sql_database" "db" {
  depends_on = [google_sql_database_instance.db_mysql]
  name       = var.db_name
  instance   = local.sql_instance_name
  charset    = "utf8"
  collation  = "utf8_general_ci"
}

resource "google_sql_user" "user" {
  depends_on = [google_sql_database.db]
  name       = var.db_user_name
  instance   = local.sql_instance_name
  host       = "%"
  password   = var.db_password
}
