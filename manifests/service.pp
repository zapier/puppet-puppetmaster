class puppetmaster::service {
  if $::puppetmaster::service_enable {
    service { $puppetmaster::service:
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
