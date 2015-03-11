class vim {

  $vim = "$env_pwd/.vim"

  # vim with lua support, required by neocomplete
  case $operatingsystem {
    'Debian', 'Ubuntu': {
      if ! defined(Package['vim-nox'])            { package { 'vim-nox':          ensure => present } }
    }
  }
  # ctags are required by tagbar
  case $operatingsystem {
    'Debian', 'Ubuntu': {
      if ! defined(Package['exuberant-ctags'])    { package { 'exuberant-ctags':  ensure => present } }
    }
    'Fedora': {
      if ! defined(Package['ctags-etags'])        { package { 'ctags-etags':      ensure => present } }
    }
  }

  # create .vim dir
  file { "$vim":
    ensure => directory,
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
  }

  # setup .vimrc
  file { "$env_pwd/.vimrc":
    ensure  => link,
    target  => "$utils::base::dotfiles/vimrc",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => File["$utils::base::dotfiles"],
  }

  # setup bundle dir
  file { "$vim/bundle":
    ensure  => link,
    target  => "$utils::base::dotfiles/bundle",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => File["$utils::base::dotfiles"],
  }

  # setup autoload dir
  file { "$vim/autoload":
    ensure  => link,
    target  => "$utils::base::dotfiles/autoload",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => File["$utils::base::dotfiles"],
  }
}
