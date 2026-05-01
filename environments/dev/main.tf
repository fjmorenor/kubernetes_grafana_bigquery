module "apis" {
  source = "../../modules/apis"
  project_id = var.project_id
  mode = "dev"
}

module "sa_gke_nodes" {
  source = "../../modules/iam"
  project_id = var.project_id
  sa_id = "sa-gke-nodes"
  sa_display_name = "SA para nodos de GKE standard"
  roles = [ 
    "roles/logging.logWriter",       # enviar logs a Cloud Logging
    "roles/monitoring.metricWriter",  # enviar métricas a Cloud Monitoring
    "roles/monitoring.viewer",        # leer métricas
    "roles/storage.objectViewer",
       # leer del bucket de GCS

  ]
  depends_on = [ module.apis ]
}

module "sa_worklad" {
  source = "../../modules/iam"
  project_id = var.project_id
  sa_id = "sa-workload"
  sa_display_name = "Sa para aplicaciones en GKE"
  roles = [ 
    "roles/storage.objectViewer",
    "roles/secretmanager.secretAccessor",  # leer contraseñas de Secret Manager
    "roles/cloudtrace.agent",

   ]
   depends_on = [ module.apis ]
}








module "gke_standard" {
  source = "../../modules/gke-standard"
  project_id = var.project_id
  region = var.region
  cluster_name = "gke-standard-kubernetes"
  host_project_id = var.host_project_id

  vpc_self_link = var.vpc_self_link
  subnet_self_link = var.subnet_standard_self_link

  pods_range_name = "pods-standard"
  services_range_name = "services-standard"


  node_sa_email = module.sa_gke_nodes.email

  machine_type = "e2-medium"
  min_nodes = 1
  max_nodes = 2

  

  depends_on = [ module.sa_gke_nodes ]
}

module "artifact_registry" {
  source     = "../../modules/artifact-registry"
  project_id = "zafa-dev"
  region     = "europe-west1"

  depends_on = [ module.iam ]
}