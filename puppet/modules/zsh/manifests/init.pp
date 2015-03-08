class zsh {

  $oh_my_zsh = "$env_pwd/.oh-my-zsh"

  if ! defined(Package['zsh'])        { package { 'zsh':  ensure => present } }

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
    shell   => "/usr/bin/zsh",
    require => Package['zsh'],
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
