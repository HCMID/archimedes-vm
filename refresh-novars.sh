#/bin/bash
#
# User fuser to kill any running services so
# we can invoke this script any time without
# rebooting server.
#

echo Starting the archimedes-hc servlet
GIT=`which git`
GRADLE=`which gradle`
echo Will use git from $GIT
echo Will use gradle from $GRADLE
# What we need:
# 1. the archimedes-hc archive.
# 2. citemgr
# 3. citeservlet

echo ""
echo "---------------------------------"
echo "1. Check for current repositories"
echo "---------------------------------"
# archive:
if [ -d "/vagrant/archimedes-hc" ]
then
    echo "Checking archive for updates"
    cd /vagrant/archimedes-hc
    /usr/bin/git pull
else
    echo "Installing archimedes-hc archive"
    cd /vagrant
    echo  Running  /usr/bin/git clone https://github.com/HCMID/archimedes-vm.git
    /usr/bin/git clone https://github.com/HCMID/archimedes-vm.git
fi
# citemgr
if [ -d "/vagrant/citemgr" ]
then
    echo "Checking CITE archive manager for updates."
    cd /vagrant/citemgr
    /usr/bin/git pull
else
    echo "Installing CITE archive manager."
    cd /vagrant
    echo  Running  /usr/bin/git clone https://github.com/cite-architecture/citemgr.git
    /usr/bin/git clone https://github.com/cite-architecture/citemgr.git
fi
# citeservlet
if [ -d "/vagrant/citeservlet" ]
then
    echo "Checking CITE servlet for updates."
    cd /vagrant/citeservlet
    /usr/bin/git pull
else
    echo "Installing CITE servlet."
    cd /vagrant
    echo  Running  /usr/bin/git clone https://github.com/cite-architecture/citeservlet.git
    /usr/bin/git clone https://github.com/cite-architecture/citeservlet.git
fi


# With everything up to date, then:
echo ""
echo "--------------------------------------"
echo 2. All files up date.  Now building TTL.
echo "--------------------------------------"
# 1. build TTL
cd /vagrant/citemgr
echo Building project RDF graph.
echo This can take a couple of minutes.
echo ""
/usr/bin/gradle clean && /usr/bin/gradle -Pconf=/vagrant/sparql/citemgr-conf.gradle ttl
/bin/cp /vagrant/citemgr/build/ttl/all.ttl /vagrant/sparql
echo TTL build.  Now loading into fuseki.



echo ""
echo "------------------------------------------------------------"
echo 3. Graph built. Now loading data and starting SPARQL endpoint.
echo "------------------------------------------------------------"


echo "Loading new data into RDF server."
if [ -d "/vagrant/sparql/tdbs" ]; then
    /bin/rm -rf /vagrant/sparql/tdbs
fi
/bin/mkdir /vagrant/sparql/tdbs
/vagrant/jena/bin/tdbloader2 -loc /vagrant/sparql/tdbs /vagrant/sparql/all.ttl

echo "Starting fuseki"
cd /vagrant/fuseki
./fuseki-server --port=3030 --config=/vagrant/sparql/fuseki-conf.ttl &



echo ""
echo "--------------------------------"
echo 4. Now starting servlet container
echo "--------------------------------"

# 3. start servlet
cd /vagrant/citeservlet

/usr/bin/gradle clean && /usr/bin/gradle   -Pconf=/vagrant/archimedes-hc/confs/localconf.gradle   -Plinks=/vagrant/archimedes-hc/confs/locallinks.gradle   -Pcustom=/vagrant/archimedes-hc/servlet/ jettyRunWar  &

