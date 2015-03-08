class tmux {

  # setup .tmux.conf
  file { "$env_pwd/.tmux.conf":
    ensure  => link,
    target  => "$utils::base::dotfiles/tmux.conf",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => File["$utils::base::dotfiles"],
  }

  # setup .tmux
  file { "$env_pwd/.tmux":
    ensure  => link,
    target  => "$utils::base::dotfiles/tmux",
    owner   => "$env_sudo_user",
    group   => "$env_sudo_user",
    require => File["$utils::base::dotfiles"],
  }
}
