terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "droplet" {
  image  = var.image
  name   = var.name
  region = var.region
  size   = var.size


  ssh_keys  = var.ssh_keys
  user_data = var.user_data

}

