output "repository_id" {
  value = google_artifact_registry_repository.heladeria_repo.repository_id
}

output "repository_url" {
    value = "${google_artifact_registry_repository.heladeria_repo.location}-docker.pkg.dev/${google_artifact_registry_repository.heladeria_repo.project}/${google_artifact_registry_repository.heladeria_repo.repository_id}"
  
}