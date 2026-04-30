variable "project_id" {
    type = string
}

variable "region" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "host_project_id" {
    type = string
}

variable "vpc_self_link" {
    type = string
}

variable "subnet_self_link" {
    type = string
}

variable "node_sa_email" {
    type = string
}

variable "pods_range_name" {
    type = string
}

variable "services_range_name" {
    type = string
}

variable "machine_type" {
    type = string
    default = "e2-medium"
}

variable "min_nodes" {
    type = string
}

variable "max_nodes" {
    type = string
}