data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}

locals {
  pub_key = file("${path.module}/public_keys/tf_id_ed25519.pub")
}

module "digitalocean_droplet" {
  source = "../../terraform/modules/do_droplet"

  image  = "ubuntu-24-10-x64"
  name   = "tuta"
  region = "nyc3"

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  user_data = templatefile("${path.module}/userdata.yml", { publickey = local.pub_key })

}

module "digitalocean_project" {
  source = "../../terraform/modules/do_project"
  
  name        = "TUTA"
  description = "Utilities related to TUTA Theatre Company"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [module.digitalocean_droplet.urn]
}

resource "digitalocean_firewall" "web" {
  name = "SSH"

  droplet_ids = [module.digitalocean_droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "local_file" "ipv4" {
  content = module.digitalocean_droplet.ipv4_address
  filename = "${path.module}/../../.ips/tuta"
}