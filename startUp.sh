#!/bin/bash

##Only edit these items to set the version, nothing else needs to be
##  modified for a raspberry pi setup.
GOME_CORE_VERSION="db_lock_issue"
GOME_SCHEDULE_VERSION="db_lock_issue"
### END MODIFY

UPGRADE=$1
GOME_CORE="gome-core"
GOME_SCHEDULE="gome-schedule"
PACKAGES=( "git" "curl" "libssl-dev" "libffi-dev" "python3-dev" "python3" "python3-pip")
GITPREFIX="https://github.com/RebelIT"
INSTALLDIR="/home/pi/gome"
HOMEDIR="/home/pi"


if [[ $UPGRADE = "upgrade" ]]
then
  echo "*GOME: cleaning repos for new versions"
  rm -rf $INSTALLDIR
fi


echo "*GOME: creating directory structure"
mkdir -p $INSTALLDIR > /dev/null


echo "" && echo "*GOME: Installing packages"
for PACKAGE in "${PACKAGES[@]}"
do
  # intentially installing seperate, pything & pip didn't like being installed
  #   tpgether at once...
  echo "  **$PACKAGE"
  apt-get install -y $PACKAGE > /dev/null
done


echo "" && echo "*GOME: Installing docker components"
echo "  **docker"
curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null
sh get-docker.sh > /dev/null
usermod -aG docker pi > /dev/null
echo "  **docker-compose"
pip3 install docker-compose > /dev/null


echo "" && echo "*GOME: enabling docker services"
systemctl start docker  > /dev/null
systemctl enable docker  > /dev/null


echo "" && echo "*GOME: git cloning gome services from $GITPREFIX"
cd $INSTALLDIR
git clone --depth 1 --branch $GOME_CORE_VERSION "$GITPREFIX/$GOME_CORE.git"
git clone --depth 1 --branch $GOME_SCHEDULE_VERSION "$GITPREFIX/$GOME_SCHEDULE.git"
cd $HOMEDIR


echo "" && echo "*GOME: Composing application"
docker pull golang:1.15.0-buster
cp gome.service /etc/systemd/system
mkdir -p /etc/docker/compose > /dev/null
cp docker-compose.yml /etc/docker/compose/
cp core-config.env /etc/docker/compose/
cp schedule-config.env /etc/docker/compose/

systemctl daemon-reload
systemctl enable gome

echo "" && echo "*GOME: Done"
echo "Please Run:  systemctl start gome"
echo "Note that the 1st startup builds the containers and may take a while"
echo "all other service restarts are fast, sometimes this initial start hangs"
echo "if 'journalctl -fu gome' reports it is running, ctrl+c out of the service start "
