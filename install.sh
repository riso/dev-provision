set -e

# detect OS
if [ $(uname -o) = "Cygwin" ]
then
  echo "Cygwin not yet supported"
  exit
fi

OS=$(lsb_release -si)
VERSION=$(lsb_release -sc)

if ! [[ $OS =~ (Ubuntu|Debian) ]]
then
  echo "$OS not yet supported"
  exit
fi

# install puppet
hash wget > /dev/null 2>&1 && env wget http://apt.puppetlabs.com/puppetlabs-release-$VERSION.deb || {
  echo "At the very least we need wget installed, can't do anything without it"
  exit
}
dpkg -i puppetlabs-release-$VERSION.deb
apt-get update
apt-get install -y puppet

# grab puppet modules and manifets

# provision with puppet
