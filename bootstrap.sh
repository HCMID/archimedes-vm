#!/usr/bin/env bash


# Get fuseki and jena from binary downloads:
FUSEKIFILE=jena-fuseki-1.0.1
JENAFILE=apache-jena-2.11.1

if [ ! -d /vagrant/sparql/$FUSEKIFILE ]; then
    echo Need to install fuseki
    echo ""
    cd /vagrant/sparql;
    wget http://apache.mirrors.lucidnetworks.net//jena/binaries/$FUSEKIFILE-distribution.tar.gz;
    tar zxf $FUSEKIFILE-distribution.tar.gz;
    rm $FUSEKIFILE-distribution.tar.gz;
fi

cd /vagrant
if [ -h "fuseki" ]; then
    echo "Already have link to fuseki installation."
else
    ln -s /vagrant/sparql/$FUSEKIFILE /vagrant/fuseki
fi


if [ ! -d /vagrant/sparql/$JENAFILE ]; then
    echo Need to install jena.
    echo ""
    cd /vagrant/sparql;
    wget http://apache.osuosl.org//jena/binaries/$JENAFILE.tar.gz
    tar zxf $JENAFILE.tar.gz;
    rm $JENAFILE.tar.gz;
fi


cd /vagrant
if [ -h "jena" ]; then
    echo "Already have link to jena installation."
else
    ln -s /vagrant/sparql/$JENAFILE /vagrant/jena
fi


# Start from latest and greatest:
apt-get update

# version control
apt-get install -y git
GIT=`which git`
echo Installed git at $GIT

# need to have the one true editor
# in case Neel Smith needs to work on
# the machine
apt-get install -y emacs

# Get full JDK *now* so we don't pull in
# jre as a dependency and have to
# add jdk later...
apt-get install -y openjdk-7-jdk

# build system and dependency mgt
apt-get install -y gradle
apt-get install -y maven

# Update and trust apt to clean up some space for us:
apt-get upgrade
apt-get -y autoremove

echo "Ran autoremove."

# ADD THIS IF NEEDED LATER....
#echo "Setting up account directory."
#/bin/cp "/vagrant/dotprofile" "/home/vagrant/.profile"


