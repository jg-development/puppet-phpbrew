# == Class: phpbrew
#
# Installs phpbrew and its dependencies
#
# === Parameters
# user - the user for the installation of phpbrew
#
# === Examples
#
#  class { phpbrew:
#    user => 'root',
#  }
#
# === Authors
#
# Author Name <jgantzert@template-provider.com>
#
# === Copyright
#
# Copyright 2014 Jan Gantzert.
#
class phpbrew (
  $user = 'vagrant',
)
{
  case $operatingsystem {
    debian, ubuntu: {
      # everthing cool, you got the right system ;-)
      $standard_packages =['php5-cli', 'pkg-config', 'autoconf', 'build-essential']
      ensure_packages ( $standard_packages )
    }
    default: { fail("Only Ubuntu is currently supported") }
  }

  if $user == 'root' {
    $home_dir = '/root'
  } else {
    $home_dir = "/home/${$user}"
  }

  exec { "phpbrew_download":
    command => "curl -L -o /tmp/phpbrew https://raw.github.com/c9s/phpbrew/master/phpbrew",
    user => $user,
    path => ['/usr/bin', '/usr/sbin', '/bin'],
    unless => "test -d ${$home_dir}/.phpbrew",
    require => Package["php5-cli"]
  } ->
  exec { "phpbrew":
    command => "mv /tmp/phpbrew /usr/bin/phpbrew && chmod +x /usr/bin/phpbrew",
    user => 'root',
    path => ['/usr/bin', '/usr/sbin', '/bin'],
    creates => "/usr/bin/phpbrew",
  } ->
  exec { "phpbrew_init":
    command => "phpbrew init",
    user => $user,
    cwd => "${$home_dir}",
    environment => "HOME=${$home_dir}",
    path => ['/usr/bin', '/usr/sbin', '/bin'],
    creates => "$home_dir/.phpbrew",
  } ->
  file_line { "phpbrew_bashrc":
    path => "${$home_dir}/.bashrc",
    line => "source ${$home_dir}/.phpbrew/bashrc",
  }
}
