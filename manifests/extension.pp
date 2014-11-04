# == Class: phpbrew
#
# Installs php extensions
#
# === Parameters
# version - the php version for the extension
# package_name - the extension name
# user - the user for the installation of phpbrew
# stability - stability of the extension
# ini_settings - ini settings with hiera hash
#
# === Examples
#
#  phpbrew::extension {'xdebug':
#    extension_name => 'xdebug',
#    version => '5.4.32'
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
define phpbrew::extension (
  $extension_name = '',
  $version = '',
  $stability = 'stable',
  $user = 'vagrant',
  $ini_settings = {},
) {
  validate_string($stability)
  validate_string($user)
  validate_string($extension_name)
  validate_string($version)
  validate_string($extra_params)

  if $user == 'root' {
    $home_dir = '/root'
  } else {
    $home_dir = "/home/${$user}"
  }

  # some devel dependencies might be needed
  if 'curl' in $extension_name {
    ensure_packages ('libcurl3-dev')
  }
  if 'memcached' in $extension_name {
    $extra_params = "--disable-memcached-sasl"
    ensure_packages ('libmemcached-dev')
  }
  if 'gd' in $extension_name {
    ensure_packages ('libpng12-dev')
    Package['libpng12-dev'] -> exec["phpbrew_install_php_${version}_extension"]
  }

  exec { "phpbrew_switch_php_${version}_${$extension_name}":
    command => "bash -c 'source ${$home_dir}/.phpbrew/bashrc && phpbrew use php-${version} && phpbrew ext install ${$extension_name} stable -- ${$extra_params} && phpbrew ext enable ${$extension_name}'",
    user => $user,
    environment => [
      "HOME=${$home_dir}",
      "PHPBREW_ROOT=${$home_dir}/.phpbrew",
      "PHPBREW_PATH=${$home_dir}/.phpbrew/php/php-5.3.29/bin",
      "PHPBREW_BIN=${$home_dir}/.phpbrew/bin",
      "PHPBREW_PHP=php-${version}",
      "PHPBREW_HOME=${$home_dir}/.phpbrew",
    ],
    path => ['/usr/bin', '/usr/sbin', '/bin'],
    timeout => 0,
    creates => "${$home_dir}/.phpbrew/php/php-${version}/var/db/${$extension_name}.ini",
    require => Exec["phpbrew_install_php_${version}"]
  }
  validate_hash($ini_settings)
  create_resources('phpbrew::extension::inisettings', $ini_settings)
}
