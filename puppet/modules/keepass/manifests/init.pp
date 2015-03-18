class keepass {

  $keepass_name = $operatingsystem ? {
    fedora  => 'keepass',
    default => 'keepass2',
  }

  if ! defined(Package["$keepass_name"])        { package { "$keepass_name":  ensure => present } }

  exec { "download-keepasshttp":
    command  => "/usr/bin/wget https://raw.github.com/pfn/keepasshttp/master/KeePassHttp.plgx -O /usr/lib/$keepass_name/KeePassHttp.plgx",
    creates  => "/usr/lib/$keepass_name/KeePassHttp.plgx",
    require  => Package["$keepass_name"],
  }

  file { "/usr/lib/$kepass_name/KeePassHttp.plgx":
    ensure  => present,
    mode    => 0644,
    require => Exec['download-keepasshttp'],
  }
}
