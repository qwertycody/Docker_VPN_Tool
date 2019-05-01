
echo "#############################"
echo "VPN Routing Script - STARTED"
echo "#############################"

echo ""

echo "#############################"
echo "VPN Routing Script - SETUP"
echo "#############################"

echo ""

IP_LIST=$(hostname -I)
echo "IP List:"
echo $IP_LIST

echo ""

SUBNET_LIST=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')
echo "Subnet List:"
echo $SUBNET_LIST

echo ""

GATEWAY_LIST=$(/sbin/ip route | awk '/default/ { print $3 }')
echo "Gateway List:"
echo $GATEWAY_LIST

echo ""

echo "#############################"
echo "VPN Routing Script - STAGE 1"
echo "#############################"

echo ""

for IP_ADDRESS in $IP_LIST
do
    echo "ip rule add table 128 from $IP_ADDRESS"
    ip rule add table 128 from $IP_ADDRESS
done

echo ""

echo "#############################"
echo "VPN Routing Script - STAGE 2"
echo "#############################"

echo ""

for SUBNET_ADDRESS in $SUBNET_LIST
do
    echo "ipcalc --nobinary --nocolor $SUBNET_ADDRESS"
    SUBNET_MASK=$(ipcalc --nobinary --nocolor $SUBNET_ADDRESS | awk '/Network:/ {print $2}')

    echo "ip route add table 128 to $SUBNET_MASK dev eth0"
    ip route add table 128 to $SUBNET_MASK dev eth0
done

echo ""

echo "#############################"
echo "VPN Routing Script - STAGE 3"
echo "#############################"

echo ""

for GATEWAY_ADDRESS in $GATEWAY_LIST
do
    echo "ip route add table 128 default via $GATEWAY_ADDRESS"
    ip route add table 128 default via $GATEWAY_ADDRESS
done

echo ""

echo "#############################"
echo "VPN Routing Script - FINISHED"
echo "#############################"