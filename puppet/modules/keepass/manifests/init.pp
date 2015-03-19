class keepass {

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
    command  => "/usr/bin/wget http://lechnology.com/wp-content/uploads/2015/02/KeeAgent_v0.6.0.zip -O /usr/lib/${keepass_name}/KeeAgent.zip",
    creates  => "/usr/lib/${keepass_name}/KeeAgent.zip",
    require  => [Package['wget'],Package["$keepass_name"]],
  }

  exec { "extract-keeagent":
    command  => "/usr/bin/unzip /usr/lib/${keepass_name}/KeeAgent.zip KeeAgent.plgx -d /usr/lib/${keepass_name}/",
    creates  => "/usr/lib/${keepass_name}/KeeAgent.plgx",
    require  => [Package['unzip'],Exec['download-keeagent']],
  }

  file { "/usr/lib/${keepass_name}/KeeAgent.zip":
    ensure   => absent,
    require  => [Exec['extract-keeagent']],
  }

}
