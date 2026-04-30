variable "project_id" {
  description = "The ID of the project in which to enable the APIs."
  type        = string
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
}

variable "vpc_name" {
  type = string
}

variable "subnets" {
  type = list(object({
    name = string
    cidr = string
    region = string
    secondary_ip_ranges = optional(list(object({
      range_name = string
      ip_cidr_range = string
    })))
  }))
}
