class puppetmaster::unicorn (
  $worker_processes,
  $socket                  = '/run/puppet/puppetmaster_unicorn.sock',
  $socket_backlog          = '64',
  $port                    = undef,
  $tcp_nopush              = true,
  $timeout                 = '120',
  $pid_file                = '/run/puppet/puppetmaster_unicorn.pid',
  $check_client_connection = true,
  $upstart_job             = true,
  $unicorn_rb              = "${puppetmaster::confdir}/unicorn.rb",
  $unicorn_rb_template     = 'puppetmaster/unicorn.conf.rb.erb',
  $upstart_environment     = {}
) {

  include puppetmaster

  exec { 'puppetmaster::unicorn::copy-config.ru':
    cwd     => $puppetmaster::confdir,
    command => "cp -a ${puppetmaster::params::config_ru_source} config.ru",
    path    => '/bin',
    creates => "${puppetmaster::confdir}/config.ru",
  }

  file { $unicorn_rb:
    ensure  => 'present',
    content => template($unicorn_rb_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $upstart_job {
    file { '/usr/local/bin/puppetmaster':
      ensure  => 'present',
      content => template('puppetmaster/puppetmaster.rb.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }

    upstart::job { 'puppetmaster-unicorn':
      description    => 'Puppet Master running under Unicorn',
      respawn        => true,
      respawn_limit  => '5 10',
      kill_signal    => 'QUIT',
      kill_timeout   => '120',
      user           => $::puppetmaster::user,
      group          => $::puppetmaster::group,
      chdir          => $::puppetmaster::confdir,
      environment    => merge({ 'HOME' => $::puppetmaster::vardir }, $upstart_environment),
      exec           => '/usr/local/bin/puppetmaster',
      restart        => 'pkill -USR2 -u puppet -f "puppet master"',
      require        => File['/usr/local/bin/puppetmaster'],
      subscribe      => [ File[$unicorn_rb],
                          Class['puppetmaster::config'] ],
    }
  }
}
