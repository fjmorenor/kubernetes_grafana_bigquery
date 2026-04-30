output "enabled_apis" {
  description = "Lista de APIs que este módulo ha habilitado"
  value       = [for svc in google_project_service.apis : svc.service]
}
