resource "google_service_account" "static_sa" {
    
    project = var.project_id
    account_id = var.sa_id
    display_name = var.sa_display_name
}

resource "google_project_iam_member" "asignar_roles" {
  for_each =  toset(var.roles)
  project = var.project_id
  role = each.value

    member = "serviceAccount:${google_service_account.static_sa.email}"
}