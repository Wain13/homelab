terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}

locals {
  pub_key = file("${path.module}/public_keys/tf_id_ed25519.pub")
}

resource "digitalocean_droplet" "tuta-server" {
  image  = "ubuntu-24-10-x64"
  name   = "tuta"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  user_data = templatefile("${path.module}/userdata.yml", { publickey = local.pub_key })

}

resource "digitalocean_project" "TUTA" {
  name        = "TUTA"
  description = "Utilities related to TUTA Theatre Company"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [digitalocean_droplet.tuta-server.urn]
}

resource "digitalocean_firewall" "web" {
  name = "SSH"

  droplet_ids = [digitalocean_droplet.tuta-server.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}
