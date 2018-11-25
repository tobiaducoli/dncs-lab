export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl --assume-yes --force-yes
apt-get install -y tcpdump --assume-yes
ip link set dev eth1 up
ip add add 192.168.20.1/27 dev eth1
ip route add 192.168.0.0/16 via 192.168.20.30
