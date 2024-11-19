variable "image" {
  type    = string
  default = "ubuntu-24-10-x64"
}

variable "name" {
  type = string
}

variable "region" {
  type    = string
  default = "nyc3"
}

variable "size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "ssh_keys" {
  type = list(string)
}

variable "user_data" {
  type = string
}
