terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

resource "google_compute_instance" "computevm1" {
  name                      = var.instance_name
  machine_type              = var.machine_type
  zone                      = format("%s-%s", var.region, "a")
  allow_stopping_for_update = true

  tags = ["mongodb"]

  service_account {
    email  = "admin-459@gcp-arch-env.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  metadata = {
    user-data = file("${path.module}/cloud-config.yaml")
  }

  network_interface {
    network    = var.subnetwork
    subnetwork = var.subnetwork
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20211212"
      size  = 20
    }
  }
}

resource "google_storage_bucket" "mongobackup" {

  name = "tasky-mongo-backups"

  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  uniform_bucket_level_access = true
}

data "google_iam_policy" "user" {
  binding {
    role = "roles/storage.objectUser"
    members = [
      "allUsers",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "editor" {
  bucket      = google_storage_bucket.mongobackup.name
  policy_data = data.google_iam_policy.user.policy_data
}
