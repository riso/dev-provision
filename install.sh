set -e

# detect OS
if [ $(uname -o) = "Cygwin" ]
then
  echo "Cygwin not yet supported"
  exit -1
fi

OS=`cat /etc/os-release | awk '/^ID=/' | sed 's/ID=//'`

case $OS in
  ubuntu|debian )
    VERSION=$(lsb_release -sc)
    ;;
  fedora )
    VERSION=`cat /etc/os-release | awk '/^VERSION_ID=/' | sed 's/VERSION_ID=//'`
    ;;
  * )
    echo "$OS not yet supported"
    exit -1
    ;;
esac

# test for prerequirements
function toolpresent {
  hash $1 > /dev/null 2>&1 || { 
    echo "$1 not found, but it's required to proceed. Please install it manually and rerun"
    MISSING_PREREQ=true
  }
}

unset MISSING_PREREQ
toolpresent wget
toolpresent unzip

if [ "$MISSING_PREREQ" = true ]
then
  unset MISSING_PREREQ
  exit -1
fi

# install puppet
if ! $(hash puppet > /dev/null 2>&1)
then
  echo "puppet not found, installing..."
  case $OS in
    ubuntu|debian )
      wget http://apt.puppetlabs.com/puppetlabs-release-$VERSION.deb
      dpkg -i puppetlabs-release-$VERSION.deb
      rm -f puppetlabs-release-$VERSION.deb
      apt-get update
      apt-get install -y puppet
      ;;
    fedora )
       rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-fedora-$VERSION.noarch.rpm
       yum install -y puppet
      ;;
  esac
  echo "puppet successfully installed"
else
  echo "puppet already present, continue"
fi

# grab puppet modules and manifets
# TODO change to bintray distribution
wget --no-check-certificate https://2.233.208.136/index.php/s/vJWyofXrelxOG1r/download -O puppet.zip
unzip puppet.zip
puppet module --modulepath=puppet/modules install puppetlabs-vcsrepo

# provision with puppet
export FACTERLIB="$PWD/puppet/facter"
puppet apply --modulepath=puppet/modules puppet/manifests/base.pp
rm -rf puppet/ puppet.zip
