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
# While our app will only be listening for HTTPS, we need 80 open for apt installs. 
# Will use nginx to reroute to 80 to 443 once everything is up and running.

  name = "HTTP-HTTPS-SSH"

  droplet_ids = [module.digitalocean_droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}
