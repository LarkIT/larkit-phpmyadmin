# == Class phpmyadmin::params
#
# This class is meant to be called from phpmyadmin.
# It sets variables according to platform.
#
class phpmyadmin::params {

  $default_config = {
    'UploadDir' => '/var/lib/phpMyAdmin/upload',
    'SaveDir'   => '/var/lib/phpMyAdmin/save',
  }
  $secret = fqdn_rand(99999999999999999)
  $version = 'present'

  case $::osfamily {
    'RedHat', 'Amazon': {
      $package_name = 'phpMyAdmin'
      $config_file  = '/etc/phpMyAdmin/config.inc.php'
      $www_user     = 'apache'
      $www_group    = 'apache'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
