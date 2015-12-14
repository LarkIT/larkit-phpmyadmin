# == Class phpmyadmin::install
#
# This class is called from phpmyadmin for install.
#
class phpmyadmin::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $::phpmyadmin::package_name:
    ensure => $::phpmyadmin::version,
  }
}
