output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

# Este es el que usaremos para el cluster de Kubernetes
output "subnet_gke_self_link" {
  value = google_compute_subnetwork.subnet_gke.self_link
}