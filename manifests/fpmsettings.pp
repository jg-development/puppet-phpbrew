# == Class: phpbrew
#
# Installs php versions
#
# === Parameters
# version - the php version
# home_dir - the home_dir from php
# package_name - the extension name
# user - the user for the installation of phpbrew
# stability - stability of the extension
#
# === Examples
#
#   phpbrew::fpmsettings {
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
define phpbrew::fpmsettings
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
  augeas { "php_fpm_${$version}_${entry}":
    incl => "${$home_dir}/.phpbrew/php/php-${$version}/etc/php-fpm.conf",
    lens => 'Php.lns',
    changes => $changes,
    require => Exec["phpbrew_install_php_${version}"]
  }
}