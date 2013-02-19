class puppetmaster::config {

  $puppet_conf = "${puppetmaster::confdir}/puppet.conf"

  File {
    owner  => 'root',
    group  => 'root',
  }

  Ini_Setting {
    ensure => present,
    path   => $puppet_conf,
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

  ### [main]
  ini_setting { 'puppet.conf-main-logdir':
    section => 'main',
    setting => 'logdir',
    value   => $::puppetmaster::logdir,
  }

  ini_setting { 'puppet.conf-main-vardir':
    section => 'main',
    setting => 'vardir',
    value   => $::puppetmaster::vardir,
  }

  ini_setting { 'puppet.conf-main-ssldir':
    section => 'main',
    setting => 'ssldir',
    value   => $::puppetmaster::ssldir,
  }

  ini_setting { 'puppet.conf-main-rundir':
    section => 'main',
    setting => 'rundir',
    value   => $::puppetmaster::rundir,
  }

  ini_setting { 'puppet.conf-main-factpath':
    section => 'main',
    setting => 'factpath',
    value   => $::puppetmaster::factpath,
  }

  ini_setting { 'puppet.conf-main-hiera_config':
    section => 'main',
    setting => 'hiera_config',
    value   => $::puppetmaster::hiera_config,
  }

  ini_setting { 'puppet.conf-main-environment':
    section => 'main',
    setting => 'environment',
    value   => $::puppetmaster::environment,
  }

  ini_setting { 'puppet.conf-main-certname':
    section => 'main',
    setting => 'certname',
    value   => $::puppetmaster::certname,
  }

  if !empty($::puppetmaster::dns_alt_names) {
    ini_setting { 'puppet.conf-main-dns_alt_names':
      section => 'main',
      setting => 'dns_alt_names',
      value   => join($::puppetmaster::dns_alt_names, ','),
    }
  }

  if !empty($::puppetmaster::ca_server) {
    ini_setting { 'puppet.conf-main-ca_server':
      section => 'main',
      setting => 'ca_server',
      value   => $::puppetmaster::ca_server,
    }
  }

  ### [master]
  ini_setting { 'puppet.conf-master-ssl_client_header':
    section => 'master',
    setting => 'ssl_client_header',
    value   => $::puppetmaster::ssl_client_header,
  }

  ini_setting { 'puppet.conf-master-ssl_client_verify_header':
    section => 'master',
    setting => 'ssl_client_verify_header',
    value   => $::puppetmaster::ssl_client_verify_header,
  }

  ini_setting { 'puppet.conf-master-autosign':
    section => 'master',
    setting => 'autosign',
    value   => $::puppetmaster::autosign,
  }

  ini_setting { 'puppet.conf-master-manifest':
    section => 'master',
    setting => 'manifest',
    value   => $::puppetmaster::manifest,
  }

  ini_setting { 'puppet.conf-master-manifestdir':
    section => 'master',
    setting => 'manifestdir',
    value   => $::puppetmaster::manifestdir,
  }

  ini_setting { 'puppet.conf-master-templatedir':
    section => 'master',
    setting => 'templatedir',
    value   => $::puppetmaster::templatedir,
  }

  ini_setting { 'puppet.conf-master-modulepath':
    section => 'master',
    setting => 'modulepath',
    value   => $::puppetmaster::modulepath,
  }

  ini_setting { 'puppet.conf-master-filetimeout':
    section => 'master',
    setting => 'filetimeout',
    value   => $::puppetmaster::filetimeout,
  }

  ini_setting { 'puppet.conf-master-ca_name':
    section => 'master',
    setting => 'ca_name',
    value   => $::puppetmaster::ca_name,
  }

  ini_setting { 'puppet.conf-master-ca':
    section => 'master',
    setting => 'ca',
    value   => $::puppetmaster::ca,
  }

  if !empty($::puppetmaster::node_terminus) {
    ini_setting { 'puppet.conf-master-node_terminus':
      section => 'master',
      setting => 'node_terminus',
      value   => $::puppetmaster::node_terminus,
    }
  }

  if !empty($::puppetmaster::external_nodes) {
    ini_setting { 'puppet.conf-master-external_nodes':
      section => 'master',
      setting => 'external_nodes',
      value   => $::puppetmaster::external_nodes,
    }
  }

  ### [agent]
  ini_setting { 'puppet.conf-agent-report':
    section => 'agent',
    setting => 'report',
    value   => $::puppetmaster::report,
  }

  ini_setting { 'puppet.conf-agent-server':
    section => 'agent',
    setting => 'server',
    value   => $::puppetmaster::server,
  }

  ini_setting { 'puppet.conf-agent-runinterval':
    section => 'agent',
    setting => 'runinterval',
    value   => $::puppetmaster::runinterval,
  }

  ini_setting { 'puppet.conf-agent-splay':
    section => 'agent',
    setting => 'splay',
    value   => $::puppetmaster::splay,
  }

  ini_setting { 'puppet.conf-agent-splaylimit':
    section => 'agent',
    setting => 'splaylimit',
    value   => $::puppetmaster::splaylimit,
  }

  ini_setting { 'puppet.conf-agent-noop':
    section => 'agent',
    setting => 'noop',
    value   => $::puppetmaster::noop_mode,
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
      require => Ini_Setting['puppet.conf-main-certname'],
    }
  }
}
