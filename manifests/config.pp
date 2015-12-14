# == Class phpmyadmin::config
#
# This class is called from phpmyadmin for service config.
#
class phpmyadmin::config (
  $config      = $::phpmyadmin::real_config,
  $secret      = $::phpmyadmin::secret,
  $servers     = $::phpmyadmin::servers,
){

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { $::phpmyadmin::config_file:
    ensure  => file,
    mode    => '0440',
    owner   => $::phpmyadmin::www_user,
    group   => $::phpmyadmin::www_group,
    content => template("${module_name}/config.inc.php.erb"),
  }


}
