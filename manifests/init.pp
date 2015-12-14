# Class: phpmyadmin
# ===========================
#
# Puppet module to manage phpMyAdmin.  phpMyAdmin is a web-based administration tool for MySQL.
#
# Parameters
# ----------
#
# [*config*]
#   Configuration parameters to apply to phpmyadmin
#   Hashs.  Default {}
#
# [*servers*]
#   Servers to add to the Configuration
#   Array of Hashes.  Default {}
#
# [*config_file*]
#   Configuration file for phpMyAdmin
#   String.
#
# [*package_name*]
#   Name of the phpMyAdmin package
#
# [*www_user*]
#   User name the config file should be owend by.  This will typically be your web server
#
# [*www_group*]
#   Group the config file should be owend by.  This will typically be your web server
#
# [*version*]
#   String.  Version of phpMyAdmin to install
#   Default: present
#
class phpmyadmin (
  $config         = {},
  $servers        = [],
  $config_file    = $::phpmyadmin::params::config_file,
  $package_name   = $::phpmyadmin::params::package_name,
  $secret         = $::phpmyadmin::params::secret,
  $www_user       = $::phpmyadmin::params::www_user,
  $www_group      = $::phpmyadmin::params::www_group,
  $version        = $::phpmyadmin::params::version,
) inherits ::phpmyadmin::params {

  if !is_hash($config) {
    fail('::phpmyadmin::config must be a hash')
  }

  if !is_array($servers) {
    fail('::phpmyadmin::servers must be an array of hashes')
  }

  validate_absolute_path($config_file)

  $real_config = merge($::phpmyadmin::params::default_config, $config)

  class { '::phpmyadmin::install': } ->
  class { '::phpmyadmin::config': } ->
  Class['::phpmyadmin']
}
