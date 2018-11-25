# DNCS-LAB Assignment 2018-2019                                                                                               25/11/2018
Ducoli Tobia
Dalvai Juri

This Readme file contains a brief description of the project developed during the lessons of "Design of networks and communication systems" course, hosted by Unitn.

# Table of contents

  - [Requirements](https://github.com/tobiaducoli/dncs-lab#requirements) 
  - [Network map](https://github.com/tobiaducoli/dncs-lab#network-map)
  - [IP adresses](https://github.com/tobiaducoli/dncs-lab#ip-addresses)
  - [Subnetting](https://github.com/tobiaducoli/dncs-lab#subnetting)
  - [Virtual LANs](https://github.com/tobiaducoli/dncs-lab#virtual-LANs,aka-VLANs)
  - [IPs & interfaces](https://github.com/tobiaducoli/dncs-lab#IPs-&-interfaces)
  - [Vagrantfile](https://github.com/tobiaducoli/dncs-lab#vagrantfile)
  - [Hosts](https://github.com/tobiaducoli/dncs-lab#hosts)
  	- Host-1-a
  	- Host-1-b
  	- Host-2-c
  - [Switch](https://github.com/tobiaducoli/dncs-lab#switch)
  - [Routers](https://github.com/tobiaducoli/dncs-lab#router)
  	- Router-1
  	- Router-2
  - [Testing](https://github.com/tobiaducoli/dncs-lab#testing)
  - [License](https://github.com/tobiaducoli/dncs-lab#license)
  
# Requirements

  - 10GB disk storage
  - 2GB free RAM
  - [Virtualbox](https://www.virtualbox.org/)
  - [Vagrant](https://www.vagrantup.com)
  - Internet

# Network map
Below there's a rappresentation of the network topology, with specified the port number and the IP addresses.
```

           +--------------------------------------------------------+
           |                                                        |
           |                      192.168.30.1/30  192.168.30.2/30  |eth0
        +--+--+                 +------------+ ||       || +------------+
        |     |                 |            | ||       || |            |
        |     |             eth0|            |eth2     eth2|            |
        |     +-----------------+  router-1  +-------------+  router-2  |
        |     |                 |            |             |            |
        |     |                 |            |             |            |
        |     |                 +------------+             +------------+
        |  M  |                       |eth1        192.168.40.2/30|eth1
        |  A  |      192.168.10.254/24|eth1.10                    |
        |  N  |       192.168.20.30/27|eth1.20                    |
		|  A  |                       |            192.168.40.1/30|eth1
        |  G  |                       |                     +-----+----+
        |  E  |                       |eth1                 |          |
        |  M  |             +-------------------+           |          |
        |  E  |         eth0|                   |           | host-2-c |
        |  N  +-------------+      SWITCH       |           |          |
        |  T  |             |                   |           |          |
        |     |             +-------------------+           +----------+
        |  V  |                |eth2        |eth3                |eth0
        |  A  |                |            |                    |
        |  G  |                |            |                    |
        |  R  | 192.168.10.1/24|eth1    eth1| 192.168.20.1/27    |
        |  A  |         +----------+     +----------+            |
        |  N  |         |          |     |          |            |
        |  T  |     eth0|          |     |          |            |
        |     +---------+ host-1-a |     | host-1-b |            |
        |     |         |          |     |          |            |
        |     |         |          |     |          |            |
        ++-+--+         +----------+     +----------+            |
        |   |                               |eth0                |
        |   |                               |                    |
        |   +-------------------------------+                    |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+

```
# Subnetting

As you can see from the map above, it's possible to split the network in 4 different subnetworks, that are:
1. the vlan subnet containing host-1-a and router-1 port;
2. the vlan subnet containing host-1-b and router-1 port;
3. the subnet containing host-2-c and router-2 port;
4. the area containing the link between router-1 and router-2;

# IP Addresses
The next step is to assign the IP addresses to hosts and routers.
One of the main task of the assignment was to allocate as few IP addresses as possible. In fact we need to define:
A. Up to 130 hosts in the same subnet of host-1-a; 
B. Up to 25 hosts in the same subnet of host-1-b;
C. Consume as few IP addresses as possible;

To achieve the task describe above, we decided to assign the following IP addresses:

|Network id 	| Network mask 	| Available IPs 		  | Needed IPs	
|---------------|---------------|---------------------|-------------
|**A**			|192.168.10.0/24| 2^(32-24) - 2 = 254 | 132 (130+1+1)	
|**B**			|192.168.20.0/27| 2^(32-27) - 2 = 30  | 27  (25+1+1)	
|**C**			|192.168.30.0/30| 2^(32-30) - 2 = 2   | 2			
|**D**			|192.168.40.0/30| 2^(32-30) - 2 = 2   | 2			

It's noticeable the fact that, to calculate the number of available IP addresses, we use the following formula:
**IP add. available = 2^(32-X) - 2**
where: 
* X is the number of bit reserved to the host part(and it belongs to the Natural number); 
* 	we subctract 2 from the number of ip addresses because 1 address is reserved to the broadcast communication in the subnet,
	and another is dedicated for the network itself;
 
# Virtual LANs, aka VLANs
 
As it's possible to notice from the map above, due the fact that host-1-a and host-1-b are (hypothetically) on the same collision
area, we decided to define to different VLANs for host-1-a and host-1-b. The main advantage of this choice is that the use of VLANs allows to
separate, to split the "left" region of our topology(the one containing host-1-a, host-1-b, switch and router-1) in two different virtual subnets, 
each of them with its own collision domain, without adding another router.
Another reason for using VLANs is the fact that, in our assignment, both host-1-a and host-1-b had to be able to reach a webpage hosted on a webserver
located on host-2-c(with docker), so we decided to establish between router-1 and switch an interface able to distinguish between host-1-a and host-1-b.
To manage the traffic coming from the two different hosts, we set up a different VLAN id to each of the two subnets.
 
|Network	|VLAN tag	|
|-----------|-----------|
|**1**		|10			|
|**2**		|20			|
|**3**		|NO VLAN	|
|**4**		|NO VLAN 	|


# IPs & interfaces 
At this point, it's a good idea to write in a table the interfaces numbers and the IPs addresses, just to maintain some order:

|Host name	|interface	|VLAN tag	|IP address		|
|-----------|-----------|-----------|---------------|
|router-1	|eth1		|--			|--(trunk link)	|
|			|eth1.10	|10			|192.168.10.254	|
|			|eth1.20	|20			|192.168.20.30	|
|			|eth2		|NO			|192.168.30.1	|
|router-2	|eth1		|NO			|192.168.40.2	|
|			|eth2		|NO			|192.168.30.2	|
|host-1-a	|eth1		|NO			|192.168.10.1	|
|host-1-b	|eth1		|NO			|192.168.20.1	|
|host-2-c	|eth1		|NO			|192.168.40.1	|


# Vagrantfile
The Vagrantfile is the file in which are described all the command necessary to initialize the virtual machines, and to establish connections between them.
For each machines it's possible to define:
 * the host-name with `host.vm.hostname = "nome"`;
 * the image loaded in the VM, in our case `host.vm.box = "minimal/trusty64"`; 
 * the type of network(private or public) with `hosta.vm.network "private_network"`;
 * the file which contains the provisioner `hosta.vm.provision "shell", path: "host1a.sh"`;
* In Vagrant, the provisioner allows to execute commands automatically, without typing them into the host command shell.
	The provisioner is used to run in an autonomous way commands, to install softwares and updates, to set up the host's
	configuration, without, as i've already written, the need to type the commands every time that you set up the virtual enviroment.
In the next chapters we will introduce the explaination of the most significant commands present in each provision file.   

# Hosts
Here there are the commands common for each router:
* `ip link set dev eth1 up` :bring the interface eth1 up;

## Host-1-a
* `apt-get install -y curl --assume-yes` : install the packages to run the command curl and be able to connect to a website (--assume-yes allows the program to download the packages without asking for permission);
* `ip add add 192.168.10.1/24 dev eth1` : add address 192.168.10.1/24 to interface eth1;
* `ip route add 192.168.0.0/16 via 192.168.10.254` :add a static route for all packages through the default gateway;
	
## Host-1-b
* `apt-get install -y docker-ce --assume-yes --force-yes` : install the packages to run the command docker to be able to run a container from his image (--assume-yes allow the program to download the packages without asking for permission);
* `ip add add 192.168.20.1/27 dev eth1` : add address 192.168.20.1/27 to interface eth1;
* `ip route add 192.168.0.0/16 via 192.168.20.30` :add a static route for all packages through the default gateway;

## Host-2-c
* `apt-get install -y docker-ce --assume-yes --force-yes` : install the packages to run the command docker to be able to run a container from his image (--assume-yes allow the program to download the packages without asking for permission);
* `ip add add 192.168.40.1/30 dev eth1` : add address 192.168.40.1/30 to interface eth1;
* `ip route add 192.168.0.0/16 via 192.168.40.2` :add a static route for all packages through the default gateway;
* `docker rm $(docker ps -a -q)` :remove all docker's stopped containers;
* `docker run -dit --name tecmint-web -p 32768:80 -v /home/user/website/:/usr/local/apache2/htdocs/ httpd:2.4` : run docker from the docker image tecmint-web with a specific port (32768);
* `echo"<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assignment of Design of Network and Communication System</title>
</head>
<body>
    <h1>If you reach thi static web page and you visualize it correctly means that the configuration is correct!</h1>
    <h2>This project was made by Juri Dalvai and Tobia Ducoli.</h2>
</body>
</html>"> /home/user/website/docker.html` :write in a new file html the code of the static site that we will reach testing the assignment;

# Switch	
* `apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common`: install packages to use an OpenSwitch ;
* `ovs-vsctl add-br switch`:add a switch;
* `ovs-vsctl add-port switch eth1`:add a new port eth1 on the switch;
* `ovs-vsctl add-port switch eth2 tag=10`:add a new port eth2 on the switch with a tag=10 to define the VLAN;
* `ovs-vsctl add-port switch eth3 tag=20`:add a new port eth3 on the switch with a tag=20 to define the VLAN;
* `ip link set dev eth1 up`:bring the interface eth1 up;
* `ip link set dev eth2 up`:bring the interface eth2 up;
* `ip link set dev eth3 up`:bring the interface eth3 up;
* `ip link set ovs-system up`: bring the switch up;

	
# Router
Here there are the commands common for each router:
* `apt-get install -y frr --assume-yes --force-yes` :install packages to allow the router run the ospf protocol (througt Fast Forward Routing );
* `ip link set dev eth1 up` : bring the interface eth1 up;
* `ip link set dev eth2 up` : bring the interface eth2 up;
* `sysctl net.ipv4.ip_forward=1` :router can forward packets;
* `sed -i "s/\(zebra *= *\).*/\1yes/" /etc/frr/daemons` :modify a file of frr to activate zebra;
* `sed -i "s/\(ospfd *= *\).*/\1yes/" /etc/frr/daemons` :modify a file of frr to activate ospf;
* `service frr restart` :restart the Fast Forward Routing;
* `service frr status` :show the status of frr;
* `vtysh -e 'conf t' -e 'router ospf' -e 'redistribute connected' -e 'exit' -e 'interface eth2' -e 'ip ospf area 0.0.0.0' -e 'exit' -e 'exit' -e 'write'` :configure the frr between the two routers;
	
## Router-1
	
* `ip link add link eth1 name eth1.10 type vlan id 10` : define the trunk link on the interface eth1 creating an interface eth1.10 that works on VLAN with tag=10;
* `ip link add link eth1 name eth1.20 type vlan id 20` :define the trunk link on the interface eth1 creating an interface eth1.20 that works on VLAN with tag=20;
* `ip add add 192.168.10.254/24 dev eth1.10` : add address 192.168.10.254/24 to interface eth1.10;
* `ip add add 192.168.20.30/27 dev eth1.20` : add address 192.168.20.30/27 to interface eth1.20;
* `ip link set dev eth1.10 up` : bring the interface eth1.10 up;
* `ip link set dev eth1.20 up` : bring the interface eth1.20 up;
* `ip add add 192.168.30.1/30 dev eth2` : add address 192.168.30.1/30 to interface eth2;
	
## Router-2
* `ip add add 192.168.40.2/30 dev eth1` : add address 192.168.40.2/30 to interface eth1;
* `ip add add 192.168.30.2/30 dev eth2` : add address 192.168.30.2/30 to interface eth2;

   
# Testing
So, after the explaination of the network topology and of the commands presents in the provision files, now it's time to
run this enviroment and test it! Here we report the necessary commands:

* install Virtualbox and Vagrant;
* Clone this repository with `git clone https://github.com/tobiaducoli/dncs-lab.git`;
* You should be able to launch the environment from within the cloned repo folder;
 
 `cd dncs-lab`
 `~/dncs-lab$ vagrant up --provision`
 
 Once you launch the vagrant script, it may take a while for the entire topology to become available.
 A person who read this command line may ask:
 >ok, fine, but what does these two
 >commands mean?
 
 The answer is easy, because with the first one you access to the clone repository, and with the
 second you tell Vagrant to start the VMs following the instructions specified in the provision files
 for each hosts.
 * verify the status of the 6 VMs;
 ```
 [dncs-lab]$ vagrant status
 Current machine states:

router-1                    running (virtualbox)
router-2                    running (virtualbox)
switch	                    running (virtualbox)
host-1-a                    running (virtualbox)
host-1-b                    running (virtualbox)
host-2-c                    running (virtualbox)
```
 
  * Once all the VMs are running verify you can log into all of them:
 ```
 vagrant ssh router-1
 vagrant ssh router-2
 vagrant ssh switch
 vagrant ssh host-1-a
 vagrant ssh host-1-b 
 vagrant ssh host-2-c
 ```
 
 * Once you log in into each VM, if all has gone well, you'll see the following message:
 ```
 Welcome to Ubuntu 14.04.3 LTS (GNU/Linux 3.16.0-55-generic x86_64)  
Documentation:  https://help.ubuntu.com/  
  * Development Environment  
Last login: Fri Nov 23 09:29:11 2018 from 10.0.2.2
[08:22:11 vagrant@router-1:~] $
```

 * Then, write the following command into each VM:
 ```
 sudo su
 ```
 A Windows-only user may ask:
 >What does this command stand for?
 
 Sudo su is a useful command for having superuser rights, without need to type this command
 every time that it is needed.
 * Finally, if all the things work well, type this command into the `host-1-a` or  'host-1-b' VM:
 ```
 curl 192.168.40.1:32768/docker.html
  ```
 And again, you may hear a question like:
 >Why are you waiting curl and not simply ping?
 >and what does the :32768 stand for?
 
 While `ping` is useful just for testing the presence/absence of connection between two hosts, with the
 `curl` command you send a request for a specific file named "docker.html", on the port 32768 of the server named "tecmint-net" running on host-2-c, hosted in a docker container.
 So the output of this command on the host-1-a terminal will be the html code of the web-page "docker.html".
 
 * If all works well, you should see the following lines:
 
 ```
 <!DOCTYPE html>
 <html lang="en">
 <head>
    <meta charset="UTF-8">
    <title>Assignment of Design of Network and Communication System</title>
 </head>
 <body>
    <h1>If you reach thi static web page and you visualize it correctly means that the configuration is correct!</h1>
    <h2>This project was made by Juri Dalvai and Tobia Ducoli.</h2>
 </body>
 </html>"> /home/user/website/docker.html
 
 ```
 
# License & bugs
 This code was developed during the lessons of the course of "Design of networks and communication systems", as an assignment.
 We tested it with our laptops and it works, but if you notice the presence of some bugs, contact us. 
 
