class vim {

  $vim = "$env_pwd/.vim"

  if ! defined(Package['vim-nox'])        { package { 'vim-nox':  ensure => present } }

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
