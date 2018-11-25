export DEBIAN_FRONTEND=noninteractive
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes
ip link set dev eth1 up
ip add add 192.168.40.1/30 dev eth1
ip route add 192.168.0.0/16 via 192.168.40.2
docker rm $(docker ps -a -q)
docker ps
docker run -dit --name nginx -p 32768:80 -v /home/user/website/:/usr/share/nginx/html:ro -d nginx
docker ps
echo "<!DOCTYPE html>
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
