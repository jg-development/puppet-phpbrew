# == Class: phpbrew
#
# Installs php versions
#
# === Parameters
# version - the php version
# package_name - the extension name
# user - the user for the installation of phpbrew
# build_parameters - additional build_parameters
# ini_settings - ini settings with hiera hash
# fpm_settings - fpm settings with hiera hash
#
# === Examples
#
#  phpbrew::php { '5.4.32': }
#
# === Authors
#
# Author Name <jgantzert@template-provider.com>
#
# === Copyright
#
# Copyright 2014 Jan Gantzert.
#
define phpbrew::php (
  $version = $name,
  $buildparameters = undef,
  $user = 'vagrant',
  $ini_settings = {},
  $fpm_settings = {},
) {
  require phpbrew

  if $buildparameters == undef {
    $extra_params = "+bcmath+bz2+calendar+cli+ctype+dba+debug+dom+exif+fileinfo+filter+fpm+ftp+gd+gettext+hash+iconv+icu+imap+intl+ipc+ipv6+json+kerberos+mbregex+mbstring+mcrypt+mhash+mysql+openssl+pcntl+pcre+pdo+pgsql+phar+posix+readline+session+soap+sockets+sqlite+tidy+tokenizer+xml_all+xmlrpc+zip+zlib"
  }

  if $user == 'root' {
    $home_dir = '/root'
  } else {
    $home_dir = "/home/${$user}"
  }

  ## bug in ensure_packages with metaparameters https://tickets.puppetlabs.com/browse/MODULES-1323
  ## workaround with ordering like "exec["phpbrew_install_php_${version}"] -> Package['libicu-dev']"

  # some devel dependencies might be needed
  if '+icu' in $extra_params {
    ensure_packages (['libicu-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libicu-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+openssl' in $extra_params {
    ensure_packages (['libssl-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libssl-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+xml_all' in $extra_params or '+default' in $extra_params {
    ensure_packages ( ['libxml2-dev', 'libxslt1-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libxml2-dev', 'libxslt1-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+bz2' in $extra_params or '+default' in $extra_params {
    ensure_packages (['libbz2-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libbz2-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+mcrypt' in $extra_params {
    ensure_packages (['libmcrypt-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libmcrypt-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+pgsql' in $extra_params {
    ensure_packages (['libpq-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libpq-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+readline' in $extra_params or '+default' in $extra_params {
    ensure_packages (['libreadline-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libreadline-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+tidy' in $extra_params {
    ensure_packages (['libtidy-dev'],
#      {"before" => "Exec['phpbrew_install_php_${version}']",}
    )
    Package['libtidy-dev'] -> exec["phpbrew_install_php_${version}"]
  }
  if '+gd' in $extra_params {
    ensure_packages ( ['libpng12-dev'],
#      { 'before' => Exec["phpbrew_install_php_${version}"]}
    )
    Package['libpng12-dev'] -> exec["phpbrew_install_php_${version}"]
  }

  exec { "phpbrew_install_php_${version}":
    command => "/usr/bin/phpbrew install --old php-${version} ${$extra_params}",
    user => $user,
    environment => ["HOME=${$home_dir}", "PHPBREW_ROOT=${$home_dir}/.phpbrew"],
    creates => "${$home_dir}/.phpbrew/php/php-${version}/bin/php",
    timeout => 0,
  }

  validate_hash($ini_settings)
  create_resources('phpbrew::inisettings', $ini_settings)
  create_resources('phpbrew::fpmsettings', $fpm_settings)
}