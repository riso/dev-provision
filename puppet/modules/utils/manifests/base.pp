class utils::base {
  require epel

  if ! defined(Package['htop'])       { package { 'htop':       ensure => present } }
  if ! defined(Package['iotop'])      { package { 'iotop':      ensure => present } }
  if ! defined(Package['git'])        { package { 'git':        ensure => present } }

  $dotfiles = "$env_pwd/.dotfiles" 

  # download config files
  vcsrepo { "$dotfiles":
    ensure    => present,
    provider  => git,
    source    => "https://github.com/riso/dotfiles.git",
    user      => "$env_sudo_user",
    require   => Package['git'],
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
