class zsh {

  $oh_my_zsh  = "$env_pwd/.oh-my-zsh"
  $zsh_bin    = $operatingsystem ? {
    centos  => '/usr/local/bin/zsh',
    default => "/usr/bin/zsh",
  }

  case $operatingsystem {
    'CentOS': {
      # on centos there is no updated zsh package, so we need to compile from source
      if ! defined(Package['tar'])            { package { 'tar':            ensure => present } }
      if ! defined(Package['wget'])           { package { 'wget':           ensure => present } }
      if ! defined(Package['gcc'])            { package { 'gcc':            ensure => present } }
      if ! defined(Package['make'])           { package { 'make':           ensure => present } }
      if ! defined(Package['ncurses-devel'])  { package { 'ncurses-devel':  ensure => present } }

      exec { "download-zsh":
        command => "/usr/bin/wget http://sourceforge.net/projects/zsh/files/zsh/5.0.7/zsh-5.0.7.tar.bz2/download && /bin/tar xvjf zsh-5.0.7.tar.bz2",
        creates => "$env_pwd/zsh-5.0.7",
        require => [Package['tar'],Package['wget']],
      }

      exec { "compile-zsh":
        command => "$env_pwd/zsh-5.0.7/configure --with-tcsetpgrp && make && make install",
        cwd     => "$env_pwd/zsh-5.0.7",
        creates => "/usr/local/bin/zsh",
        require => [Package['make'],Package['ncurses-devel'],Package['gcc'],Exec['download-zsh']],
      }

      exec { "add-zsh-shell":
        command => "/bin/echo \"$zsh_bin\" >> /etc/shells",
        onlyif  => "/usr/bin/test -z `cat /etc/shells | /bin/grep '$zsh_bin'`",
        require => Exec['compile-zsh'],
      }

      file { "$zsh_bin":
        ensure  => present,
        require => Exec['add-zsh-shell'],
      }

    }
    default:  {
      if ! defined(Package['zsh'])            { package { 'zsh':            ensure => present } }

      file { "$zsh_bin":
        ensure  => present,
        require => Package['zsh'],
      }
    }
  }

  # download oh-my-zsh
  vcsrepo { "$oh_my_zsh":
    ensure    => present,
    provider  => git,
    source    => "https://github.com/robbyrussell/oh-my-zsh.git",
    require   => Package['git'],
  }

  # change owner of oh-my-zsh
  file { "$oh_my_zsh": 
    ensure  => directory,
    recurse => true,
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$oh_my_zsh"],
  }

  # change user default shell
  user { "$env_sudo_user":
    ensure  => present,
    shell   => "$zsh_bin",
    require => File["$zsh_bin"],
  }

  # setup .zshrc
  file { "$env_pwd/.zshrc":
    ensure  => link,
    target  => "$utils::base::dotfiles/zshrc",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => File["$utils::base::dotfiles"],
  }
}
