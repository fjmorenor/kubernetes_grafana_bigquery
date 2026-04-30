variable "project_id" {
    type = string
}

variable "sa_id" {
    type = string
}

variable "sa_display_name" {
    type = string
}

variable "roles" {
    type = list(string)
    default = [  ]
}