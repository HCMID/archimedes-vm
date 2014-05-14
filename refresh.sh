#/bin/bash
echo Starting the archimedes-hc servlet
GIT=`which git`
GRADLE=`which gradle`
echo Will use git from $GIT
echo Will use gradle from $GRADLE
# What we need:
# 1. the archimedes-hc archive.
# 2. citemgr
# 3. citeservlet
# Phoros archive:
if [ -d "/vagrant/archimedes-hc" ]
then
    echo "Checking archive for updates"
    cd /vagrant/archimedes-hc
    $GIT pull
else
    echo "Installing phoros archive"
    cd /vagrant
    echo  Running  $GIT clone https://github.com/neelsmith/archimedes-hc
    $GIT clone https://github.com/neelsmith/archimedes-hc
fi
# citemgr
if [ -d "/vagrant/citemgr" ]
then
    echo "Checking CITE archive manager for updates."
    cd /vagrant/citemgr
    $GIT pull
else
    echo "Installing CITE archive manager."
    cd /vagrant
    echo  Running  $GIT clone https://github.com/cite-architecture/citemgr.git
    $GIT clone https://github.com/cite-architecture/citemgr.git
fi
# citeservlet
if [ -d "/vagrant/citeservlet" ]
then
    echo "Checking CITE servlet for updates."
    cd /vagrant/citeservlet
    $GIT pull
else
    echo "Installing CITE servlet."
    cd /vagrant
    echo  Running  $GIT clone https://github.com/cite-architecture/citeservlet.git
    $GIT clone https://github.com/cite-architecture/citeservlet.git
fi
# With everything up to date, then:
echo All files up date.  Now building TTL.
# 1. build TTL
cd /vagrant/citemgr
echo Building project RDF graph.
echo This can take a couple of minutes.
echo ""
$GRADLE clean && $GRADLE -Pconf=/vagrant/sparql/citemgr-conf.gradle ttl
/bin/cp /vagrant/citemgr/build/ttl/all.ttl /vagrant/sparql
echo TTL build.  Now loading into fuseki.
# 2. load TTL into fuseki
echo "Loading new data into RDF server."
if [ -d "/vagrant/sparql/tdbs" ]; then
    /bin/rm -rf /vagrant/sparql/tdbs
fi
/bin/mkdir /vagrant/sparql/tdbs
/vagrant/jena/bin/tdbloader2 -loc /vagrant/sparql/tdbs /vagrant/sparql/all.ttl
echo Loaded into fuseki. Now starting servlet.
# 3. start servlet
cd /vagrant/citeservlet
echo Starting servlet.
$GRADLE clean && $GRADLE   -Pconf=/vagrant/archimedes-hc/confs/localconf.gradle   -Plinks=/vagrant/archimedes-hc/confs/locallinks.gradle   -Pcustom=/vagrant/archimedes-hc/servletoverlay/ jettyRunWar
echo Finished everything:  servlet running.
