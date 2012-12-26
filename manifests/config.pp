class puppetmaster::config {
  File {
    owner  => 'root',
    group  => 'root',
  }

  file { $puppetmaster::confdir:
    ensure => 'directory',
    mode   => '0755',
  }

  file { '/etc/default/puppet':
    ensure  => 'present',
    mode    => '0644',
    content => template('puppetmaster/etc_default_puppet.erb'),
  }

  file { "${puppetmaster::confdir}/puppet.conf":
    ensure  => 'present',
    content => template($puppetmaster::puppet_conf_template),
  }

  # Only CA servers should generate their own cert.
  if $::puppetmaster::ca {
    # Autosign needs to be explicitly set to false to avoid a bug
    # in the cert generate command. Certs generated in this way
    # are sign automatically regardless of whether autosign is
    # enabled or not. See: http://projects.puppetlabs.com/issues/6112
    $cert_file = "${::puppetmaster::ssldir}/certs/${::puppetmaster::certname}.pem"
    $cert_command = "puppet cert generate --autosign false ${::puppetmaster::certname}"

    exec { 'puppetmaster::cert::generate':
      path    => '/usr/bin:/bin',
      command => $cert_command,
      creates => $cert_file,
      user    => 'root',
      group   => 'root',
      require => File["${puppetmaster::confdir}/puppet.conf"],
    }
  }
}
