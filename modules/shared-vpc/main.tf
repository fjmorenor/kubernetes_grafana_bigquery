resource "google_compute_shared_vpc_host_project" "host" {
    project = var.host_project_id
    
}

resource "google_compute_shared_vpc_service_project" "dev" {
    host_project = google_compute_shared_vpc_host_project.host.project
    service_project = var.service_project_id

}

resource "google_project_iam_member" "gke_service_agent" {
    project = var.host_project_id
    role = "roles/compute.networkUser"
    member = "serviceAccount:service-${var.service_project_number}@container-engine-robot.iam.gserviceaccount.com"

    depends_on = [ google_compute_shared_vpc_service_project.dev ]
    
}

resource "google_project_iam_member" "cloud_services_agent" {
    project = var.host_project_id
    role = "roles/compute.networkUser"
    member = "serviceAccount:${var.service_project_number}@cloudservices.gserviceaccount.com"

    depends_on = [ google_compute_shared_vpc_service_project.dev ]
    
}

# 3. Permiso Host Service Agent (Obligatorio para GKE en Shared VPC)
resource "google_project_iam_member" "gke_host_agent" {
  project = var.host_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:service-${var.service_project_number}@container-engine-robot.iam.gserviceaccount.com"

  depends_on = [google_compute_shared_vpc_service_project.dev]
}

