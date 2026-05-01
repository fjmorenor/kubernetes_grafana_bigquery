resource "google_container_cluster" "standard" {
    name = var.cluster_name
    project = var.project_id
    provider = google-beta

    location = var.region
    network = var.vpc_self_link
    subnetwork = var.subnet_self_link

    networking_mode = "VPC_NATIVE"
    ip_allocation_policy {
      cluster_secondary_range_name = var.pods_range_name
      services_secondary_range_name = var.services_range_name
    }

    remove_default_node_pool = true
    initial_node_count = 1

    private_cluster_config {
      enable_private_nodes = true
      enable_private_endpoint = false
      master_ipv4_cidr_block = "172.16.0.0/28"

    }

    release_channel {
      channel = "REGULAR"
    }
    
    deletion_protection = false

    
}


resource "google_container_node_pool" "nodes" {
    name       = "${var.cluster_name}-pool"
    project    = var.project_id
    location   = var.region
    cluster    = google_container_cluster.standard.name # Referencia directa

    # Esta dependencia asegura que el clúster esté listo antes de crear el pool
    depends_on = [google_container_cluster.standard]

    autoscaling {
      min_node_count = var.min_nodes
      max_node_count = var.max_nodes
    }

    management {
      auto_repair  = true
      auto_upgrade = true
    }

    node_config {
      machine_type    = var.machine_type
      service_account = var.node_sa_email
      # Los discos se configuran aquí ahora
      disk_size_gb    = 20
      disk_type       = "pd-standard"
      oauth_scopes    = [ "https://www.googleapis.com/auth/cloud-platform" ]
    }
}