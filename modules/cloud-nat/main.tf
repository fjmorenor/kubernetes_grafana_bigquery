resource "google_compute_router" "router" {
    name = "router-kubernetes"
    project = var.project_id
    region = var.region
    network = var.vpc_name
    
}

resource "google_compute_router_nat" "router_nat" {
    name = "nat-kubernetes"
    project = var.project_id
    router = google_compute_router.router.name
    region = var.region

    nat_ip_allocate_option = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}