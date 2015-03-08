class subversion {
  if ! defined(Package['subversion']) { package { 'subversion': ensure => present } }
}
