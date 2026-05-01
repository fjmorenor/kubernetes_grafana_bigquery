# =========================================================================================
# CONFIGURACIÓN DE PROVIDERS (LAS "LLAVES" PARA ENTRAR EN LOS PROYECTOS)
# =========================================================================================

# Define la conexión por defecto. Todo lo que no tenga un "alias" se creará en 'zafa-dev'.
provider "google" {
  project = "zafa-dev"      # Este es el proyecto "hijo" donde nacerá nuestra cuenta de servicio.
  region  = "europe-west1"  # Define la ubicación física de los recursos (Bélgica).
}

# Define una conexión alternativa para el proyecto de infraestructura central.
provider "google" {
  alias   = "host"          # Le ponemos un apodo ("host") para invocarlo cuando lo necesitemos.
  project = "zafa-host"     # Este es el proyecto "padre" donde están el Bucket de estado y las redes.
  region  = "europe-west1"  # Mantenemos la misma región para evitar latencia.
}

# =========================================================================================
# CREACIÓN DE LA IDENTIDAD (EL "USUARIO" QUE USARÁ GITHUB)
# =========================================================================================

# Llamamos a tu módulo de IAM para crear la Service Account en el proyecto DEV.
module "sa_github" {
  source          = "../modules/iam"              # Localización de tus archivos de lógica de IAM.
  project_id      = "zafa-dev"                    # Forzamos que la identidad se cree físicamente en DEV.
  sa_id           = "sa-github"                   # Nombre técnico de la cuenta (ID único).
  sa_display_name = "Service Account para GitHub" # Nombre descriptivo para verlo en la consola de Google.
  
  # Estos roles se aplican SOLAMENTE dentro del proyecto 'zafa-dev'.
  roles = [ 
    "roles/container.admin",                # Permite gestionar clústeres de Kubernetes (GKE) en DEV.
    "roles/compute.networkAdmin",           # Permite configurar firewalls y subredes locales en DEV.
    "roles/storage.admin",                  # Permite guardar archivos en los Buckets de DEV.
    "roles/iam.serviceAccountUser",         # Permite "actuar como" otras cuentas (necesario para GKE).
    "roles/resourcemanager.projectIamAdmin" # Permite que GitHub asigne permisos a otros componentes en DEV.
  ]
}

# =========================================================================================
# PERMISOS CROSS-PROJECT (DARLE "LLAVES" DE LA OTRA CASA)
# =========================================================================================

# Este recurso le dice al proyecto HOST que permita que la cuenta de DEV maneje el Storage.
resource "google_project_iam_member" "host_storage_access" {
  provider = google.host                     # ¡IMPORTANTE! Usamos el alias para que esta orden se ejecute en 'zafa-host'.
  project  = "zafa-host"                    # El proyecto donde se aplica el permiso.
  role     = "roles/storage.admin"           # Permiso total sobre Buckets. ESTO ARREGLA EL ERROR 403 DEL LOCK.
  # Concatenamos el email de la cuenta creada arriba para darle el acceso.
  member   = "serviceAccount:${module.sa_github.email}" 

    depends_on = [ module.sa_github ]
}

# Este recurso permite que la cuenta de DEV gestione redes en el proyecto HOST.
resource "google_project_iam_member" "host_network_access" {
  provider = google.host                     # Volvemos a usar el alias para actuar sobre 'zafa-host'.
  project  = "zafa-host"                    # El proyecto donde reside la red principal (Shared VPC).
  role     = "roles/compute.networkAdmin"    # Permiso para conectar el GKE de DEV a la red de HOST.
  member   = "serviceAccount:${module.sa_github.email}"
}