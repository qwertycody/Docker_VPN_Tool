OPENCONNECT_VPN_ENDPOINT=$1
DESTINATION_ADDRESS=$2
DESTINATION_PORT=$3

LOCAL_DOCKER_ADDRESS=$4
LOCAL_DOCKER_SSH_PORT=$5
LOCAL_LISTEN_PORT=$6

CONTAINER_NAME=$7
IMAGE_NAME=$8

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

PORT_SSH="$LOCAL_DOCKER_SSH_PORT:22"

docker run -d --privileged --rm --name $CONTAINER_NAME -p $PORT_SSH $IMAGE_NAME

clear 

echo "##################################################################"
echo "THE NEXT PROMPT WILL ASK YOU TO ENTER A FEW THINGS"
echo "ONCE YOU ARE FULLY CONNECTED TO THE VPN ENDPOINT"
echo "PRESS CTRL+A+D TO DETACH AND CONTINUE THE CONNECTION PROCESS"
echo "IF YOU UNDERSTAND THESE INSTRUCTIONS PRESS ENTER TO CONTINUE"
echo "##################################################################"

read 

if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    winpty docker exec -it $CONTAINER_NAME bash -c "screen openconnect $OPENCONNECT_VPN_ENDPOINT --script \"vpn-slice $DESTINATION_ADDRESS\""
else 
    docker exec -it $CONTAINER_NAME bash -c "screen openconnect $OPENCONNECT_VPN_ENDPOINT --script \"vpn-slice $DESTINATION_ADDRESS\""
fi

ssh-keygen -R [$LOCAL_DOCKER_ADDRESS]:$LOCAL_DOCKER_SSH_PORT
ssh -fNL $LOCAL_LISTEN_PORT:$DESTINATION_ADDRESS:$DESTINATION_PORT -l root $LOCAL_DOCKER_ADDRESS -p $LOCAL_DOCKER_SSH_PORT

echo "##################################################################"
echo "If there are no errors up to this point you can now connect"
echo "to the endpoint using localhost:$LOCAL_LISTEN_PORT using ssh/rdp"
echo "##################################################################"