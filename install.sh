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
function ensuretool {
  hash $1 > /dev/null 2>&1 || { 
    echo "$1 not found, but it's required to proceed. Installing it now..."
    case $OS in
      ubuntu|debian )
        apt-get install -y $1
        ;;
      fedora )
        yum install -y $1
        ;;
    esac
  }
}

ensuretool wget
ensuretool unzip

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

echo "system provisioned correctly!"
echo "to complete configuration you still have to configure authentication data:"
echo "  * SSH keys"
