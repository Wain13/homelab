# Archive meeting recordings from zoom to google drive

This project will ultimately run for TUTA theatre company.

The end goal is a containerized webhook function hosted on a digitalocean droplet that will automatically move completed zoom meeting recordings from zoom servers to the company google drive.  

Zoom has limited storage space for meeting recordings and several company admin users aren't familiar with wokring on the back end of zoom. Automatic meeting archival to google drive will eliminate automamted "out of space" warning messages from zoom servers, and will simplify the cleanup and tagging of meetings by admins.

## implementation

Stack is the following:
  
- Python/Flask
- Gunicorn
- Nginx
- Certbot
- Docker/Podman
- Logrotate

Details:

- DigitalOcean droplet for hosting the application
- GCP for creating a google service account that can access google drive API within the company google workspace
  - this usage should fall entierly under the free tier from GCP
    - need to implement monitoring in case of bugs or malicious actors
- applilcation stack containerized with docker or podman depending on licensing
- Python/Flask for the functionality
- Gunicorn server to host
  - This allows later extensibility for future projects and gets off of the default built-in DEV server from Flask (not recommended for production purposes)
- NGINX for ingress/gateway/reverse proxy
  - SSL connections only, reroute any messages on port 80 to HTTPS 443
  - Lets Encrypt for certificates
  - Certbot to manage certificates
- limited local file logging
  - TTL for logs doesn't need to be more than a week
  - Logrotate on a cron job to clean up
- Notification emails via gmail API
- DigitalOcean(DO) small/tiny droplet server
  - Terraform setup for droplet
    - docker/podman
    - Python/Gunicorn/Nginx all containers on same server
      - Docker compose file
      - possible ddclient container as well for ddns in the future
    - 22/80/443 open on firewall
    - ssh-keygen for admin user (me)/public ssh key/personal access token from DO for terraform
      - Done manually, no token for TF means no way to run TF
      - Currently I will be the only user with admin access to the server
- secrets as container-local env variables/mounted variable file
  - Added manually over SSH by admin user for the time-being
  
Hoping to be able to chunk/stream the download and upload process synchronously so that storing the entire file locally on the droplet server is unnecessary. This will allow lower costs for space, depending on meeting file sizes.
  
### Plan of attack

- Python flask app listening on webhook **(done)**
  - just recording HTTP POST messages into a redis cache and sending them back out on HTTP GET for testing and verifying messages. Running on flask built-in DEV server. **(done)**
- migrate above to a container and confirm functionality
- Configure https/certbot image with LetsEncrypt
- Set up Zoom application
  - webhook only
  - manually update secrets directly on root via ssh
- update processing POST message
  - automate connecting to zoom server and pulling file metadata
- TEST zoom meeting recording
- Set up GCP service account
  - access rights to google drive api
- Set up Google workspace application
- TEST writing file to google drive via python
- add synchronous chunking download/upload from zoom to google drive
- TEST with zoom meeting
- Add Nginx, move exposed 80/443 from python container to nginx
  - update certbot
- add gunicorn to the python/flask image and remove flask DEV server
- END to END test

### Things to think about/research

- Access key/secret rotation in zoom and GCP, how to automate updates to the system
