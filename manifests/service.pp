class puppetmaster::service {
  if $::puppetmaster::service_enable {
    service { $puppetmaster::service:
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }

  service { $puppetmaster::agent_service:
      ensure     => $puppetmaster::agent_enable,
      enable     => $puppetmaster::agent_enable,
      hasstatus  => true,
      hasrestart => true,
  }
}
