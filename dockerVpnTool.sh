OPENCONNECT_VPN_ENDPOINT=$1; shift
LOCAL_DOCKER_ADDRESS=$1; shift
LOCAL_DOCKER_SSH_PORT=$1; shift
CONTAINER_NAME=$1; shift
IMAGE_NAME=$1; shift
eval "declare -A DESTINATION_LIST="${1#*=}

function connectToVpn()
{
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME

    PORT_SSH="$LOCAL_DOCKER_SSH_PORT:22"

    docker run -d --privileged --rm --name $CONTAINER_NAME -p $PORT_SSH $IMAGE_NAME

    ##################################
    ### VPN Endpoint to Connect To ###
    ##################################

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
        docker exec -it $CONTAINER_NAME bash -c  "screen openconnect $OPENCONNECT_VPN_ENDPOINT"
    fi
}

function establishTunnels()
{
    clear

    for LOCAL_LISTEN_PORT in "${!DESTINATION_LIST[@]}"
    do
        #Pull Values from Array
        DESTINATION_ADDRESS_DESTINATION_PORT=${DESTINATION_LIST[$LOCAL_LISTEN_PORT]}

        echo "Establishing Tunnel to $DESTINATION_ADDRESS_DESTINATION_PORT using Local Port $LOCAL_LISTEN_PORT"

        #ssh-keygen -R [$LOCAL_DOCKER_ADDRESS]:$LOCAL_DOCKER_SSH_PORT
        #ssh -o StrictHostKeyChecking=no -fNL $LOCAL_LISTEN_PORT:$DESTINATION_ADDRESS_DESTINATION_PORT -l root $LOCAL_DOCKER_ADDRESS -p $LOCAL_DOCKER_SSH_PORT >/dev/null 2>&1

        nohup echo y | "/c/Program Files/PuTTY/plink.exe" -N -L $LOCAL_LISTEN_PORT:$DESTINATION_ADDRESS_DESTINATION_PORT -ssh root@$LOCAL_DOCKER_ADDRESS -P $LOCAL_DOCKER_SSH_PORT -pw password >/dev/null 2>&1 &

        echo ""
        echo "##################################################################"
        echo "If there are no errors up to this point you can now connect"
        echo "to the endpoint using localhost:$LOCAL_LISTEN_PORT using ssh/rdp"
        echo "##################################################################"
        echo ""
    done
}

choiceFunction() {
    SUCCESS="false"
 
    while [ $SUCCESS == "false" ]
    do
        clear
        echo "Please enter your choice - $CONTAINER_NAME: "
        echo "1 - Connect and Establish Tunnels"
        echo "2 - Establish Tunnels"
        echo "3 - Quit"
        read CHOICE
 
        case $CHOICE in
           "1") SUCCESS="true";connectToVpn; establishTunnels;;
           "2") SUCCESS="true";establishTunnels;;
           "3") SUCCESS="true";echo "Exiting ..."; exit;;
           *) read -p "Invalid choice, Press any key to continue..." fakeVariableIgnoreMe;;
        esac
    done
}

choiceFunction
