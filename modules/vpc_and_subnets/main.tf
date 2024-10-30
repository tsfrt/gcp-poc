terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

resource "google_compute_network" "vpc" {
  name        = var.vpc_name
  description = var.vpc_description

  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  description   = var.subnet_description
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.cidrBlock
}

resource "google_compute_firewall" "iap" {
  name    = "iap"
  network = google_compute_network.vpc.self_link

  source_ranges = ["35.235.240.0/20"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "mongo" {
  name          = "mongo"
  network       = google_compute_network.vpc.self_link
  target_tags   = ["mongodb"]
  source_ranges = ["10.100.0.0/14", "10.180.0.0/14"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_router" "router" {
  name    = "nat-router"
  network = google_compute_network.vpc.self_link
  region  = var.region
}

## Create Nat Gateway

resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
