include zsh

class zsh {

  require utils::base
  
  $oh_my_zsh = "$env_pwd/.oh-my-zsh"

  # download oh-my-zsh
  vcsrepo { "$oh_my_zsh":
    ensure   => present,
    provider => git,
    source   => "https://github.com/robbyrussell/oh-my-zsh.git",
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
    ensure => present,
    shell  => "/usr/bin/zsh",
    require => Vcsrepo["$oh_my_zsh"],
  }

  # setup .zshrc
}
