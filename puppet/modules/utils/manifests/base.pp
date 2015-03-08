class utils::base {
  if ! defined(Package['git'])      { package { 'git':      ensure => present } }
  if ! defined(Package['vim'])      { package { 'vim':      ensure => present } }
  if ! defined(Package['zsh'])      { package { 'zsh':      ensure => present } }
  if ! defined(Package['tmux'])     { package { 'tmux':     ensure => present } }
}
