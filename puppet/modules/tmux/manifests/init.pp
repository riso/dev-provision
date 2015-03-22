class tmux {

  require epel

  if ! defined(Package['tmux'])       { package { 'tmux':   ensure => present } }
  if ! defined(Package['xclip'])      { package { 'xclip':  ensure => present } }

  $terminfo_path = $operatingsystem ? {
    /(Fedora|CentOS)/ => '/usr/share/terminfo/s/screen-256color',
    default           => '/etc/terminfo/s/screen-256color',
  }

  # setup .tmux.conf
  file { "$env_pwd/.tmux.conf":
    ensure  => link,
    target  => "$utils::base::dotfiles/tmux.conf",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$utils::base::dotfiles"],
  }

  # setup .tmux
  file { "$env_pwd/.tmux":
    ensure  => link,
    target  => "$utils::base::dotfiles/tmux",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => Vcsrepo["$utils::base::dotfiles"],
  }

  # compile terminfo for screen-256colors
  exec { "compile-terminfo":
    command => "/usr/bin/tic $utils::base::dotfiles/screen-256color.ti",
    creates => "$terminfo_path",
    require => Vcsrepo["$utils::base::dotfiles"],
  }

}
