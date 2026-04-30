output "vpc_self_link" {
  value = module.network.vpc_self_link
}

output "subnet_standard_self_link" {
  value = module.network.subnet_gke_self_link
}

