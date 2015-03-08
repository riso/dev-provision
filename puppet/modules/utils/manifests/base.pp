class utils::base {
  if ! defined(Package['htop'])       { package { 'htop':       ensure => present } }
  if ! defined(Package['iotop'])      { package { 'iotop':      ensure => present } }
  if ! defined(Package['git'])        { package { 'git':        ensure => present } }
  if ! defined(Package['vim'])        { package { 'vim':        ensure => present } }
  if ! defined(Package['zsh'])        { package { 'zsh':        ensure => present } }
  if ! defined(Package['tmux'])       { package { 'tmux':       ensure => present } }
}
