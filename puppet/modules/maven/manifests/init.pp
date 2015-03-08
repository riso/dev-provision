class maven {
  if ! defined(Package['maven'])      { package { 'maven':      ensure => present } }
}
