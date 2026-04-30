# locals{} son variables internas, solo visibles dentro de este fichero.
locals {
  apis_common = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]


 # APIs solo para el proyecto HOST (gestiona la red)
 apis_host = [
  "container.googleapis.com",
  "servicenetworking.googleapis.com",
  "dns.googleapis.com",
  "networkmanagement.googleapis.com",
  "container.googleapis.com",
 ] 

 #APIs solo para el proyecto DEV (ejecuta Kubernetes)
 apis_dev = [
  "container.googleapis.com",
  "artifactregistry.googleapis.com",
  "autoscaling.googleapis.com",
  "secretmanager.googleapis.com",
  "cloudtrace.googleapis.com",
  "networkmanagement.googleapis.com",
  "logging.googleapis.com",
 ]

 # LISTA FINAL: junta las comunes + las del modo elegido + las extras
  # distinct() elimina duplicados por si una API aparece en dos listas
apis_to_enable = distinct(concat(
  local.apis_common,
  var.mode == "host" ? local.apis_host : local.apis_dev,
  var.extra_apis,
))

}

# ----- ACCIÓN EN GCP -----
# for_each lee la lista y crea UN recurso por cada API
resource "google_project_service" "apis" {
for_each = toset(local.apis_to_enable)

project = var.project_id
service = each.value

disable_on_destroy = false

}

