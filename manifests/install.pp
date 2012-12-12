class puppetmaster::install {
  package { $puppetmaster::puppet_packages:
    ensure => $puppetmaster::puppet_package_version,
  }

  # We only want the puppetmaster package installed
  # if we plan on running it standalone.
  if $::puppetmaster::service_enable {
    package { $puppetmaster::master_package:
      ensure => $puppetmaster::master_package_version,
    }
  }
}
