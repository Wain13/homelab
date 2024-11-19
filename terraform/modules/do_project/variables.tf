variable "name"{
    type = string
}

variable "description" {
    type = string
    default = "A project to represent development resources."
}

variable "purpose" {
    type = string
    default = "web Application"
}

variable "environment" {
    type = string
    default = "dvelopment"
}

variable "resources" {
    type = list(string)
}

variable "is_default" {
    type = bool
    default = false
}