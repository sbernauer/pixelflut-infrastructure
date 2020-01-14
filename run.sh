#!/bin/bash

cp docker-compose_template.yml docker-compose.yml

echo "With this tool you can start an pixelflut server."
echo "The pixelflut server accepts Pixelflut-Commands at Port 1234 and serves as a vnc server at Port 5900, so that people can watch the game."
echo "This tool will also start an VNC-multiplexer (Port 5901) and serve all the people watching with a seperate server and therefore save resources on the pixelflut-server."
echo "It also provides an grafana (Port 80) with monitoring of the pixelflut-server and game"
echo "Powered by https://github.com/TobleMiner/vncmux and https://github.com/TobleMiner/shoreline"
echo
echo ">>> Attention: You must use https://github.com/TobleMiner/shoreline as pixelflut-server!    <<<"
echo ">>> shoreline must have the frontend 'statistics' enabled to get the statistics of the game <<<"
echo ">>> for example start the server with: ./shoreline -f vnc -f statistics -t arial.ttf        <<<"
echo

START=0
read -p "Do you want to start your own pixelflut server? (otherwise only monitor an other server) [Y/n] " input
case "$input" in 
  ''|y|Y|yes ) START=1; echo "Will start pixelflut server" && sed -i -e 's/#COMMENT#//g' docker-compose.yml;;
  * ) echo "Wont start pixelflut server";;
esac

if [ $START -eq 1 ]; then
    hostname="shoreline" # Direct link to shoreline-container
    port_vnc=5901
    port_statistics=1235
    read -p "Please enter a description to display on the screen (empty to emit): " description
else
    read -p "Please enter hostname of the pixelflut server (please dont use localhost, use external ip. Sorry): " hostname
    read -p "Please enter the VNC port of the pixelflut server (default 5900): " port_vnc
    if [ -z $port_vnc ]; then port_vnc=5900; fi
    read -p "Please enter the statistics port of the pixelflut server (default 1235): " port_statistics
    if [ -z $port_statistics ]; then port_statistics=1235; fi
fi

read -p "Please enter the width of the screen (default 1280): " width
if [ -z $width ]; then width=1280; fi
read -p "Please enter the height of the screen (default 720): " height
if [ -z $height ]; then height=720; fi

sed -i \
-e 's/###HOST###/'"$hostname"'/g' \
-e 's/###PORT_VNC###/'"$port_vnc"'/g' \
-e 's/###PORT_STATISTICS###/'"$port_statistics"'/g' \
-e 's/###WIDTH###/'"$width"'/g' \
-e 's/###HEIGHT###/'"$height"'/g' \
-e 's/###DESCRIPTION###/'"$description"'/g' \
docker-compose.yml

cat docker-compose.yml

docker-compose build
docker-compose up
