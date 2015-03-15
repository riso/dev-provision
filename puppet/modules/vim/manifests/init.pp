class vim {

  $vim = "$env_pwd/.vim"

  # vim with lua support, required by neocomplete
  case $operatingsystem {
    'Debian', 'Ubuntu': {
      if ! defined(Package['vim-nox'])            { package { 'vim-nox':          ensure => present } }
    }
    'Fedora', 'CentOS': {
      if ! defined(Package['vim-enhanced'])       { package { 'vim-enhanced':     ensure => present } }
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
    'CentOS': {
      if ! defined(Package['ctags'])              { package { 'ctags':            ensure => present } }
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
    require => Vcsrepo["$utils::base::dotfiles"],
  }

  # setup bundle dir
  file { "$vim/bundle":
    ensure  => link,
    target  => "$utils::base::dotfiles/bundle",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$utils::base::dotfiles"],
  }

  # setup autoload dir
  file { "$vim/autoload":
    ensure  => link,
    target  => "$utils::base::dotfiles/autoload",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$utils::base::dotfiles"],
  }

  case $operatingsystem {
    'Fedora', 'CentOS': {
      # make sure that vi points to vim
      file { "/usr/bin/vi":
        ensure  => link,
        replace => true,
        target  => "/usr/bin/vim",
        require => Package['vim-enhanced'],
      }
    }
  }
}
