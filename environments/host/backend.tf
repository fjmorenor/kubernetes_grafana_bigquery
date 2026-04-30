terraform {
  backend "gcs"{
  bucket = "st-state-kubernetes-zafa"
  prefix = "host"
}
}