terraform {
  backend "gcs" {
    bucket = "st-state-kubernetes-zafa"  # mismo bucket
    prefix = "dev"                          # distinta carpeta
  }
}
