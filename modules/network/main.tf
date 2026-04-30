resource "google_compute_network" "vpc" {
  project = var.project_id
  name    = var.vpc_name

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_gke"{
name = "subnet-gke-standard"
project = var.project_id
region = var.region
network = google_compute_network.vpc.id
ip_cidr_range = "10.10.0.0/24"

    secondary_ip_range {
      range_name = "pods-standard"
      ip_cidr_range = "10.20.0.0/16"
    }

    secondary_ip_range {
      range_name = "services-standard"
      ip_cidr_range = "10.30.0.0/20"
    }
}