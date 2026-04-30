variable "project_id" {
  description = "The ID of the project in which to enable the APIs."
  type        = string
}

variable "mode" {
  description = "Define si el entorno es host (red) o dev (servicios/gke)"
  type        = string
  validation {
    # Solo permite "host" o "dev". Cualquier otro valor da error inmediatamente.
    condition     = contains(["host", "dev"], var.mode)
    error_message = "El valor de mode debe ser obligatoriamente host o dev."
  }
}

variable "extra_apis" {
  type = list(string)
  default = [] #Si no la usas se queda vacía
}
