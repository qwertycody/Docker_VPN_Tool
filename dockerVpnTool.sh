OPENCONNECT_VPN_ENDPOINT=$1
LOCAL_DOCKER_SSH_PORT=$2
CONTAINER_NAME=$3
IMAGE_NAME=$4

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
    winpty docker exec -it $CONTAINER_NAME bash -c "screen openconnect $OPENCONNECT_VPN_ENDPOINT"
else 
    docker exec -it $CONTAINER_NAME bash -c "screen openconnect $OPENCONNECT_VPN_ENDPOINT"
fi