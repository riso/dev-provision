class keepass {

  require augeas

  $keepass_name = $operatingsystem ? {
    fedora  => 'keepass',
    default => 'keepass2',
  }

  if ! defined(Package["$keepass_name"])        { package { "$keepass_name":  ensure => present } }
  if ! defined(Package['wget'])                 { package { 'wget':           ensure => present } }
  if ! defined(Package['unzip'])                { package { 'unzip':          ensure => present } }

  exec { "download-keepasshttp":
    command  => "/usr/bin/wget https://raw.github.com/pfn/keepasshttp/master/KeePassHttp.plgx -O /usr/lib/${keepass_name}/KeePassHttp.plgx",
    creates  => "/usr/lib/${keepass_name}/KeePassHttp.plgx",
    require  => [Package['wget'],Package["$keepass_name"]],
  }

  exec { "download-keeagent":
    command   => "/usr/bin/wget http://lechnology.com/wp-content/uploads/2015/02/KeeAgent_v0.6.0.zip -O /usr/lib/${keepass_name}/KeeAgent.zip",
    creates   => "/usr/lib/${keepass_name}/KeeAgent.zip",
    unless    => "/usr/bin/test -f /usr/lib/${keepass_name}/KeeAgent.plgx",
    require   => [Package['wget'],Package["$keepass_name"]],
  }

  exec { "extract-keeagent":
    command  => "/usr/bin/unzip /usr/lib/${keepass_name}/KeeAgent.zip KeeAgent.plgx -d /usr/lib/${keepass_name}/",
    creates  => "/usr/lib/${keepass_name}/KeeAgent.plgx",
    require  => [Package['unzip'],Exec['download-keeagent']],
    before    => File["/usr/lib/${keepass_name}/KeeAgent.zip"],
  }

  file { "/usr/lib/${keepass_name}/KeeAgent.zip":
    ensure   => absent,
  }

  # disable gnome keyring daemon for the user
  file { ["/home/$env_sudo_user/.config", "/home/$env_sudo_user/.config/autostart"]:
    ensure  => directory,
  }

  file { "/home/${env_sudo_user}/.config/autostart/gnome-keyring-ssh.desktop":
    ensure  => present,
    source  => "/etc/xdg/autostart/gnome-keyring-ssh.desktop",
    require => File["/home/$env_sudo_user/.config/autostart"],
  }
                                                                            
  augeas { "disable-gnome-keyring":
    lens    => "Desktop.lns",
    incl    => "/home/${env_sudo_user}/.config/autostart/gnome-keyring-ssh.desktop",
    changes => [
        "set \"/files/home/${env_sudo_user}/.config/autostart/gnome-keyring-ssh.desktop/Desktop Entry/X-GNOME-Autostart-enabled\" false"
      ],
    require => File["/home/${env_sudo_user}/.config/autostart/gnome-keyring-ssh.desktop"],
  }
}
