class utils::base {
  if ! defined(Package['htop'])       { package { 'htop':       ensure => present } }
  if ! defined(Package['iotop'])      { package { 'iotop':      ensure => present } }
  if ! defined(Package['git'])        { package { 'git':        ensure => present } }

  $dotfiles = "$env_pwd/.dotfiles" 

  # download config files
  vcsrepo { "$dotfiles":
    ensure    => present,
    provider  => git,
    source    => "git@github.com:riso/dotfiles.git",
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

  # setup gitconfig
  file { "$env_pwd/.gitconfig":
    ensure  => link,
    target  => "$dotfiles/gitconfig",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$dotfiles"],
  }

  # setup global gitignore
  file { "$env_pwd/.gitignore_global":
    ensure  => link,
    target  => "$dotfiles/gitignore_global",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$dotfiles"],
  }
}
