# == Class: phpbrew
#
# Installs php versions
#
# === Parameters
# version - the php version
# extension - the extension name
# home_dir - the home_dir from php
# entry - the entry name
# value - the value of the entry
# ensure - present|absent of the setting
#
# === Examples
#
#   phpbrew::extension::inisettings {
#     'force_display_errors':
#       version => '5.3.29',
#       extension => 'xdebug',
#       entry => 'Xdebug/force_display_errors',
#       value => '1';
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
define phpbrew::extension::inisettings
(
  $version = $name,
  $extension = '',
  $home_dir = $phpbrew::home_dir,
  $entry,
  $ensure = present,
  $value = '',
) {

  $changes = $ensure ? {
    present => [ "set '${entry}' '${value}'" ],
    absent => [ "rm '${entry}'" ],
  }
  augeas { "php_ini_${$version}_${$entry}_${$extension}":
    incl => "${$home_dir}/.phpbrew/php/php-${$version}/var/db/${$extension}.ini",
    lens => 'Php.lns',
    changes => $changes,
    require => Exec["phpbrew_install_php_${version}"]
  }
}