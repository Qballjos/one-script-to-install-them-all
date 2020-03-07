### Docker Mediaserver installer

This image is made for Ubuntu but can be modified to work on Debian.

This wil install Docker and linux Cockpit on your system, al other apps are docker's.

Pull the installer to your server and create a folder :
`sudo git clone https://github.com/Qballjos/one-script-to-install-them-all.git /media-docker/ && cd /media-docker/`


Edit the `.env` file with the correct info  get your plex claim code at https://www.plex.tv/claim/  
You can change the subdomain name's by changing the variable `traefik.frontend.rule=Host:` in the `docker-compose.yml`  
If you want to run this installer on Ubuntu change the docker adres in docker-compose.yml.

Make the deploy.sh executable with: `chmod +x ./deploy.sh`   
Now run it with: `./deplot.sh`

You can edit the docker-compose.yml to add or remove apps but these apps are included:

| service | purpose | url / ports |
| ------- | ------- | :---------: |
| Jellyfin | movie / tv / music interface | https://plex.${DOMAIN} <br> :8096 |
| Organizr V2 | dashboard | https://controle.${DOMAIN} |
| Qbittorrent VPN | torrent download | https://download.${DOMAIN} |
| Jackett | torznab searcher | https://index.${DOMAIN} |
| Sonarr | tv management | https://tv.${DOMAIN} |
| Radarr | movie management | https://film.${DOMAIN} |
| Lidarr | music management | https://muziek.${DOMAIN} |
| Cockpit | server statistics & management | :9090 |
| Portainer | Docker container installation & management | https://portainer.${DOMAIN} |
| Watchtower | Docker container updater | none |
| Letsencrypt | Docker container updater | none |

