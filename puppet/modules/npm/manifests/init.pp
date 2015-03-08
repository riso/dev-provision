include npm

class npm {
  if ! defined(Package['npm'])        { package { 'npm':        ensure => present } }
}
