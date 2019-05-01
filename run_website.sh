########################################
### Endpoints to Tunnel To Using VPN ###
########################################

#SSH Listen Port - Destination Address
#Example Below:
#DESTINATION_LIST+=(["2021"]="google.com:80")

declare -A DESTINATION_LIST
DESTINATION_LIST+=(["2021"]="google.com:80")
DESTINATION_LIST+=(["2022"]="google.com:80")

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

##################################
### VPN Endpoint to Connect To ###
##################################

sh dockerVpnTool.sh $OPENCONNECT_VPN_ENDPOINT $LOCAL_DOCKER_SSH_PORT $CONTAINER_NAME $IMAGE_NAME

for LOCAL_LISTEN_PORT in "${!DESTINATION_LIST[@]}"
do
    #Pull Values from Array
    DESTINATION_ADDRESS_DESTINATION_PORT=${DESTINATION_LIST[$LOCAL_LISTEN_PORT]}

    echo "Establishing Tunnel to $DESTINATION_ADDRESS_DESTINATION_PORT using Local Port $LOCAL_LISTEN_PORT"

    #Linux
    ssh-keygen -R [$LOCAL_DOCKER_ADDRESS]:$LOCAL_DOCKER_SSH_PORT
    ssh -o StrictHostKeyChecking=no -fNL $LOCAL_LISTEN_PORT:$DESTINATION_ADDRESS_DESTINATION_PORT -l root $LOCAL_DOCKER_ADDRESS -p $LOCAL_DOCKER_SSH_PORT

    #Windows - Comment Linux Lines Above 
    #nohup "/c/Program Files/PuTTY/plink.exe" -N -L $LOCAL_LISTEN_PORT:$DESTINATION_ADDRESS_DESTINATION_PORT -ssh root@$LOCAL_DOCKER_ADDRESS -P $LOCAL_DOCKER_SSH_PORT -pw password >/dev/null 2>&1 &

    echo ""
    echo "##################################################################"
    echo "If there are no errors up to this point you can now connect"
    echo "to the endpoint using localhost:$LOCAL_LISTEN_PORT using ssh/rdp"
    echo "##################################################################"
    echo ""
done

read
