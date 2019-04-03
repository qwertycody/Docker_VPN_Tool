docker rmi garrett_tech:vpn_tool --force
docker build --rm=true -t garrett_tech:vpn_tool .
docker system prune --force