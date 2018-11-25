export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
wget -O- https://apps3.cumulusnetworks.com/setup/cumulus-apps-deb.pubkey | apt-key add -
add-apt-repository "deb [arch=amd64] https://apps3.cumulusnetworks.com/repos/deb $(lsb_release -cs) roh-3"
apt-get update
apt-get install -y frr --assume-yes --force-yes
ip link set dev eth1 up
ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20
ip add add 192.168.10.254/24 dev eth1.10
ip add add 192.168.20.30/27 dev eth1.20
ip link set dev eth1.10 up
ip link set dev eth1.20 up
ip link set dev eth2 up
ip add add 192.168.30.1/30 dev eth2
sysctl net.ipv4.ip_forward=1
sed -i "s/\(zebra *= *\).*/\1yes/" /etc/frr/daemons
sed -i "s/\(ospfd *= *\).*/\1yes/" /etc/frr/daemons
service frr restart
service frr status
vtysh -e 'conf t' -e 'router ospf' -e 'redistribute connected' -e 'exit' -e 'interface eth2' -e 'ip ospf area 0.0.0.0' -e 'exit' -e 'exit' -e 'write'
echo " ">>/etc/frr//frr.conf
