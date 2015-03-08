class fasd {

  $fasd = "$env_pwd/.fasd-git"

  # download fasd
  vcsrepo { "$fasd":
    ensure    => present,
    provider  => git,
    source    => "https://github.com/clvv/fasd.git",
    require   => Package['git'],
  }

  exec {'install-fasd':
    command => "/usr/bin/make install",
    cwd     => "$fasd",
    require => Vcsrepo["$fasd"],
  }

}
