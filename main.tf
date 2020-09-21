variable "gcp_project" {
    description = "GCP project ID"
    default = "tf-test-290214"
}

variable "image_id" {
  description = "See gcp compute images list"
  default = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
}

provider "google" {
  project = var.gcp_project
  region  = "europe-west2"
  zone    = "europe-west2-b"
}

# this is needed to regenerate vm_id only on image_id variable change
resource "random_id" "vm_name" {
  keepers = {
    image_id = var.image_id
  }
  byte_length = 4
}

resource "google_compute_instance" "front" {
  name         = "front-${lower(random_id.vm_name.hex)}-${count.index}"
  machine_type = "f1-micro"
  count = 3

  tags = ["zero-downtime", "http"]

  boot_disk {
    initialize_params {
      image = var.image_id
    }
  }

  scheduling {
    preemptible = true
    automatic_restart = false
  }

  network_interface {
      network = "default"
      access_config {
    }
  }

  metadata_startup_script = "apt-get update && apt-get install -y apache2"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  # zero-downtime
  lifecycle {
    create_before_destroy = true
  }

}

resource "google_compute_firewall" "fw-http" {
  name    = "firewall-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

resource "google_compute_target_pool" "tp" {
  name = "frontend-pool"

  instances = google_compute_instance.front.*.self_link


  # zero-downtime
  health_checks = [
    google_compute_http_health_check.hc.name
  ]

}

resource "google_compute_http_health_check" "hc" {
  name               = "http-default-healthcheck"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
