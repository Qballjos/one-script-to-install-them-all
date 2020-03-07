### Docker Mediaserver installer

This image should work on debian and ubuntu based systems.

This wil install Docker and linux Cockpit on your system, al other apps are docker's.

Pull the installer to your server and create a folder :
`sudo git clone https://github.com/Qballjos/one-script-to-install-them-all.git /media-docker/ && cd /media-docker/`

Edit the `.env` file with the correct info before running the script!

Make the deploy.sh executable with: `chmod +x ./deploy.sh`   
Now run it with: `./deplot.sh`

You can edit the docker-compose.yml to add or remove apps but these apps are included:

| service | purpose | url / ports |
| ------- | ------- | :---------: |
| Jellyfin | movie / tv / music interface | https://media.${DOMAIN}  |
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

I Still need to generate the subdomain configs for the letsencrypt container

