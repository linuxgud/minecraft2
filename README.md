# Puppet Minecraft module
This is my minecraft puppet module, with some scripts to start and manage an vanilla server running multiple instances on CentOS 7.

To activate this module use:
```puppet
class { 'minecraft': }
```
To crate an minecraft instance use:
```puppet
minecraft::instance { 'final':
  version => 'latest',
  eula    => 'true',
  port    => hiera("minecraft::instance::final::port", '25572'),
  state   => 'running',
  xms     => '1024M',
  xmx     => '3584M'
}
```
