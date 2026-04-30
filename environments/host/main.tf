module "apis" {
  source = "../../modules/apis"
  project_id = var.project_id
  mode = "host"
}

# 2. Red (VPC + subnets)
# depends_on garantiza que las APIs estén activas antes de crear recursos
module "network" {
  source     = "../../modules/network"
  project_id = var.project_id
  region     = var.region
  vpc_name   = "vpc-kubernetes"

  subnets = [
    {
      name   = "subnet-gke-standard"
      cidr   = "10.10.0.0/24"
      region = var.region
      secondary_ip_ranges = [
        { range_name = "pods-standard",    ip_cidr_range = "10.20.0.0/16" },
        { range_name = "services-standard", ip_cidr_range = "10.30.0.0/20" },
      ]
    },
 
  ]
  depends_on = [module.apis]
}

  module "firewall" {
    source = "../../modules/firewall"
    project_id = var.project_id
    vpc_name = module.network.vpc_name
    depends_on = [ module.network ]
  }

  module "cloud_nat" {
    source = "../../modules/cloud-nat"
    project_id = var.project_id
    region = var.region
    vpc_name = module.network.vpc_name
    depends_on = [ module.network ]
  }

module "google_compute_shared_vpc" {
  source = "../../modules/shared-vpc"
  host_project_id = var.project_id
  service_project_id = var.dev_project_id
  service_project_number = var.service_project_number
depends_on = [ 
    module.network,
    module.apis
 ]
}