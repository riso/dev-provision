class utils::base {
  if ! defined(Package['htop'])       { package { 'htop':       ensure => present } }
  if ! defined(Package['iotop'])      { package { 'iotop':      ensure => present } }
  if ! defined(Package['git'])        { package { 'git':        ensure => present } }

  $dotfiles = "$env_pwd/.dotfiles" 

  # download config files
  vcsrepo { "$dotfiles":
    ensure    => present,
    provider  => git,
    source    => "https://github.com/riso/dotfiles.git",
    require   => Package['git'],
  }

  # change owner of config files
  file { "$dotfiles": 
    ensure  => directory,
    recurse => true,
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$dotfiles"],
  }

}
