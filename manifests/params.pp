class puppetmaster::params {
  # These should be single-quoted.
  # Some of them contain variables that should
  # be expanded by the Puppet Master at runtime,
  # not by the agent when configuring the master.
  $puppet_packages = ['puppet', 'puppetmaster-common']
  $master_package  = 'puppetmaster'
  $service         = 'puppetmaster'
  $agent_service   = 'puppet'
  $user            = 'puppet'
  $group           = 'puppet'
  $logdir          = '/var/log/puppet'
  $vardir          = '/var/lib/puppet'
  $ssldir          = '/var/lib/puppet/ssl'
  $rundir          = '/run/puppet'
  $factpath        = '$vardir/lib/facter'
  $templatedir     = '$confdir/templates'
  $confdir         = '/etc/puppet'
  $manifest        = '$manifestdir/site.pp'
  $manifestdir     = '$confdir/manifests'
  $modulepath      = '$confdir/modules'
  $hiera_config    = '/etc/hiera.yaml'

  # This is where the Puppet package (puppet-common on Debian)
  # installed the 'config.ru' file. We may need to copy it if
  # we want to run the master under Unicorn.
  $config_ru_source = '/usr/share/puppet/ext/rack/files/config.ru'
}
