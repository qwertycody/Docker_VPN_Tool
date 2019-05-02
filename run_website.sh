########################################
### Endpoints to Tunnel To Using VPN ###
########################################

#SSH Listen Port - Destination Address
#Example Below:
#DESTINATION_LIST+=(["2021"]="google.com:80")

declare -A DESTINATION_LIST
DESTINATION_LIST+=(["2021"]="google.com:80")

##################################
### VPN Endpoint to Connect To ###
##################################

OPENCONNECT_VPN_ENDPOINT="vpn.company.com"

########################################
### Local Running Instance of Docker ###
########################################

#If using the Win10 Version of Docker
#LOCAL_DOCKER_ADDRESS="localhost"

#If using the DockerToolbox Version of Docker
LOCAL_DOCKER_ADDRESS="192.168.99.100"

#Desired Port for SSH Server in Docker - Used for Tunnel
LOCAL_DOCKER_SSH_PORT="2020"

#Docker Parameters for Setup, Creation, and Identification
CONTAINER_NAME="vpn_company"
IMAGE_NAME="garrett_tech:vpn_tool"


sh dockerVpnTool.sh $OPENCONNECT_VPN_ENDPOINT $LOCAL_DOCKER_SSH_PORT $CONTAINER_NAME $IMAGE_NAME "$(declare -p DESTINATION_LIST)"
