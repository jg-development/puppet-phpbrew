# == Class: phpbrew
#
# Installs php versions
#
# === Parameters
# version - the php version
# home_dir - the home_dir from php
# entry - the entry name
# value - the value of the entry
# ensure - present|absent of the setting
#
# === Examples
#
#   phpbrew::inisettings {
#     'memory_limit':
#       version => '5.3.29',
#       entry => 'PHP/memory_limit',
#       value => '256M';
#     'timezone':
#       version => '5.3.29',
#       entry => 'Date/date.timezone',
#       value => 'Europe/Berlin';
#   }
#
# === Authors
#
# Author Name <jgantzert@template-provider.com>
#
# === Copyright
#
# Copyright 2014 Jan Gantzert.
#
define phpbrew::inisettings
(
  $version = $name,
  $home_dir = $phpbrew::home_dir,
  $entry,
  $ensure = present,
  $value = '',
) {

  $changes = $ensure ? {
    present => [ "set '${entry}' '${value}'" ],
    absent => [ "rm '${entry}'" ],
  }
  augeas { "php_ini_${$version}_${$entry}":
    incl => "${$home_dir}/.phpbrew/php/php-${$version}/etc/php.ini",
    lens => 'Php.lns',
    changes => $changes,
    require => Exec["phpbrew_install_php_${version}"]
  }
}