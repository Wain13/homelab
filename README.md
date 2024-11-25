# homelab
home lab testing/network build

## scripts

Various Bash scripts

## tuta

Projects related to TUTA Theatre Chicago

- meeting-archiver
  - webhook invoked api to move [Zoom](http://zoom.us) meeting recordings from Zoom's servers to the company google drive

## terraform

- Custom terraform modules and related code

## .ips

Folder storing public ip addresses for ssh into remote servers procured by terraform

Currently the [terraform module](terraform/modules/do_droplet/) requisitions droplet servers from DigitalOcean. The public ipv4 address is stored in a text file named after the server in **/.ips**. This is used by the [dossh](scripts/dossh) (DigitalOcean SSH) script in order to make sure the correct private key is added to the current user session (ssh-add), and to connect with a username argument (or root) to the server ip.
