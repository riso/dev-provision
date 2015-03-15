set -e

# make sure that we're in user's $HOME
OLD_PWD=$PWD
# FIXME this assumes that we're running under sudo!
cd /home/$SUDO_USER

# detect OS
if [ $(uname -o) = "Cygwin" ]
then
  echo "Cygwin not yet supported"
  exit -1
fi

if [ -r "/etc/os-release" ]
then
  # ubuntu, debian, fedora
  OS=`cat /etc/os-release | awk '/^ID=/' | sed 's/ID=//'`
fi
if [ -r "/etc/redhat-release" ]
then
  # rhel, centos
  OS=`cat /etc/redhat-release | sed "s/\([a-zA-Z]*\).*/\L\1/"`
fi
  

case $OS in
  ubuntu|debian )
    VERSION=$(lsb_release -sc)
    ;;
  fedora )
    VERSION=`cat /etc/os-release | awk '/^VERSION_ID=/' | sed 's/VERSION_ID=//'`
    ;;
  centos )
    VERSION=`cat /etc/redhat-release | sed "s/[a-zA-Z ]*\([0-9]*\).*/\1/"`
    ;;
  * )
    echo "$OS not yet supported"
    exit -1
    ;;
esac

# test for prerequirements
ensuretool() {
  hash $1 > /dev/null 2>&1 || { 
    echo "$1 not found, but it's required to proceed. Installing it now..."
    case $OS in
      ubuntu|debian )
        apt-get install -y $1
        ;;
      fedora|centos )
        yum install -y $1
        ;;
    esac
  }
}

ensuretool wget
ensuretool tar

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
    centos )
       rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-$VERSION.noarch.rpm
       yum install -y puppet
      ;;
  esac
  echo "puppet successfully installed"
else
  echo "puppet already present, continue"
fi

# grab puppet modules and manifets
if [ $OS = "centos" ];
then 
  # this is stupid but its due to this bug https://bugzilla.redhat.com/show_bug.cgi?id=903756
  WGET="wget --no-check-certificate"
else
  WGET=wget
fi
$WGET https://s3-eu-west-1.amazonaws.com/dev-provision/puppet.tar.gz -O puppet.tar.gz
tar -xvf puppet.tar.gz
puppet module --modulepath=puppet/modules install puppetlabs-vcsrepo
puppet module --modulepath=puppet/modules install stahnma-epel
echo "downloaded and extracted modules, preparing to install them..."

# provision with puppet
export FACTERLIB="$PWD/puppet/facter"
puppet apply --modulepath=puppet/modules puppet/manifests/base.pp
rm -rf puppet/ puppet.tar.gz

# restore user directory
cd $OLD_PWD

echo "system provisioned correctly!"
