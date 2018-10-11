class minecraft::config {
  file { '/srv/minecraft':
    ensure => 'directory',
    mode   => '0755',
  }

  file { '/etc/systemd/system/minecraft@.service':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/minecraft/minecraft@.service',
    notify => Exec['daemon-reload']
  }

  if !defined(Exec['daemon-reload']) {
    exec { 'daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true;
    }
  }

  file { '/srv/minecraft/get-minecraft-download-url.py':
    source  => 'puppet:///modules/minecraft/get-minecraft-download-url.py',
    mode    => '0544',
    require => File['/srv/minecraft'],
  }

  file { '/srv/minecraft/update-minecraft-facts.py':
    source  => 'puppet:///modules/minecraft/update-minecraft-facts.py',
    mode    => '0544',
    require => File['/srv/minecraft'],
  }

  cron { 'update-minecraft-facts':
    command => '/srv/minecraft/update-minecraft-facts.py',
    minute  => '*/30',
    require => File['/srv/minecraft/update-minecraft-facts.py'],
  }
}