resource "google_artifact_registry_repository" "heladeria_repo" {
   project = var.project_id
   location = var.location
   repository_id = "heladeria-repo"
   description = "Repositorio para heladeria"
   format = "DOCKER"
    
}
