class puppetmaster (
  $puppet_packages          = $puppetmaster::params::puppet_packages,
  $puppet_package_version   = 'installed',
  $master_package           = $puppetmaster::params::master_package,
  $master_package_version   = 'installed',
  $service                  = $puppetmaster::params::service,
  $service_enable           = true,
  $user                     = $puppetmaster::params::user,
  $group                    = $puppetmaster::params::group,
  $logdir                   = $puppetmaster::params::logdir,
  $vardir                   = $puppetmaster::params::vardir,
  $ssldir                   = $puppetmaster::params::ssldir,
  $rundir                   = $puppetmaster::params::rundir,
  $factpath                 = $puppetmaster::params::factpath,
  $templatedir              = $puppetmaster::params::templatedir,
  $environment              = 'production',
  $certname                 = $::fqdn,
  $dns_alt_names            = [],
  $server                   = '',
  $confdir                  = $puppetmaster::params::confdir,
  $manifest                 = $puppetmaster::params::manifest,
  $manifestdir              = $puppetmaster::params::manifestdir,
  $modulepath               = $puppetmaster::params::modulepath,
  $hiera_config             = $puppetmaster::params::hiera_config,
  $filetimeout              = '15s',
  $node_terminus            = '',
  $external_nodes           = '',
  $agent_enable             = true,
  $agent_service            = $puppetmaster::params::agent_service,
  $runinterval              = '30m',
  $splay                    = false,
  $splaylimit               = '$runinterval',
  $noop_mode                = false,
  $ca                       = true,
  $ca_name                  = 'Puppet CA: $certname',
  $ca_server                = '',
  $autosign                 = false,
  $report                   = true,
  $ssl_client_header        = 'SSL_CLIENT_S_DN',
  $ssl_client_verify_header = 'SSL_CLIENT_VERIFY',
  $puppet_conf_template     = 'puppetmaster/puppet.conf.erb'
) inherits puppetmaster::params {

  validate_bool($service_enable)
  validate_bool($ca)
  validate_bool($autosign)
  validate_bool($report)
  validate_bool($agent_enable)
  validate_bool($splay)

  validate_array($dns_alt_names)

  anchor { 'puppetmaster::begin':
    before => Class['puppetmaster::install'],
    notify => Class['puppetmaster::service'],
  }

  class { 'puppetmaster::install':
    notify => Class['puppetmaster::service'],
  }

  class { 'puppetmaster::config':
    require => Class['puppetmaster::install'],
    notify  => Class['puppetmaster::service'],
  }

  class { 'puppetmaster::service': }

  anchor { 'puppetmaster::end':
    require => Class['puppetmaster::service'],
  }
}
